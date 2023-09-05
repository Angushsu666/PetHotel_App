import 'dart:io';
import 'dart:typed_data';
// import 'package:image/image.dart' as img;
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:http/http.dart' as http; // 添加這個導入
// import 'dart:convert'; // 添加這個導入
import 'package:image_picker/image_picker.dart';

import '../providers/user_provider.dart';
import '../providers/shop_provider.dart';

class ShopSettings extends ConsumerStatefulWidget {
  const ShopSettings({Key? key}) : super(key: key);

  @override
  ConsumerState<ShopSettings> createState() => _ShopSettingsState();
}

class _ShopSettingsState extends ConsumerState<ShopSettings> {
  final TextEditingController _nameContorller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final shopsNotifier = ref.read(shopsProvider.notifier);
    final currentUser = ref.watch(userProvider);

    _nameContorller.text = currentUser.user.name;
    return Scaffold(
      appBar: AppBar(title: const Text("Settings ShopPage")),
      backgroundColor: Color.fromARGB(255, 226, 160, 182), // 更改AppBar的背景顏色
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            //Update image
            GestureDetector(
              onTap: () async {
                final ImagePicker picker = ImagePicker();

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
                    // print("Selected image is not a JPEG image.");
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
            //Update Name
            TextFormField(
              decoration: const InputDecoration(labelText: "Enter your Name"),
              controller: _nameContorller,
            ),
            TextButton(
                onPressed: () {
                  ref
                      .read(userProvider.notifier)
                      .updateName(_nameContorller.text);
                },
                child: const Text('Update')),
            // Update Price
            TextButton(
              onPressed: () async {
                // //  shopsNotifier.clearFirestoreCache();
                // try {
                //   // New price value to be updated in Firestore
                //   String newPrice = '1000';
                //   // Call the updatedPrice method from ShopsNotifier
                //   await shopsNotifier.postPrice(newPrice, currentUser);

                //   // Update successful
                //   // print('Price updated successfully.');
                // } catch (e) {
                //   // print('Error updating price: $e');
                // }
              },
              child: const Text('Update Price'),
            ),
          ],
        ),
      ),
    );
  }
}
