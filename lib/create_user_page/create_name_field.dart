import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/palatte.dart';

class create_name extends StatelessWidget {
  const create_name({
    super.key,
    required this.nameController,
  });

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[500]?.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
        ),
        child: TextField(
          decoration: const InputDecoration(
            contentPadding:
            EdgeInsets.symmetric(vertical: 10),
            border: InputBorder.none,
            hintText: 'Användarnamn',
            hintStyle: kBodytext,
          ),
          textAlign: TextAlign.center,
          style: kBodytext,
          textInputAction: TextInputAction.done,
          controller: nameController,
        ),
      ),
    );
  }
}