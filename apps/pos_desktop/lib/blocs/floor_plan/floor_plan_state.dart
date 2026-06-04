import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

sealed class FloorPlanState extends Equatable {
  const FloorPlanState();

  @override
  List<Object?> get props => [];
}

final class FloorPlanInitial extends FloorPlanState {
  const FloorPlanInitial();
}

final class FloorPlanLoading extends FloorPlanState {
  const FloorPlanLoading();
}

final class FloorPlanReady extends FloorPlanState {
  const FloorPlanReady({
    required this.zones,
    required this.selectedZoneIndex,
    this.navigateToPos,
  });

  final List<FloorPlanZoneSnapshot> zones;
  final int selectedZoneIndex;
  final FloorPlanPosNavigation? navigateToPos;

  FloorPlanZoneSnapshot? get selectedZone {
    if (zones.isEmpty || selectedZoneIndex >= zones.length) {
      return null;
    }
    return zones[selectedZoneIndex];
  }

  FloorPlanReady copyWith({
    List<FloorPlanZoneSnapshot>? zones,
    int? selectedZoneIndex,
    FloorPlanPosNavigation? navigateToPos,
    bool clearNavigation = false,
  }) {
    return FloorPlanReady(
      zones: zones ?? this.zones,
      selectedZoneIndex: selectedZoneIndex ?? this.selectedZoneIndex,
      navigateToPos:
          clearNavigation ? null : (navigateToPos ?? this.navigateToPos),
    );
  }

  @override
  List<Object?> get props => [
        zones.length,
        selectedZoneIndex,
        navigateToPos?.orderId,
      ];
}

final class FloorPlanPosNavigation {
  const FloorPlanPosNavigation({
    required this.orderId,
    required this.tableName,
  });

  final String orderId;
  final String tableName;
}

final class FloorPlanError extends FloorPlanState {
  const FloorPlanError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
