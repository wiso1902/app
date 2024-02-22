import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:why_appen/widgets/palatte.dart';

class email_text extends StatelessWidget {
  const email_text({
    super.key,
    required this.emailController,
  });

  final TextEditingController emailController;

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