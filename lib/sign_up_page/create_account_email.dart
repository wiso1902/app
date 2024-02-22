import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/palatte.dart';

class create_account_email extends StatelessWidget {
  const create_account_email({
    super.key,
    required this.emailController,
  });

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
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
            hintText: 'Email',
            prefixIcon: Padding(
              padding:
              EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                FontAwesomeIcons.envelope,
                color: Colors.white,
                size: 30,
              ),
            ),
            hintStyle: kBodytext,
          ),
          style: kBodytext,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          controller: emailController,
        ),
      ),
    );
  }
}