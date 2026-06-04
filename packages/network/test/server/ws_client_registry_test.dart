import 'dart:io';

import 'package:network/server/ws_client_registry.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:test/test.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

Future<WebSocketChannel> _openTestChannel(int port) async {
  final channel = WebSocketChannel.connect(
    Uri.parse('ws://127.0.0.1:$port/ws'),
  );
  await channel.ready;
  return channel;
}

void main() {
  group('WsClientRegistry', () {
    late WsClientRegistry registry;
    late HttpServer httpServer;
    late int port;

    setUp(() async {
      registry = WsClientRegistry();
      final router = Router()
        ..get('/ws', webSocketHandler((_) {}));

      httpServer = await shelf_io.serve(
        router.call,
        InternetAddress.loopbackIPv4,
        0,
      );
      port = httpServer.port;
    });

    tearDown(() async {
      await httpServer.close(force: true);
    });

    test('add / get / count / isConnected', () async {
      final channel = await _openTestChannel(port);

      expect(registry.count, 0);
      expect(registry.isConnected('waiter-1'), isFalse);

      registry.add('waiter-1', channel);
      expect(registry.count, 1);
      expect(registry.isConnected('waiter-1'), isTrue);
      expect(registry.get('waiter-1'), same(channel));
      expect(registry.all, hasLength(1));

      await channel.sink.close();
    });

    test('remove diminue le count', () async {
      final channelA = await _openTestChannel(port);
      final channelB = await _openTestChannel(port);

      registry.add('waiter-1', channelA);
      registry.add('waiter-2', channelB);
      expect(registry.count, 2);

      registry.remove('waiter-1');
      expect(registry.count, 1);
      expect(registry.isConnected('waiter-1'), isFalse);
      expect(registry.isConnected('waiter-2'), isTrue);

      await channelA.sink.close();
      await channelB.sink.close();
    });

    test('clear vide le registre', () async {
      final channel = await _openTestChannel(port);
      registry.add('waiter-1', channel);
      registry.clear();
      expect(registry.count, 0);
      await channel.sink.close();
    });
  });
}
