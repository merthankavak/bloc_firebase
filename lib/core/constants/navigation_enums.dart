enum NavigationEnums {
  splashView('/'),
  loginView('/loginView'),
  registerView('/registerView'),
  homeView('/homeView'),
  profileView('/profileView');

  final String routeName;
  const NavigationEnums(this.routeName);
}
