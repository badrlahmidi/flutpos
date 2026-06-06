library network;

// Protocol
export 'protocol/event_envelope.dart';
export 'protocol/ws_action.dart';
export 'protocol/event_serializer.dart';
export 'protocol/order_snapshot_codec.dart';
export 'protocol/pos_server_status.dart';

// Server (Desktop)
export 'server/pos_network_server.dart';
export 'server/ws_client_registry.dart';
export 'server/ws_message_handler.dart';

// Client (Mobile)
export 'client/connection_state.dart';
export 'client/connection_state_notifier.dart';
export 'client/network_sender.dart';
export 'client/waiter_network_client.dart';

// Sync
export 'sync/sync_queue_manager.dart';

// mDNS
export 'package:ns_ds_network/ns_ds_network.dart';
