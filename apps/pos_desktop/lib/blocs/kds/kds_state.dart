import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

sealed class KdsState extends Equatable {
  const KdsState();

  @override
  List<Object?> get props => [];
}

final class KdsInitial extends KdsState {
  const KdsInitial();
}

final class KdsLoading extends KdsState {
  const KdsLoading();
}

final class KdsReady extends KdsState {
  const KdsReady({
    required this.tickets,
    this.lastReadyProductName,
  });

  final List<KdsOrderTicket> tickets;
  final String? lastReadyProductName;

  int get pendingLineCount =>
      tickets.fold<int>(0, (sum, t) => sum + t.pendingItems.length);

  @override
  List<Object?> get props => [tickets.length, lastReadyProductName];
}

final class KdsError extends KdsState {
  const KdsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
