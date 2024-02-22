import 'package:flutter/material.dart';
import 'package:why_appen/sign_up_page/create_account_password__check.dart';
import 'create_account_btn.dart';
import 'create_account_email.dart';
import 'create_account_password.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordController1 = TextEditingController();
  final TextEditingController passwordControllerCheck = TextEditingController();

  SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.grey[300],
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  Image.asset('assets/images/why-logotyp-clean.webp',
                      width: 300, height: 150),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            create_account_email(emailController: emailController),
                            create_account_password(passwordController: passwordController),
                            create_account_password_check(passwordControllerCheck: passwordControllerCheck),
                          ],
                        ),
                        Column(
                          children: [
                            create_account_btn(emailController: emailController, passwordController: passwordController, passwordControllerCheck: passwordControllerCheck),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}


