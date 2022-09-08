import 'package:flutter/material.dart';

import '../../init/navigation/navigation_service.dart';

abstract class BaseViewModel {
  late BuildContext baseContext;

  NavigationService navigation = NavigationService.instance;

  void setContext(BuildContext context);
  void init();
}
