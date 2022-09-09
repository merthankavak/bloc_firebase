import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/base/viewmodel/base_view_model.dart';
import '../../../../core/constants/navigation_enums.dart';
import '../../../../product/cubits/cubits.dart';
import '../../../../product/model/custom_error_model.dart';
import '../../../../product/utility/error_dialog.dart';

class LoginViewModel extends BaseViewModel {
  @override
  void setContext(BuildContext context) => baseContext = context;

  GlobalKey<FormState> formKey = GlobalKey();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  TextEditingController? emailTextController;
  TextEditingController? passwordTextController;

  @override
  void init() {
    emailTextController = TextEditingController();
    passwordTextController = TextEditingController();
  }

  void listenLoginState(LoginStatus loginStatus, CustomErrorModel customErrorModel) {
    if (loginStatus == LoginStatus.error) {
      ErrorDialog.showMessage(scaffoldKey, customErrorModel);
    }
    if (loginStatus == LoginStatus.success) {
      navigation.router.go(NavigationEnums.tabView.routeName);
    }
  }

  void navigateSignUpWithRichText(LoginStatus loginStatus) {
    if (loginStatus == LoginStatus.submitting) return;
    navigation.router.go(NavigationEnums.registerView.routeName);
  }

  void loginApp(LoginStatus loginStatus) {
    if (loginStatus == LoginStatus.submitting) return;
    if (!formKey.currentState!.validate()) return;
    baseContext
        .read<LoginCubit>()
        .signIn(email: emailTextController!.text, password: passwordTextController!.text);
  }
}
