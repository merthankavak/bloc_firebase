import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/base/viewmodel/base_view_model.dart';
import '../../../product/blocs/auth/auth_bloc.dart';
import '../../../product/cubits/cubits.dart';

class ProfileViewModel extends BaseViewModel {
  @override
  void setContext(BuildContext context) => baseContext = context;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  GlobalKey<FormState> changeNameFormKey = GlobalKey();
  GlobalKey<FormState> changePasswordFormKey = GlobalKey();

  TextEditingController? nameTextController;
  TextEditingController? currentPasswordTextController;
  TextEditingController? newPasswordTextController;
  TextEditingController? confirmNewPasswordTextController;

  @override
  void init() {
    final String uid = baseContext.read<AuthBloc>().state.user!.uid;
    baseContext.read<ProfileCubit>().getProfileData(uid: uid);
    nameTextController = TextEditingController();
    currentPasswordTextController = TextEditingController();
    newPasswordTextController = TextEditingController();
    confirmNewPasswordTextController = TextEditingController();
  }
}
