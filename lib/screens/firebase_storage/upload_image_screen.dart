import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_and_firebase/utils/utils.dart';
import 'package:flutter_and_firebase/widgets/round_button.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  File? image;
  final picker = ImagePicker();
  bool isLoading = false;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  final database = FirebaseDatabase.instance.ref('Posts');

  Future getImageFromGallery() async {
    final pickFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    setState(() {
      if (pickFile != null) {
        image = File(pickFile.path);
      } else {
        print('No image picked');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Image'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                getImageFromGallery();
              },
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: image != null
                    ? Image.file(image!.absolute)
                    : const Icon(
                        Icons.image,
                      ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            RoundButton(
              title: 'Upload',
              loading: isLoading,
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                firebase_storage.Reference ref = firebase_storage
                    .FirebaseStorage.instance
                    .ref('/images/${DateTime.now().millisecondsSinceEpoch}');
                firebase_storage.UploadTask uploadTask = ref.putFile(
                  image!.absolute,
                );

                Future.value(uploadTask).then((value) async {
                  var newUrl = await ref.getDownloadURL();

                  String id = DateTime.now().millisecondsSinceEpoch.toString();
                  database.child(id).set({
                    'id': id,
                    'title': 'image',
                    'image': newUrl.toString(),
                  }).then((value) {
                    setState(() {
                      isLoading = false;
                    });
                    Utils().toastMessage('Image uploaded');
                    image = null;
                  }).onError((error, stackTrace) {
                    setState(() {
                      isLoading = false;
                    });
                  });
                }).onError((error, stackTrace) {
                  Utils().toastMessage(
                    error.toString(),
                  );
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
