import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../model/custom_error_model.dart';
import '../../repositories/geolocation_repository.dart';

part 'geolocation_state.dart';

class GeolocationCubit extends Cubit<GeolocationState> {
  final GeolocationRepository geolocationRepository;

  GeolocationCubit({
    required this.geolocationRepository,
  }) : super(GeolocationState.initial());

  Future<void> getCurrentLocation() async {
    emit(state.copyWith(geolocationStatus: GeolocationStatus.loading));

    try {
      final Position position = await geolocationRepository.getCurrentLocation();
      emit(state.copyWith(geolocationStatus: GeolocationStatus.loaded, position: position));
    } on CustomErrorModel catch (e) {
      emit(state.copyWith(geolocationStatus: GeolocationStatus.error, customErrorModel: e));
    }
  }
}
