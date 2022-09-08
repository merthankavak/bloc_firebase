import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

import '../../../../core/base/viewmodel/base_view_model.dart';
import '../../../../core/constants/navigation_enums.dart';
import '../../../../product/blocs/auth/auth_bloc.dart';

class SplashViewModel extends BaseViewModel {
  @override
  void setContext(BuildContext context) => baseContext = context;
  @override
  void init() {}

  void checkIfAuth(AuthStatus authStatus) {
    Future.delayed(baseContext.durationSlow).then((value) {
      if (authStatus == AuthStatus.unauthenticated) {
        navigation.router.go(NavigationEnums.loginView.routeName);
      } else if (authStatus == AuthStatus.authenticated) {
        navigation.router.go(NavigationEnums.homeView.routeName);
      }
    });
  }
}
