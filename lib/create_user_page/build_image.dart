import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BuildImage extends StatefulWidget {
  const BuildImage({
    Key? key,
    required this.imagePath,
    required this.setImage,
  }) : super(key: key);

  final String imagePath;
  final void Function(File?)
      setImage; // Explicitly declare the type of setImage

  @override
  _BuildImageState createState() => _BuildImageState();
}

class _BuildImageState extends State<BuildImage> {
  File? _selectedFile;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _selectedFile = File(pickedFile.path); // Assign the selected file to _selectedFile
        widget.setImage(_selectedFile); // Set the selected image file in the parent widget
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: ClipOval(
            child: Material(
              color: Colors.transparent,
              child: _selectedFile != null
                  ? Ink.image(
                      image: FileImage(_selectedFile!),
                      fit: BoxFit.cover,
                      width: 128,
                      height: 128,
                      child: InkWell(
                        onTap: _pickImage,
                      ),
                    )
                  : Ink.image(
                      image: NetworkImage(widget.imagePath),
                      fit: BoxFit.cover,
                      width: 128,
                      height: 128,
                      child: InkWell(
                        onTap: _pickImage,
                      ),
                    ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 50,
          child: ClipOval(
            child: Container(
              padding: EdgeInsets.all(3),
              color: Colors.white,
              child: ClipOval(
                child: Container(
                  padding: EdgeInsets.all(8),
                  color: Colors.orange,
                  child: const Icon(
                    Icons.edit,
                    size: 25,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
