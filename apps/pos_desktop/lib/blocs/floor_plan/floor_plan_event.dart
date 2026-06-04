import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

sealed class FloorPlanEvent extends Equatable {
  const FloorPlanEvent();

  @override
  List<Object?> get props => [];
}

final class FloorPlanStarted extends FloorPlanEvent {
  const FloorPlanStarted(this.user);

  final User user;

  @override
  List<Object?> get props => [user.id];
}

final class FloorPlanRefreshRequested extends FloorPlanEvent {
  const FloorPlanRefreshRequested();
}

final class FloorPlanZoneSelected extends FloorPlanEvent {
  const FloorPlanZoneSelected(this.zoneIndex);

  final int zoneIndex;

  @override
  List<Object?> get props => [zoneIndex];
}

/// Table libre — ouverture avec couverts.
final class FloorPlanOpenTableRequested extends FloorPlanEvent {
  const FloorPlanOpenTableRequested({
    required this.tableId,
    required this.guestCount,
  });

  final String tableId;
  final int guestCount;

  @override
  List<Object?> get props => [tableId, guestCount];
}

/// Table occupée — reprise du ticket.
final class FloorPlanResumeTableRequested extends FloorPlanEvent {
  const FloorPlanResumeTableRequested({
    required this.orderId,
    required this.tableName,
  });

  final String orderId;
  final String tableName;

  @override
  List<Object?> get props => [orderId, tableName];
}

final class FloorPlanTransferRequested extends FloorPlanEvent {
  const FloorPlanTransferRequested({
    required this.orderId,
    required this.targetTableId,
  });

  final String orderId;
  final String targetTableId;

  @override
  List<Object?> get props => [orderId, targetTableId];
}

final class FloorPlanMergeRequested extends FloorPlanEvent {
  const FloorPlanMergeRequested({
    required this.targetOrderId,
    required this.sourceOrderId,
  });

  final String targetOrderId;
  final String sourceOrderId;

  @override
  List<Object?> get props => [targetOrderId, sourceOrderId];
}

final class FloorPlanNavigationHandled extends FloorPlanEvent {
  const FloorPlanNavigationHandled();
}
