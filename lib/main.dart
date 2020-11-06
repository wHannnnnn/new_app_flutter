import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'index/index.dart';
import 'routes/routes.dart';
import 'provider/provider.dart';
void main() {
  return runApp(MultiProvider(
    providers: providers,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: onGenerateRoute,
    );
  }
}
