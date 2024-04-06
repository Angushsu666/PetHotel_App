import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


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
  final TextEditingController _priceContorller =
      TextEditingController(); // 添加价格控制器

  final Map<String, bool> roomCollection = {
    '獨立房型': false,
    '開放式住宿': false,
    '半開放式住宿': false,
  };
  final Map<String, bool> foodChoice = {
    '鮮食': false,
    '罐頭': false,
    '乾飼料': false,
    '處方飼料': false,
  };

  final Map<String, bool> serviceAndFacilities = {
    '24小時監控': false,
    '24小時寵物保姆': false,
    '開放式活動空間': false,
    '游泳池': false,
  };

  final Map<String, bool> medicalNeeds = {
    '口服藥': false,
    '外傷藥': false,
    '陪伴看診': false,
  };

  @override
  void dispose() {
    _nameContorller.dispose();
    _priceContorller.dispose(); // 释放资源
    super.dispose();
  }

  Widget build(BuildContext context) {
    final shopsNotifier = ref.read(shopsProvider.notifier);
    final currentUser = ref.watch(userProvider);

    _nameContorller.text = currentUser.user.name;
    // _priceController.text = shopsNotifier.;
    return Scaffold(
      appBar: AppBar(title: const Text("商家設定頁面")),
      body: SingleChildScrollView(
        child: Padding(
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
                child: Text("更換照片"),
              ),
              //Update Name
              TextFormField(
                decoration: const InputDecoration(labelText: "輸入使用者名稱"),
                controller: _nameContorller,
              ),
              TextButton(
                  onPressed: () {
                    ref
                        .read(userProvider.notifier)
                        .updateName(_nameContorller.text);
                  },
                  child: const Text('更新名字')),
              // Update Price
              TextFormField(
                decoration: const InputDecoration(labelText: "輸入價錢"),
                controller: _priceContorller, // 使用价格控制器
                keyboardType: TextInputType.number, // 仅允许输入数字
              ),
      
              TextButton(
                onPressed: () async {
                  try {
                    int newPrice =
                        int.parse(_priceContorller.text); // 从控制器获取价格并转换为整数
                    await shopsNotifier.postPrice(newPrice, currentUser);
                  } catch (e) {
                    print('Error updating price: $e');
                  }
                },
                child: const Text('更新服務價錢'),
              ),
              // Update roomCollection
              ...roomCollection.entries.map((entry) {
                return ListTile(
                  title: Text(entry.key),
                  trailing: Switch(
                    value: entry.value,
                    onChanged: (bool newValue) {
                      setState(() {
                        roomCollection[entry.key] = newValue;
                      });
                    },
                  ),
                );
              }).toList(),
              TextButton(
                onPressed: () async {
                  await shopsNotifier.changeRoom(roomCollection, currentUser);
                },
                child: const Text('更新房型選擇服務'),
              ),
              // 将 Map 转换为 List 并展开
              // Update foodChoice
              ...foodChoice.entries.map((entry) {
                return ListTile(
                  title: Text(entry.key),
                  trailing: Switch(
                    value: entry.value,
                    onChanged: (bool newValue) {
                      setState(() {
                        foodChoice[entry.key] = newValue;
                      });
                    },
                  ),
                );
              }).toList(),
              TextButton(
                onPressed: () async {
                  await shopsNotifier.changeFoodChoice(foodChoice, currentUser);
                },
                child: const Text('更新食物選擇服務'),
              ),
              // Update serviceAndFacilities
              ...serviceAndFacilities.entries.map((entry) {
                return ListTile(
                  title: Text(entry.key),
                  trailing: Switch(
                    value: entry.value,
                    onChanged: (bool newValue) {
                      setState(() {
                        serviceAndFacilities[entry.key] = newValue;
                      });
                    },
                  ),
                );
              }).toList(),
              TextButton(
                onPressed: () async {
                  await shopsNotifier.changeServiceAndFacilities(
                      serviceAndFacilities, currentUser);
                },
                child: const Text('更新服務與設施'),
              ),
              // Update medicalNeeds
              ...medicalNeeds.entries.map((entry) {
                return ListTile(
                  title: Text(entry.key),
                  trailing: Switch(
                    value: entry.value,
                    onChanged: (bool newValue) {
                      setState(() {
                        medicalNeeds[entry.key] = newValue;
                      });
                    },
                  ),
                );
              }).toList(),
              TextButton(
                onPressed: () async {
                  await shopsNotifier.changeMedicalNeeds(
                      medicalNeeds, currentUser);
                },
                child: const Text('更新醫療需求服務'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
