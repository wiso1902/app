import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:why_appen/create_user_page/save_user.dart';

import 'build_image.dart';
import 'create_name_field.dart';

class create_user_page extends StatefulWidget {
  create_user_page(
      {Key? key, required this.userId, required this.enableBackButton})
      : super(key: key);

  final String userId;
  final bool enableBackButton;

  @override
  State<create_user_page> createState() => _create_user_pageState();
}

TextEditingController nameController = TextEditingController();
String imagePath =
    'https://firebasestorage.googleapis.com/v0/b/databas-be99f.appspot.com/o/why-avatar.png?alt=media&token=8f0a28db-9a3a-4607-b172-70c6b509ca94';

class _create_user_pageState extends State<create_user_page> {
  File? _selectedImage;

  void _setImage(File? image) {
    setState(() {
      _selectedImage = image;
    });
  }

  void updateNameController(String newName) {
    setState(() {
      nameController.text = newName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: widget.enableBackButton,
        title: const Align(
          alignment: Alignment.center,
          child: Text(
            "Spara Namn",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.abc,
              color: Colors.white,
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade200,
      body: ListView(
        padding: const EdgeInsets.all(90.0),
        physics: const BouncingScrollPhysics(),
        children: [
          BuildImage(
            imagePath: imagePath,
            setImage: _setImage,
          ),
          create_name(
            nameController: nameController,
          ),
          SaveUser(
            selectedImage: _selectedImage,
            updateNameController: updateNameController,
            userId: widget.userId,
            imagePath: imagePath,
            context: context,
          ),
        ],
      ),
    );
  }
}
