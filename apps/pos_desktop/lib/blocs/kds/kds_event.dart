import 'package:equatable/equatable.dart';

sealed class KdsEvent extends Equatable {
  const KdsEvent();

  @override
  List<Object?> get props => [];
}

final class KdsStarted extends KdsEvent {
  const KdsStarted();
}

final class KdsRefreshRequested extends KdsEvent {
  const KdsRefreshRequested();
}

final class KdsItemReadyPressed extends KdsEvent {
  const KdsItemReadyPressed({
    required this.orderItemId,
    required this.orderId,
    required this.productName,
  });

  final String orderItemId;
  final String orderId;
  final String productName;

  @override
  List<Object?> get props => [orderItemId, orderId, productName];
}
