import 'package:core/core.dart';
import 'package:drift/native.dart';
import 'package:network/client/waiter_network_client.dart';
import 'package:network/protocol/event_envelope.dart';
import 'package:network/protocol/order_snapshot_codec.dart';
import 'package:network/protocol/ws_action.dart';
import 'package:network/server/pos_network_server.dart';
import 'package:network/server/ws_message_handler.dart';
import 'package:test/test.dart';

import '../helpers/lan_sync_seed.dart';

const _ackSuccess = 'SUCCESS';
const _deviceId = 'waiter-e2e-test';
const _userRole = UserRole.waiter;

void main() {
  group('P2-3 — sync mobile ↔ PC', () {
    late AppDatabase pcDb;
    late AppDatabase mobileDb;
    late PosNetworkServer server;
    late WaiterNetworkClient client;
    late OrderRepository mobileOrders;
    late CashSessionRepository mobileCash;

    setUp(() async {
      pcDb = AppDatabase(NativeDatabase.memory());
      mobileDb = AppDatabase(NativeDatabase.memory());
      await LanSyncSeed.seedPosCatalog(pcDb);
      await LanSyncSeed.seedMobileCatalog(mobileDb);

      mobileOrders = OrderRepositoryImpl(mobileDb, AuditRepositoryImpl(mobileDb));
      mobileCash = CashSessionRepositoryImpl(
        mobileDb,
        AuditRepositoryImpl(mobileDb),
      );

      server = PosNetworkServer(
        database: pcDb,
        port: 0,
        announceMdns: false,
      );
      await server.start();

      client = WaiterNetworkClient(
        database: mobileDb,
        deviceId: _deviceId,
      );
      await client.connect('127.0.0.1', server.boundPort!);
    });

    tearDown(() async {
      await client.dispose();
      await server.stop();
      await pcDb.close();
      await mobileDb.close();
    });

    Future<EventEnvelope> sendAck(EventEnvelope envelope) {
      return client.sendAndAwaitAck(envelope);
    }

    void assertSuccess(EventEnvelope ack, String step) {
      expect(ack.action, WsAction.ack);
      expect(ack.payload['status'], _ackSuccess, reason: '$step: ${ack.payload['message']}');
    }

    Future<CompleteOrder?> mirrorFromAck(EventEnvelope ack) async {
      final snapshot = OrderSnapshotCodec.decodePayload(ack.payload);
      if (snapshot == null) {
        return null;
      }
      final session = await mobileCash.getAnyOpenSession();
      expect(session, isNotNull);
      return mobileOrders.mirrorOrderSnapshot(
        localSessionId: session!.id,
        snapshot: snapshot,
      );
    }

    test('CREATE_ORDER → miroir → ADD_ITEMS → miroir (WebSocket)', () async {
      final status = await client.fetchPosStatus();
      expect(status?.hasOpenSession, isTrue);

      final createAck = await sendAck(
        EventEnvelope.create(
          action: WsAction.createOrder,
          deviceId: _deviceId,
          userRole: _userRole,
          payload: {
            'tableId': LanSyncSeed.tableId,
            'guestCount': 2,
            'waiterId': LanSyncSeed.waiterId,
            'orderId': LanSyncSeed.orderId,
          },
        ),
      );
      assertSuccess(createAck, 'CREATE_ORDER');
      expect(createAck.payload['orderId'], LanSyncSeed.orderId);

      final syncAfterCreate = await sendAck(
        EventEnvelope.create(
          action: WsAction.getOpenOrder,
          deviceId: _deviceId,
          userRole: _userRole,
          payload: {'tableId': LanSyncSeed.tableId},
        ),
      );
      assertSuccess(syncAfterCreate, 'GET_OPEN_ORDER');
      final mirroredEmpty = await mirrorFromAck(syncAfterCreate);
      expect(mirroredEmpty, isNotNull);
      expect(mirroredEmpty!.order.id, LanSyncSeed.orderId);
      expect(mirroredEmpty.items, isEmpty);

      final addAck = await sendAck(
        EventEnvelope.create(
          action: WsAction.addItems,
          deviceId: _deviceId,
          userRole: _userRole,
          payload: {
            'orderId': LanSyncSeed.orderId,
            'productId': LanSyncSeed.productId,
            'orderItemId': LanSyncSeed.orderItemId,
            'courseNumber': 1,
            'quantity': 1,
            'customNotes': 'بدون بصل',
          },
        ),
      );
      assertSuccess(addAck, 'ADD_ITEMS');
      expect(addAck.payload['orderItemId'], LanSyncSeed.orderItemId);

      final syncAfterAdd = await sendAck(
        EventEnvelope.create(
          action: WsAction.getOpenOrder,
          deviceId: _deviceId,
          userRole: _userRole,
          payload: {'tableId': LanSyncSeed.tableId},
        ),
      );
      assertSuccess(syncAfterAdd, 'GET_OPEN_ORDER après ADD_ITEMS');
      final mirrored = await mirrorFromAck(syncAfterAdd);

      expect(mirrored, isNotNull);
      expect(mirrored!.order.id, LanSyncSeed.orderId);
      expect(mirrored.items, hasLength(1));
      expect(mirrored.items.single.orderItem.id, LanSyncSeed.orderItemId);
      expect(mirrored.items.single.product.id, LanSyncSeed.productId);
      expect(mirrored.items.single.orderItem.customNotes, 'بدون بصل');
      expect(mirrored.items.single.orderItem.isFired, isFalse);

      final pcOrder = await OrderRepositoryImpl(
        pcDb,
        AuditRepositoryImpl(pcDb),
      ).getCompleteOrder(LanSyncSeed.orderId);
      expect(pcOrder?.items.single.orderItem.id, LanSyncSeed.orderItemId);
    });

    test('CREATE_ORDER idempotent si ticket déjà ouvert', () async {
      await sendAck(
        EventEnvelope.create(
          action: WsAction.createOrder,
          deviceId: _deviceId,
          userRole: _userRole,
          payload: {
            'tableId': LanSyncSeed.tableId,
            'orderId': LanSyncSeed.orderId,
            'waiterId': LanSyncSeed.waiterId,
          },
        ),
      );

      final secondCreate = await sendAck(
        EventEnvelope.create(
          action: WsAction.createOrder,
          deviceId: _deviceId,
          userRole: _userRole,
          payload: {'tableId': LanSyncSeed.tableId},
        ),
      );
      assertSuccess(secondCreate, 'CREATE_ORDER idempotent');
      expect(secondCreate.payload['orderId'], LanSyncSeed.orderId);
    });

    test('CREATE_ORDER refusé sans session caisse PC', () async {
      final closedDb = AppDatabase(NativeDatabase.memory());
      addTearDown(closedDb.close);
      await LanSyncSeed.seedPosCatalog(closedDb);
      final cashRepo = CashSessionRepositoryImpl(
        closedDb,
        AuditRepositoryImpl(closedDb),
      );
      final session = await cashRepo.getAnyOpenSession();
      expect(session, isNotNull);
      await cashRepo.closeSession(
        userId: LanSyncSeed.cashierId,
        sessionId: session!.id,
        closingBalance: 500,
        expectedBalance: 500,
      );

      final handler = WsMessageHandler(
        orderRepository: OrderRepositoryImpl(
          closedDb,
          AuditRepositoryImpl(closedDb),
        ),
        cashSessionRepository: CashSessionRepositoryImpl(
          closedDb,
          AuditRepositoryImpl(closedDb),
        ),
        productRepository: ProductRepositoryImpl(closedDb),
      );

      final ack = await handler.handle(
        EventEnvelope.create(
          action: WsAction.createOrder,
          deviceId: _deviceId,
          userRole: _userRole,
          payload: {'tableId': LanSyncSeed.tableId},
        ),
      );

      expect(ack.payload['status'], AckStatus.error);
      expect(ack.payload['message'], contains('session caisse'));
    });
  });
}
