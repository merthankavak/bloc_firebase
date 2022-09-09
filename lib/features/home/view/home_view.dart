import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/base/view/base_view.dart';
import '../../../core/constants/navigation_enums.dart';
import '../../../product/blocs/auth/auth_bloc.dart';
import '../viewmodel/home_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeViewModel>(
      viewModel: HomeViewModel(),
      onModelReady: (model) {
        model.setContext(context);
        model.init();
      },
      onPageBuilder: (BuildContext context, HomeViewModel viewModel) => Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                context.read<AuthBloc>().add(SignOutRequestedEvent());
                viewModel.navigation.router.go(NavigationEnums.loginView.routeName);
              },
              icon: const Icon(Icons.exit_to_app),
            )
          ],
        ),
        body: const Center(
          child: Text('Home'),
        ),
      ),
    );
  }
}
