import 'package:flutter/material.dart';

class UserInfo with ChangeNotifier {
  String name;
  String phone;

  UserInfo({this.name = "", this.phone});

  void update(UserInfo userInfo) {
    this.name = userInfo.name;
    this.phone = userInfo.phone;
    notifyListeners();
  }
}