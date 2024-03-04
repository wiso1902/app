import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:why_appen/widgets/palatte.dart';

class password_field extends StatelessWidget {
  const password_field({
    super.key,
    required this.passwordController,
  });

  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[500]?.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextField(
          decoration: const InputDecoration(
            contentPadding:
            EdgeInsets.symmetric(vertical: 20),
            border: InputBorder.none,
            hintText: 'Password',
            prefixIcon: Padding(
              padding:
              EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                FontAwesomeIcons.lock,
                color: Colors.white,
                size: 30,
              ),
            ),
            hintStyle: kBodytext,
          ),
          style: kBodytext,
          keyboardType: TextInputType.emailAddress,
          obscureText: true,
          textInputAction: TextInputAction.done,
          controller: passwordController,
        ),
      ),
    );
  }
}