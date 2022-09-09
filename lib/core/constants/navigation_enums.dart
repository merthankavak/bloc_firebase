enum NavigationEnums {
  splashView('/'),
  loginView('/loginView'),
  registerView('/registerView'),
  tabView('/tabView'),
  homeView('/homeView'),
  profileView('/profileView'),
  mapsView('/mapsView');

  final String routeName;
  const NavigationEnums(this.routeName);
}
