import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kartal/kartal.dart';

import '../../../../core/base/view/base_view.dart';
import '../../../../product/blocs/auth/auth_bloc.dart';
import '../viewmodel/splash_view_model.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<SplashViewModel>(
      viewModel: SplashViewModel(),
      onModelReady: (model) {
        model.setContext(context);
        model.init();
      },
      onPageBuilder: (BuildContext context, SplashViewModel viewModel) =>
          BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) => viewModel.checkIfAuth(state.authStatus),
        builder: (context, state) {
          return Scaffold(
              backgroundColor: context.colorScheme.primary,
              body: Center(
                  child: CircularProgressIndicator.adaptive(
                      backgroundColor: context.colorScheme.onPrimary)));
        },
      ),
    );
  }
}
