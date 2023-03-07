import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '/theme.dart';

class UserImagePicker extends StatefulWidget {
  final void Function(File pickedImage) imagePickFunc;
  const UserImagePicker(this.imagePickFunc, {super.key});

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  // instance of ImagePicker()
  final ImagePicker _picker = ImagePicker();

// ============== Pick An Image Function ==============
  void _pickImage(ImageSource src) async {
    final XFile? pickedImageFile = await _picker.pickImage(
      source: src,

      // quality of the picture on firebase
      imageQuality: 80,
    );
    if (pickedImageFile == null) {
      return;
    }
    setState(() {
      _pickedImage = File(pickedImageFile.path);
    });
    widget.imagePickFunc(_pickedImage!);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey[400],
            backgroundImage:
                _pickedImage != null ? FileImage(_pickedImage!) : null,
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton.icon(
                onPressed: () => _pickImage(ImageSource.camera),
                icon: const Icon(
                  Icons.photo_camera_outlined,
                  color: primaryClr,
                  size: 25,
                ),
                label: const Text(
                  "Add image\nfrom camera",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: primaryClr,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              TextButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: const Icon(
                  Icons.image_outlined,
                  color: primaryClr,
                  size: 25,
                ),
                label: const Text(
                  "Add image\nfrom gallery",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                    color: primaryClr,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
