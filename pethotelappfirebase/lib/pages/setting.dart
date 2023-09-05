import 'dart:io';
//import 'dart:html' as html; // Import dart:html for Blob
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_provider.dart';

class settings extends ConsumerStatefulWidget {
  const settings({super.key});

  @override
  ConsumerState<settings> createState() => _settingsState();
}

class _settingsState extends ConsumerState<settings> {
  final TextEditingController _nameContorller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    LocalUser currentUser = ref.watch(userProvider);
    _nameContorller.text = currentUser.user.name;
    return Scaffold(
      appBar: AppBar(title: const Text("User Setting page")),
      backgroundColor: Color.fromARGB(255, 226, 160, 182), // 更改AppBar的背景顏色
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            //Update image
            GestureDetector(
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                // // Pick an image.
                // final XFile? pickedImage = await picker.pickImage(
                //     source: ImageSource.gallery, requestFullMetadata: false);
                // // Capture a photo.
                // if (pickedImage != null) {
                //   ref
                //       .read(userProvider.notifier)
                //       .updateImage(File(pickedImage.path));
                // }
                final XFile? pickedImage = await picker.pickImage(
                  source: ImageSource.gallery,
                  maxWidth:
                      800, // Optional: Limit the image size to prevent memory issues
                );

                if (pickedImage != null) {
                  final String imagePath = pickedImage.path;
                  final String imageExtension =
                      path.extension(imagePath).toLowerCase();

                  if (imageExtension == '.jpg' || imageExtension == '.jpeg') {
                    // The image is a valid JPEG
                    final Uint8List imageBytes =
                        await pickedImage.readAsBytes();
                    // Now you can use imageBytes or create a File object using imagePath
                    ref
                        .read(userProvider.notifier)
                        .updateImage(File(imagePath));
                  } else {
                    print("Selected image is not a JPEG image.");
                  }
                }
              },
              child: CircleAvatar(
                radius: 100,
                foregroundImage: NetworkImage(currentUser.user.profilePic),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Text("Tap image to Change"),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Enter your Name"),
              controller: _nameContorller,
            ),
            //Update Name
            TextButton(
                onPressed: () {
                  ref
                      .read(userProvider.notifier)
                      .updateName(_nameContorller.text);
                },
                child: const Text('Update')),
                
          ],
        ),
      ),
    );
  }
}
