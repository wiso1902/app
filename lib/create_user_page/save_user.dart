import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

import 'create_user_page.dart'; // Import AwesomeDialog

class SaveUser extends StatefulWidget {
  const SaveUser({
    Key? key,
    required this.selectedImage,
    required this.updateNameController,
    required this.userId,
    required this.imagePath,
    required this.context,
  }) : super(key: key);

  final File? selectedImage;
  final String userId;
  final Function(String) updateNameController;
  final String imagePath;
  final BuildContext context;

  @override
  _SaveUserState createState() => _SaveUserState();
}

class _SaveUserState extends State<SaveUser> {
  bool _isUploading = false;

  Future<void> _uploadImage(BuildContext context) async {
    setState(() {
      _isUploading = true;
    });

    try {
      if (widget.selectedImage == null) {
        // Handle case where no image is selected
        await FirebaseFirestore.instance.collection('users').doc(widget.userId).set({
          'name': nameController.text, // Assuming nameController is defined somewhere
          'imagePath': widget.imagePath, // Save the provided imagePath
        });

        // Show success dialog
        AwesomeDialog(
          context: context,
          animType: AnimType.leftSlide,
          headerAnimationLoop: false,
          dialogType: DialogType.success,
          showCloseIcon: true,
          title: 'Hi ${nameController.text}', // Assuming nameController is defined somewhere
          desc: "Your account has been created and is waiting for approval.",
          btnOkOnPress: () {
            Navigator.of(context).pop();
          },
          btnOkIcon: Icons.check_circle,
          onDismissCallback: (type) {
            debugPrint('Dialog Dismiss from callback $type');
          },
        ).show();

        print('User data saved successfully');

        setState(() {
          _isUploading = false;
        });
        return;
      }

      // Upload image to Firebase Storage with ".jpg" extension and content type "image/jpeg"
      final firebaseStorageRef = FirebaseStorage.instance.ref().child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await firebaseStorageRef.putFile(
        widget.selectedImage!,
        SettableMetadata(contentType: 'image/jpeg'), // Set content type to "image/jpeg"
      );

      // Get download URL
      final String downloadURL = await firebaseStorageRef.getDownloadURL();

      // Save user data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(widget.userId).set({
        'name': nameController.text, // Assuming nameController is defined somewhere
        'imagePath': downloadURL, // Save the download URL as imagePath
      });

      // Show success dialog
      AwesomeDialog(
        context: context,
        animType: AnimType.leftSlide,
        headerAnimationLoop: false,
        dialogType: DialogType.success,
        showCloseIcon: true,
        title: 'Hi ${nameController.text}', // Assuming nameController is defined somewhere
        desc: "Your account has been created and is waiting for approval.",
        btnOkOnPress: () {
          Navigator.of(context).pop();
        },
        btnOkIcon: Icons.check_circle,
        onDismissCallback: (type) {
          debugPrint('Dialog Dismiss from callback $type');
        },
      ).show();

      print('User data saved successfully');
    } on FirebaseException catch (e) {
      // Handle specific Firebase errors
      print('Error uploading image: ${e.message}');
    } on PlatformException catch (e) {
      // Handle platform-specific errors
      print('Error uploading image: ${e.message}');
    } catch (e) {
      // Handle other errors
      print('Error uploading image: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextButton(
        onPressed: _isUploading ? null : () => _uploadImage(context), // Disable button while uploading
        child: _isUploading
            ? CircularProgressIndicator() // Show loading indicator while uploading
            : Text(
          'Save',
          style: TextStyle(color: Colors.grey[300], fontSize: 22),
        ),
      ),
    );
  }
}
