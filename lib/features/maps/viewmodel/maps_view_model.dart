import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/base/viewmodel/base_view_model.dart';
import '../../../product/cubits/cubits.dart';

class MapsViewModel extends BaseViewModel {
  @override
  void setContext(BuildContext context) => baseContext = context;

  Completer<GoogleMapController>? mapController;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void init() {
    mapController = Completer();
    baseContext.read<GeolocationCubit>().getCurrentLocation();
  }
}
