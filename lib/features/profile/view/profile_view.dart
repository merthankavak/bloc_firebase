import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';

import '../../../core/base/view/base_view.dart';
import '../../../core/constants/navigation_enums.dart';
import '../../../product/cubits/cubits.dart';
import '../../../product/utility/error_dialog.dart';
import '../viewmodel/profile_view_model.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<ProfileViewModel>(
      viewModel: ProfileViewModel(),
      onModelReady: (model) {
        model.setContext(context);
        model.init();
      },
      onPageBuilder: (BuildContext context, ProfileViewModel viewModel) => Scaffold(
        key: viewModel.scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Profile'),
          leading: IconButton(
              onPressed: () {
                viewModel.navigation.router.go(NavigationEnums.homeView.routeName);
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state.profileStatus == ProfileStatus.error) {
              ErrorDialog.showMessage(viewModel.scaffoldKey, state.customErrorModel);
            }
          },
          builder: (context, state) {
            if (state.profileStatus == ProfileStatus.initial) {
              return const SizedBox.shrink();
            } else if (state.profileStatus == ProfileStatus.loading) {
              return const Center(child: CircularProgressIndicator.adaptive());
            } else if (state.profileStatus == ProfileStatus.error) {
              return const Center(child: Text('Something went wrong'));
            }
            return Card(
              margin: context.paddingLow,
              elevation: 10,
              child: Padding(
                padding: context.paddingNormal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(state.userModel.profileImage),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(state.userModel.name),
                        Text(state.userModel.email),
                        Text(state.userModel.rank),
                        Text(state.userModel.point.toString()),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
