import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';

import '../../../core/base/view/base_view.dart';
import '../../../product/blocs/auth/auth_bloc.dart';
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
            }
            return Column(
              children: [
                buildUserCard(context, state),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.badge_outlined),
                    title: const Text('Change Name'),
                    subtitle: const Text('You can change your name'),
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return SizedBox(
                              height: context.mediaQuery.viewInsets.bottom > 0
                                  ? context.height * 0.75
                                  : context.height * 0.4,
                              child: buildChangeFullNameForm(viewModel, context),
                            );
                          });
                    },
                  ),
                ),
                context.emptySizedHeightBoxLow3x,
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.badge_outlined),
                    title: const Text('Change Password'),
                    subtitle: const Text('You can change your password'),
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return SizedBox(
                              height: context.mediaQuery.viewInsets.bottom > 0
                                  ? context.height * 0.9
                                  : context.height * 0.6,
                              child: buildChangePasswordForm(viewModel, context),
                            );
                          });
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Form buildChangePasswordForm(ProfileViewModel viewModel, BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.always,
      key: viewModel.changePasswordFormKey,
      child: Padding(
        padding: context.paddingMedium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Change Password', style: Theme.of(context).textTheme.subtitle1!),
            context.emptySizedHeightBoxNormal,
            TextFormField(
              controller: viewModel.currentPasswordTextController,
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Password required!';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters long';
                }
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                filled: true,
                labelText: 'Current Password',
                prefixIcon: Icon(Icons.password),
              ),
            ),
            context.emptySizedHeightBoxLow3x,
            TextFormField(
              controller: viewModel.newPasswordTextController,
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Password required!';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 characters long';
                }
                if (viewModel.currentPasswordTextController!.text == value) {
                  return 'Same as your previous password!';
                }
                return null;
              },
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                filled: true,
                labelText: 'New Password',
                prefixIcon: Icon(Icons.password),
              ),
            ),
            context.emptySizedHeightBoxLow3x,
            TextFormField(
              controller: viewModel.confirmNewPasswordTextController,
              validator: (String? value) {
                if (viewModel.newPasswordTextController!.text != value) {
                  return 'Password not match!';
                }
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                isDense: true,
                labelText: 'Confirm New Password',
                prefixIcon: Icon(Icons.password),
              ),
            ),
            context.emptySizedHeightBoxLow,
            TextButton(
              onPressed: () {
                context.read<ProfileCubit>().updatePassword(
                      currentPassword: viewModel.currentPasswordTextController!.text,
                      newPassword: viewModel.confirmNewPasswordTextController!.text,
                    );
                context.pop();
              },
              child: const Center(
                child: Text('Update'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Form buildChangeFullNameForm(ProfileViewModel viewModel, BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.always,
      key: viewModel.changeNameFormKey,
      child: Padding(
        padding: context.paddingMedium,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Change Name', style: Theme.of(context).textTheme.subtitle1!),
            context.emptySizedHeightBoxNormal,
            TextFormField(
              controller: viewModel.nameTextController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Name required!';
                }
                if (value.trim().length < 2) {
                  return 'Enter a valid name!';
                }
                return null;
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                filled: true,
                labelText: 'Name',
                prefixIcon: Icon(Icons.account_box),
              ),
            ),
            context.emptySizedHeightBoxLow3x,
            TextButton(
              onPressed: () {
                context.read<ProfileCubit>().updateProfileData(
                    uid: context.read<AuthBloc>().state.user!.uid,
                    name: viewModel.nameTextController!.text);
                context.pop();
              },
              child: const Center(
                child: Text('Update'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card buildUserCard(BuildContext context, ProfileState state) {
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
  }
}
