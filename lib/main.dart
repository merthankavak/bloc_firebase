import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/init/navigation/navigation_service.dart';
import 'features/auth/login/cubit/login_cubit.dart';
import 'features/auth/register/cubit/register_cubit.dart';
import 'features/profile/cubit/profile_cubit.dart';
import 'firebase_options.dart';
import 'product/blocs/auth/auth_bloc.dart';
import 'product/repositories/auth_repository.dart';
import 'product/repositories/profile_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final navigationService = NavigationService.instance;
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(
              firebaseFirestore: FirebaseFirestore.instance, firebaseAuth: FirebaseAuth.instance),
        ),
        RepositoryProvider<ProfileRepository>(
          create: (context) => ProfileRepository(firebaseFirestore: FirebaseFirestore.instance),
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<
                  AuthRepository>(), // Auth repositorye context read diyerek erişim verebiliriz.
            ),
          ),
          BlocProvider<LoginCubit>(
            create: (context) => LoginCubit(
              authRepository: context.read<
                  AuthRepository>(), // Auth repositorye context read diyerek erişim verebiliriz.
            ),
          ),
          BlocProvider<RegisterCubit>(
            create: (context) => RegisterCubit(
              authRepository: context.read<
                  AuthRepository>(), // Auth repositorye context read diyerek erişim verebiliriz.
            ),
          ),
          BlocProvider<ProfileCubit>(
            create: (context) => ProfileCubit(
              profileRepository: context.read<
                  ProfileRepository>(), // Profile repositorye context read diyerek erişim verebiliriz.
            ),
          ),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          routeInformationParser: navigationService.router.routeInformationParser,
          routeInformationProvider: navigationService.router.routeInformationProvider,
          routerDelegate: navigationService.router.routerDelegate,
        ),
      ),
    );
  }
}
