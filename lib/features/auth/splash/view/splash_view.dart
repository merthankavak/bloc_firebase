import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/navigation_enums.dart';
import '../../../../core/init/navigation/navigation_service.dart';
import '../../../../product/blocs/auth/auth_bloc.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (kDebugMode) {
          print('listener: $state');
        }
        if (state.authStatus == AuthStatus.unauthenticated) {
          Future.delayed(const Duration(seconds: 2)).then(
              (value) => NavigationService.instance.router.go(NavigationEnums.loginView.routeName));
        } else if (state.authStatus == AuthStatus.authenticated) {
          Future.delayed(const Duration(seconds: 2)).then(
              (value) => NavigationService.instance.router.go(NavigationEnums.homeView.routeName));
        }
      },
      builder: (context, state) {
        return const Scaffold(
          backgroundColor: Colors.black,
          body: Center(child: CircularProgressIndicator.adaptive()),
        );
      },
    );
  }
}
