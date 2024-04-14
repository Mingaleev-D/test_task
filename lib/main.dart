import 'package:flutter/material.dart';
import 'package:test_task/ui/pages/authentication_page/auth_page.dart';
import 'package:test_task/ui/pages/main_page/search_page.dart';
import 'package:test_task/ui/pages/main_page/task_main_page.dart';

import 'core/app_style.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        inputDecorationTheme: inputDecorationTheme,
      ),
      initialRoute: AuthPage.routeName,
      routes: {
        AuthPage.routeName: (context) => const AuthPage(),
        TaskMainPage.routeName: (context) => const TaskMainPage(),
        SearchPage.routeName: (context) => const SearchPage(),
      },
    );
  }
}
