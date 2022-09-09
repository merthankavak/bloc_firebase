import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kartal/kartal.dart';

import '../../../core/base/view/base_view.dart';
import '../../../product/cubits/cubits.dart';
import '../../../product/utility/error_dialog.dart';
import '../viewmodel/maps_view_model.dart';

class MapsView extends StatelessWidget {
  const MapsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<MapsViewModel>(
      viewModel: MapsViewModel(),
      onModelReady: (model) {
        model.setContext(context);
        model.init();
      },
      onPageBuilder: (BuildContext context, MapsViewModel viewModel) => Scaffold(
        key: viewModel.scaffoldKey,
        floatingActionButton: buildFloatingActionButton(viewModel),
        appBar: AppBar(centerTitle: true, title: const Text('Maps')),
        body: BlocConsumer<GeolocationCubit, GeolocationState>(
          listener: (context, state) {
            if (state.geolocationStatus == GeolocationStatus.error) {
              ErrorDialog.showMessage(viewModel.scaffoldKey, state.customErrorModel);
            }
          },
          builder: (context, state) {
            if (state.geolocationStatus == GeolocationStatus.initial) {
              return const SizedBox.shrink();
            } else if (state.geolocationStatus == GeolocationStatus.loading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else if (state.geolocationStatus == GeolocationStatus.error) {
              return const Center(child: Text('Something went wrong'));
            }
            return Stack(
              children: [
                SizedBox(
                  height: context.height,
                  width: context.width,
                  child: GoogleMap(
                    compassEnabled: false,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(state.position!.latitude, state.position!.longitude),
                        zoom: 5),
                    zoomControlsEnabled: false,
                    onMapCreated: (controller) => viewModel.mapController!.complete(controller),
                  ),
                ),
                Positioned(
                  top: 15,
                  left: 30,
                  right: 30,
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                        labelText: 'Search',
                        prefixIcon: const Icon(Icons.search),
                        contentPadding: context.paddingLow),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget buildFloatingActionButton(MapsViewModel viewModel) {
    return BlocBuilder<GeolocationCubit, GeolocationState>(
      builder: (context, state) {
        return FloatingActionButton(
          mini: true,
          onPressed: () async {
            final GoogleMapController controller = await viewModel.mapController!.future;
            controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                bearing: 192.8334901395799,
                target: LatLng(state.position!.latitude, state.position!.longitude),
                tilt: 59.440717697143555,
                zoom: 15)));
          },
          child: const Icon(Icons.near_me),
        );
      },
    );
  }
}
