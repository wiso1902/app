import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/palatte.dart';

class create_account_password_check extends StatelessWidget {
  const create_account_password_check({
    super.key,
    required this.passwordControllerCheck,
  });

  final TextEditingController passwordControllerCheck;

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
            hintText: 'Lösenord',
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
          controller: passwordControllerCheck,
        ),
      ),
    );
  }
}