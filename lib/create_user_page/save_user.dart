import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:why_appen/create_user_page/create_user_page.dart'; // Import Firestore

class SaveUser extends StatelessWidget {
  const SaveUser({
    Key? key,
    required this.selectedImage,
    required this.updateNameController,
    required this.userId,
    required this.imagePath
  }) : super(key: key);

  final File? selectedImage;
  final Function(String) updateNameController;
  final String userId;
  final String imagePath;

  Future<void> _uploadImage(BuildContext context) async {
    if (selectedImage == null) {
      // Handle case where no image is selected
      FirebaseFirestore.instance.collection('users').doc(userId).set({
        'name': nameController.text,
        'imagePath': imagePath, // Save the download URL as imagePath
      }).then(
              (_) => AwesomeDialog(
            context: context,
            animType: AnimType.leftSlide,
            headerAnimationLoop: false,
            dialogType: DialogType.success,
            showCloseIcon: true,
            title: 'Hej ${nameController.text}',
            desc:
            "Ditt konto och din profil är skapad, när kontor har godkännts kan du börja spara träningar",
            btnOkOnPress: () {
              Navigator.of(context).pop();
            },
            btnOkIcon: Icons.check_circle,
            onDismissCallback: (type) {
              debugPrint('Dialog Dissmiss from callback $type');
            },
          ).show());
    }

    try {
      // Upload image to Firebase Storage with ".jpg" extension and content type "image/jpeg"
      final firebaseStorageRef = FirebaseStorage.instance.ref().child('images/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await firebaseStorageRef.putFile(
        selectedImage!,
        SettableMetadata(contentType: 'image/jpeg'), // Set content type to "image/jpeg"
      );

      // Get download URL
      final String downloadURL = await firebaseStorageRef.getDownloadURL();

      // Save user data to Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'name': nameController.text,
        'imagePath': downloadURL, // Save the download URL as imagePath
      }).then(
              (_) => AwesomeDialog(
            context: context,
            animType: AnimType.leftSlide,
            headerAnimationLoop: false,
            dialogType: DialogType.success,
            showCloseIcon: true,
            title: 'Hej ${nameController.text}',
            desc:
            "Ditt konto och din profil är skapad, när kontor har godkännts kan du börja spara träningar",
            btnOkOnPress: () {
              Navigator.of(context).pop();
            },
            btnOkIcon: Icons.check_circle,
            onDismissCallback: (type) {
              debugPrint('Dialog Dissmiss from callback $type');
            },
          ).show());

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
        onPressed: () => _uploadImage(context), // Call _uploadImage function on button press
        child: Text(
          'Spara',
          style: TextStyle(color: Colors.grey[300], fontSize: 22),
        ),
      ),
    );
  }
}
