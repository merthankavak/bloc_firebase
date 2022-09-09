import 'package:flutter/material.dart';

import '../../../core/base/viewmodel/base_view_model.dart';
import '../../home/view/home_view.dart';
import '../../maps/view/maps_view.dart';
import '../../profile/view/profile_view.dart';
import '../model/tab_model.dart';

class TabViewModel extends BaseViewModel {
  @override
  void setContext(BuildContext context) => baseContext = context;

  List<TabModel> tabList = [];
  List<Widget> pageList = [];

  @override
  void init() {
    tabList.add(TabModel(tabName: 'Home', tabIcon: Icons.home));
    tabList.add(TabModel(tabName: 'Maps', tabIcon: Icons.map));
    tabList.add(TabModel(tabName: 'Profile', tabIcon: Icons.account_circle));
    pageList = [const HomeView(), const MapsView(), const ProfileView()];
  }
}
