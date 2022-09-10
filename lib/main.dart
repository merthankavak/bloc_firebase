import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/init/navigation/navigation_service.dart';
import 'firebase_options.dart';
import 'product/blocs/auth/auth_bloc.dart';
import 'product/cubits/cubits.dart';
import 'product/repositories/auth_repository.dart';
import 'product/repositories/geolocation_repository.dart';
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
        ),
        RepositoryProvider<GeolocationRepository>(create: (context) => GeolocationRepository())
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
              profileRepository: context.read<ProfileRepository>(),
              authRepository: context.read<
                  AuthRepository>(), // Profile repositorye context read diyerek erişim verebiliriz.
            ),
          ),
          BlocProvider<TabCubit>(create: (context) => TabCubit()),
          BlocProvider<GeolocationCubit>(
              create: (context) =>
                  GeolocationCubit(geolocationRepository: context.read<GeolocationRepository>())),
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
