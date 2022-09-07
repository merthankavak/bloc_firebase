import 'package:go_router/go_router.dart';

import '../../../features/auth/login/view/login_view.dart';
import '../../../features/auth/register/view/register_view.dart';
import '../../../features/auth/splash/view/splash_view.dart';
import '../../../features/home/view/home_view.dart';
import '../../../features/profile/view/profile_view.dart';
import '../../constants/navigation_enums.dart';

class NavigationService {
  static NavigationService? _instance;
  static NavigationService get instance {
    _instance ??= NavigationService._init();
    return _instance!;
  }

  NavigationService._init();

  final router = GoRouter(routes: [
    GoRoute(
        path: NavigationEnums.splashView.routeName,
        builder: (context, state) => const SplashView()),
    GoRoute(
        path: NavigationEnums.loginView.routeName, builder: (context, state) => const LoginView()),
    GoRoute(
        path: NavigationEnums.registerView.routeName,
        builder: (context, state) => const RegisterView()),
    GoRoute(
        path: NavigationEnums.homeView.routeName, builder: (context, state) => const HomeView()),
    GoRoute(
        path: NavigationEnums.profileView.routeName,
        builder: (context, state) => const ProfileView()),
  ]);
}
