import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/navigation_enums.dart';
import '../../../core/init/navigation/navigation_service.dart';
import '../../../product/blocs/auth/auth_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            onPressed: () {
              NavigationService.instance.router.go(NavigationEnums.profileView.routeName);
            },
            icon: const Icon(Icons.account_circle),
          ),
          IconButton(
            onPressed: () {
              context.read<AuthBloc>().add(SignOutRequestedEvent());
              NavigationService.instance.router.go(NavigationEnums.loginView.routeName);
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: const Center(
        child: Text('Home'),
      ),
    );
  }
}
