part of 'geolocation_cubit.dart';

enum GeolocationStatus { initial, loading, loaded, error }

class GeolocationState extends Equatable {
  final GeolocationStatus geolocationStatus;
  final Position? position;
  final CustomErrorModel customErrorModel;

  const GeolocationState({
    required this.geolocationStatus,
    this.position,
    required this.customErrorModel,
  });

  factory GeolocationState.initial() {
    return const GeolocationState(
      geolocationStatus: GeolocationStatus.initial,
      customErrorModel: CustomErrorModel(),
    );
  }

  @override
  List<Object?> get props => [geolocationStatus, position, customErrorModel];

  GeolocationState copyWith({
    GeolocationStatus? geolocationStatus,
    Position? position,
    CustomErrorModel? customErrorModel,
  }) {
    return GeolocationState(
      geolocationStatus: geolocationStatus ?? this.geolocationStatus,
      position: position ?? this.position,
      customErrorModel: customErrorModel ?? this.customErrorModel,
    );
  }

  @override
  String toString() =>
      'GeolocationState(geolocationStatus: $geolocationStatus, position: $position, customErrorModel: $customErrorModel)';
}
