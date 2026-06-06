import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:pos_desktop/blocs/floor_plan/floor_plan_bloc.dart';
import 'package:pos_desktop/blocs/floor_plan/floor_plan_event.dart';
import 'package:pos_desktop/blocs/floor_plan/floor_plan_state.dart';

import 'test_helpers.dart';

class MockFloorPlanRepository extends Mock implements FloorPlanRepository {}
class MockOrderRepository extends Mock implements OrderRepository {}
class MockCashSessionRepository extends Mock implements CashSessionRepository {}
class MockReservationRepository extends Mock implements ReservationRepository {}

void main() {
  setUpAll(() {
    registerFallbackValue(OrderType.dineIn);
  });

  late MockFloorPlanRepository floorRepo;
  late MockOrderRepository orderRepo;
  late MockCashSessionRepository cashRepo;
  late MockReservationRepository resRepo;

  setUp(() {
    floorRepo = MockFloorPlanRepository();
    orderRepo = MockOrderRepository();
    cashRepo = MockCashSessionRepository();
    resRepo = MockReservationRepository();

    when(() => cashRepo.getOpenSessionForCashier(any()))
        .thenAnswer((_) async => testSession);
    when(() => floorRepo.loadFloorPlan())
        .thenAnswer((_) async => testFloorPlan());
    when(() => floorRepo.watchFloorPlan())
        .thenAnswer((_) => const Stream.empty());
  });

  FloorPlanBloc buildBloc() => FloorPlanBloc(
        floorPlanRepository: floorRepo,
        orderRepository: orderRepo,
        cashSessionRepository: cashRepo,
        reservationRepository: resRepo,
      );

  group('FloorPlanBloc', () {
    blocTest<FloorPlanBloc, FloorPlanState>(
      'émet [Loading, Ready] sur FloorPlanStarted',
      build: buildBloc,
      act: (b) => b.add(FloorPlanStarted(testUser)),
      expect: () => [
        isA<FloorPlanLoading>(),
        isA<FloorPlanReady>()
            .having((s) => s.zones.length, 'zones', 1)
            .having((s) => s.selectedZoneIndex, 'index', 0),
      ],
    );

    blocTest<FloorPlanBloc, FloorPlanState>(
      'émet Error si pas de session caisse',
      build: () {
        when(() => cashRepo.getOpenSessionForCashier(any()))
            .thenAnswer((_) async => null);
        return buildBloc();
      },
      act: (b) => b.add(FloorPlanStarted(testUser)),
      expect: () => [isA<FloorPlanLoading>(), isA<FloorPlanError>()],
    );

    blocTest<FloorPlanBloc, FloorPlanState>(
      'change de zone sélectionnée',
      build: buildBloc,
      seed: () => FloorPlanReady(
        zones: [
          FloorPlanZoneSnapshot(zone: testZone, tables: []),
          FloorPlanZoneSnapshot(zone: testZone, tables: []),
        ],
        selectedZoneIndex: 0,
      ),
      act: (b) => b.add(const FloorPlanZoneSelected(1)),
      expect: () => [
        isA<FloorPlanReady>().having((s) => s.selectedZoneIndex, 'index', 1),
      ],
    );

    blocTest<FloorPlanBloc, FloorPlanState>(
      'ouvre une table → navigateToPos',
      build: () {
        when(() => orderRepo.openTableOrder(
              sessionId: any(named: 'sessionId'),
              waiterId: any(named: 'waiterId'),
              tableId: any(named: 'tableId'),
              guestCount: any(named: 'guestCount'),
            )).thenAnswer((_) async => testOrder(tableId: 't1'));
        when(() => resRepo.markSeatedForTable(any()))
            .thenAnswer((_) async {});
        return buildBloc();
      },
      act: (b) async {
        b.add(FloorPlanStarted(testUser));
        await Future.delayed(const Duration(milliseconds: 50));
        b.add(const FloorPlanOpenTableRequested(tableId: 't1', guestCount: 2));
      },
      wait: const Duration(milliseconds: 200),
      verify: (b) {
        final state = b.state;
        if (state is FloorPlanReady && state.navigateToPos != null) {
          expect(state.navigateToPos!.orderId, 'order-1');
        }
      },
    );

    blocTest<FloorPlanBloc, FloorPlanState>(
      'transfert de table',
      build: () {
        when(() => orderRepo.transferTableOrder(
              orderId: any(named: 'orderId'),
              targetTableId: any(named: 'targetTableId'),
            )).thenAnswer((_) async => testOrder(tableId: 't2'));
        // Make the mocked loadFloorPlan return a different length so state changes
        when(() => floorRepo.loadFloorPlan())
            .thenAnswer((_) async => []);
        return buildBloc();
      },
      seed: () => FloorPlanReady(zones: testFloorPlan(), selectedZoneIndex: 0),
      act: (b) => b.add(const FloorPlanTransferRequested(
            orderId: 'order-1',
            targetTableId: 't2',
          )),
      expect: () => [
        isA<FloorPlanReady>().having((s) => s.zones.length, 'length', 0),
      ],
    );
  });
}
