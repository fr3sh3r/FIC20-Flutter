import 'package:flutter/material.dart';

import '../../../core/core.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Assets.images.bgLogin.image(
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: ListView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 100.0, vertical: 50.0),
              children: [
                Padding(
                  padding: const EdgeInsets.all(85.0),
                  child: Assets.images.logoPrimary.image(),
                ),
                const SpaceHeight(30.0),
                CustomTextField(
                  showLabel: false,
                  controller: emailController,
                  label: 'Email Address',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Assets.icons.email.svg(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                const SpaceHeight(18.0),
                CustomTextField(
                  showLabel: false,
                  controller: passwordController,
                  label: 'Password',
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Assets.icons.password.svg(),
                  ),
                  obscureText: true,
                ),
                const SpaceHeight(80.0),
                Button.filled(
                  onPressed: () {
                    //context.pushReplacement(const MainPage());
                  },
                  label: 'Login',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
