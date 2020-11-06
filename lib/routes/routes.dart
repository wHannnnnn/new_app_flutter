import 'package:flutter/material.dart';
import 'package:new_project/page/login.dart';
import '../index/index.dart';
import '../page/form.dart';
import '../page/table.dart';
import '../page/listView.dart';
import '../page/gridView.dart';
import '../page/login.dart';
import '../page/scrollView.dart';
import '../page/Inherited.dart';
final routes = {
  '/': (context, {arguments}) => Index(),
  '/login': (context, {arguments}) => LoginPage(),
  '/form': (context, {arguments}) => FormPage(),
  '/table': (context, {arguments}) => TablePage(),
  '/listView': (context, {arguments}) => ListViewPage(),
  '/gridView': (context, {arguments}) => GridViewPage(),
  '/scrollView': (context, {arguments}) => ScrollViewPage(),
  '/Inherited': (context, {arguments}) => InheritedPage(),
};

var onGenerateRoute = (RouteSettings settings) {
  final String name = settings.name;
  final Function pageRouteName = routes[name];
  if (pageRouteName != null) {
    if (settings.arguments != null) {
      final route = MaterialPageRoute(
          builder: (context) =>
              pageRouteName(context, arguments: settings.arguments));
      return route;
    } else {
      final route = MaterialPageRoute(
          builder: (context) =>
              pageRouteName(context));
      return route;
    }
  }
};
