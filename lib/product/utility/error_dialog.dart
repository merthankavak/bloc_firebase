import 'package:flutter/material.dart';

import '../model/custom_error_model.dart';

class ErrorDialog {
  static void showMessage(GlobalKey<ScaffoldState>? scaffoldKey, CustomErrorModel? errorModel) {
    if (scaffoldKey == null || errorModel == null || scaffoldKey.currentContext == null) return;
    ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
        SnackBar(backgroundColor: Colors.black, content: Text(errorModel.message.toString())));
  }
}
