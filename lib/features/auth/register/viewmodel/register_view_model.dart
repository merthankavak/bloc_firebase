import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/viewmodel/base_view_model.dart';
import '../../../../core/constants/navigation_enums.dart';
import '../../../../product/cubits/cubits.dart';
import '../../../../product/model/custom_error_model.dart';
import '../../../../product/utility/error_dialog.dart';

class RegisterViewModel extends BaseViewModel {
  @override
  void setContext(BuildContext context) => baseContext = context;

  GlobalKey<FormState> formKey = GlobalKey();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  TextEditingController? nameTextController;
  TextEditingController? emailTextController;
  TextEditingController? passwordTextController;
  TextEditingController? confirmPasswordTextController;

  @override
  void init() {
    nameTextController = TextEditingController();
    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();
    confirmPasswordTextController = TextEditingController();
  }

  void listenRegisterState(RegisterStatus registerStatus, CustomErrorModel customErrorModel) {
    if (registerStatus == RegisterStatus.error) {
      ErrorDialog.showMessage(scaffoldKey, customErrorModel);
    }
    if (registerStatus == RegisterStatus.success) {
      navigation.router.go(NavigationEnums.homeView.routeName);
    }
  }

  void navigateSignInWithRichText(RegisterStatus registerStatus) {
    if (registerStatus == RegisterStatus.submitting) return;
    navigation.router.go(NavigationEnums.loginView.routeName);
  }

  void registerApp(RegisterStatus registerStatus) {
    if (registerStatus == RegisterStatus.submitting) return;
    if (!formKey.currentState!.validate()) return;
    baseContext.read<RegisterCubit>().signUp(
          name: nameTextController!.text,
          email: emailTextController!.text,
          password: passwordTextController!.text,
        );
  }
}
