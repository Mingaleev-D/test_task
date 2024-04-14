import 'package:flutter/material.dart';
import 'package:test_task/core/utils/shared_utils.dart';
import 'package:test_task/ui/pages/main_page/task_main_page.dart';

import '../../../data/service/api_service.dart';

class AuthPage extends StatefulWidget {
  static const routeName = '/auth_page';

  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();
  bool isVisible = false;

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeMQ = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Form(
            key: _loginFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: sizeMQ.width * 0.5,
                  child: TextFormField(
                    controller: _loginController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Заполните поле';
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Логин',
                    ),
                  ),
                ),
                SizedBox(height: sizeMQ.height * 0.02),
                SizedBox(
                  width: sizeMQ.width * 0.5,
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: isVisible,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Заполните поле';
                      }
                    },
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: 'Пароль',
                        suffixIcon: IconButton(
                            onPressed: () {
                              isVisible = !isVisible;
                              setState(() {});
                            },
                            icon: isVisible
                                ? const Icon(Icons.visibility_off)
                                : const Icon(
                                    Icons.visibility,
                                  ))),
                  ),
                ),
                SizedBox(height: sizeMQ.height * 0.02),
                SizedBox(
                  width: sizeMQ.width * 0.5,
                  child: FilledButton(
                      onPressed: () async {
                        if (_loginFormKey.currentState!.validate()) {
                          final user = await _apiService.loginAuth(
                              login: _loginController.text,
                              password: _passwordController.text);
                          print(user.accessToken);
                          if (user.accessToken != null) {
                            SharedUtils.saveToken(user.accessToken!);
                            Navigator.pushNamed(
                                context, TaskMainPage.routeName);
                          }
                        }
                      },
                      child: const Text('Вход')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
