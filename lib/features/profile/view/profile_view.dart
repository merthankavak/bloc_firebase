import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';

import '../../../core/constants/navigation_enums.dart';
import '../../../core/init/navigation/navigation_service.dart';
import '../../../product/blocs/auth/auth_bloc.dart';
import '../../../product/utility/error_dialog.dart';
import '../cubit/profile_cubit.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    final String uid = context.read<AuthBloc>().state.user!.uid;
    if (kDebugMode) {
      print(uid);
    }
    context.read<ProfileCubit>().getProfileData(uid: uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Profile'),
        leading: IconButton(
            onPressed: () {
              NavigationService.instance.router.go(NavigationEnums.homeView.routeName);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.profileStatus == ProfileStatus.error) {
            ErrorDialog.showMessage(_scaffoldKey, state.customErrorModel);
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
    );
  }
}
