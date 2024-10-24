import 'dart:io';

import 'package:ev_charge/constants/styling_variables.dart';
import 'package:ev_charge/services/user/update_user.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateImagePage extends StatefulWidget {
  static const String routeName = 'update-image-page';

  const UpdateImagePage({super.key});

  @override
  State<UpdateImagePage> createState() => _UpdateImagePageState();
}

class _UpdateImagePageState extends State<UpdateImagePage> {
  final UpdateUser updateUser = UpdateUser();
  XFile? _image;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedImage;
    });
  }

  void updateImage() {
    updateUser.updateImage(
      context: context,
      image: _image!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Image'),
        backgroundColor: const Color.fromARGB(255, 62, 182, 122),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'Select new image',
                style: TextStyle(fontSize: 25.0),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: _pickImage,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: _image == null
                    ? Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.add_a_photo,
                          color: Colors.grey,
                          size: 50,
                        ),
                      )
                    : Image.file(
                        File(_image!.path),
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.contain,
                      ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: updateImage,
              style: elevatedButtonStyle,
              child: const Text(
                'Update',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
