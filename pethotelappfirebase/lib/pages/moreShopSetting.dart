import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final TextEditingController _introContorller = TextEditingController();

  //房間價錢設定
  Map<String, Map<String, TextEditingController>> roomPriceControllers = {
    '獨立房型': {
      '小型犬': TextEditingController(),
      '中型犬': TextEditingController(),
      '大型犬': TextEditingController(),
      '貓': TextEditingController(),
    },
    '半開放式住宿': {
      '小型犬': TextEditingController(),
      '中型犬': TextEditingController(),
      '大型犬': TextEditingController(),
      '貓': TextEditingController(),
    },
    '開放式住宿': {
      '小型犬': TextEditingController(),
      '中型犬': TextEditingController(),
      '大型犬': TextEditingController(),
      '貓': TextEditingController(),
    },
  };
  //食物選擇設定
  final Map<String, bool> foodChoice = {
    '鮮食': false,
    '罐頭': false,
    '乾飼料': false,
    '處方飼料': false,
  };
  //服務及設施設定
  final Map<String, bool> serviceAndFacilities = {
    '24小時監控': false,
    '24小時寵物保姆': false,
    '開放式活動空間': false,
    '游泳池': false,
  };
  //醫療及服務設定
  final Map<String, bool> medicalNeeds = {
    '口服藥': false,
    '外傷藥': false,
    '陪伴看診': false,
  };
  //美容服務價錢設定
  Map<String, Map<String, TextEditingController>> groomingPriceControllers = {
    '小美容': {
      '小型犬': TextEditingController(),
      '中型犬': TextEditingController(),
      '大型犬': TextEditingController(),
      '貓': TextEditingController(),
    },
    '大美容': {
      '小型犬': TextEditingController(),
      '中型犬': TextEditingController(),
      '大型犬': TextEditingController(),
      '貓': TextEditingController(),
    },
  };

  Future<void> _setInitialRoomPrices() async {
    try {
      // 获取当前用户的商店数据
      var shop = await ref
          .read(shopsProvider.notifier)
          .getShopData(ref.read(userProvider));
      print("_setInitialRoomPrices: Shop data fetched for room collections");

      // 遍历每种房型和宠物类型，更新对应的TextEditingController的值
      shop.roomCollection.forEach((roomType, pets) {
        pets.forEach((petType, price) {
          // 检查priceControllers中是否有相应的TextEditingController
          if (roomPriceControllers[roomType] != null &&
              roomPriceControllers[roomType]![petType] != null) {
            // 更新TextEditingController的值
            roomPriceControllers[roomType]![petType]!.text = price.toString();
          }
        });
      });

      // 强制更新UI
      setState(() {});
    } catch (e) {
      print("Error fetching shop data: $e");
    }
  }

  Future<void> _setInitialGroomingPrices() async {
    try {
      // 获取当前用户的商店数据
      var shop = await ref
          .read(shopsProvider.notifier)
          .getShopData(ref.read(userProvider));
      print("_setInitialGroomingPrices :Shop data fetched for grooming collections");
      // 遍历每种房型和宠物类型，更新对应的TextEditingController的值
      shop.petGrooming.forEach((groomingType, pets) {
        pets.forEach((petType, price) {
          // 检查priceControllers中是否有相应的TextEditingController
          if (groomingPriceControllers[groomingType] != null &&
              groomingPriceControllers[groomingType]![petType] != null) {
            // 更新TextEditingController的值
            groomingPriceControllers[groomingType]![petType]!.text =
                price.toString();
          }
        });
      });
      // 强制更新UI
      setState(() {});
    } catch (e) {
      print("Error fetching shop data: $e");
    }
  }

  Future<void> _initializeShopSettings() async {
    try {
      // 获取当前用户的商店数据
      var shop = await ref
          .read(shopsProvider.notifier)
          .getShopData(ref.read(userProvider));
      print("Shop data fetched");

      // 更新界面的食物選擇開關
      setState(() {
        foodChoice.updateAll((key, value) => shop.foodChoice[key] ?? false);
      });

      // 更新界面的服務設施開關
      setState(() {
        serviceAndFacilities
            .updateAll((key, value) => shop.serviceAndFacilities[key] ?? false);
      });

      // 更新界面的醫療需求開關
      setState(() {
        medicalNeeds.updateAll((key, value) => shop.medicalNeeds[key] ?? false);
      });
    } catch (e) {
      print("Error fetching shop data: $e");
    }
  }

  bool _isNameSameAsShop = false;

//上傳相簿
  final ImagePicker _picker = ImagePicker();

// Function to handle image selection and upload
  Future<void> _pickAndUploadImages() async {
    final currentUser = ref.read(userProvider);
    // Let users pick images without a limit and then handle the limit manually
    final List<XFile> images = await _picker.pickMultiImage();
    if (images.length > 8) {
      // Notify user if more than 8 images are selected
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('您上傳太多太多照片囉！'),
            content: const Text('最多只可以上傳八張照片'),
            actions: <Widget>[
              TextButton(
                child: const Text('完成上傳相簿'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return; // Exit the function if the limit is exceeded
    }
    List<File> files = images.map((e) => File(e.path)).toList();
    // Assuming you have a shop ID and a method in your shop provider to handle file uploads
    String shopId = currentUser.user.name; // Replace with actual shop ID
    await ref
        .read(shopsProvider.notifier)
        .uploadAlbum(files, shopId, currentUser);
    }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _setInitialRoomPrices();
      await _setInitialGroomingPrices();
      await _initializeShopSettings(); // 調用初始化設置方法

      // Here you need to ensure that you have the current user and the shop data available
      // For example, using a Provider or any other state management solution
      final currentUser = ref.read(userProvider);
      final shop =
          await ref.read(shopsProvider.notifier).getShopData(currentUser);
      _isNameSameAsShop = currentUser.user.name == shop.legalName;
      // print("shop.legalName");
      // print(shop.legalName);
      // print("currentUser.user.name:");
      // print(currentUser.user.name);
      // 从商店数据中获取介绍文本并设置到控制器
      _introContorller.text =
          shop.introduction ?? ""; // 假设商店数据中有一个叫做`introduction`的字段
      setState(() {}); // Refresh UI
    });
  }

  @override
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
              const SizedBox(
                height: 10,
              ),
              const Center(
                child: Text("更換照片"),
              ),
              //上傳商家相簿
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _pickAndUploadImages,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 231, 164, 183)),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white),
                      ),
                      child: const Text('上傳商家相簿'),
                    ),
                    // Other widgets and configurations
                  ],
                ),
              ),
              //Update Name
              TextFormField(
                decoration: InputDecoration(
                  labelText: "認證商家名稱:",
                  suffixIcon: _isNameSameAsShop
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                ),
                controller: _nameContorller, // Corrected variable name
              ),

              if (!_isNameSameAsShop)
                ElevatedButton(
                  onPressed: () {
                    ref.read(userProvider.notifier).updateName(
                        _nameContorller.text); // Corrected variable name
                    setState(() {
                      _isNameSameAsShop = true;
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 231, 164, 183)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: const Text('更新名字'),
                ),

              const SizedBox(
                height: 10,
              ),
              //Update Intro
              TextFormField(
                controller: _introContorller,
                decoration: const InputDecoration(
                  labelText: "輸入商家介紹",
                  hintText: "限制200個字，並可按Enter換行",
                ),
                maxLines: null, // 设置为null允许输入多行文本
                keyboardType: TextInputType.multiline, // 设置键盘类型支持多行输入
                inputFormatters: [
                  LengthLimitingTextInputFormatter(200), // 限制输入最多200个字符
                ],
              ),

              ElevatedButton(
                onPressed: () async {
                  await shopsNotifier.changeIntro(
                      _introContorller.text, currentUser);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('商家介绍更新成功')));
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 231, 164, 183)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                child: const Text('更新介紹'),
              ),

              const SizedBox(
                height: 10,
              ),

              // Update roomCollection
              // 创建一个表单来允许用户输入不同宠物类型的价格
              // 为每种房型创建一个区域来显示价格输入字段
              ...roomPriceControllers.entries.map((roomEntry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 10),
                      child: Text("${roomEntry.key}價錢",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    ...roomEntry.value.entries.map((entry) {
                      return TextFormField(
                        decoration: InputDecoration(
                          labelText: "${entry.key}的價錢（如果無此服務則不需要填）",
                        ),
                        controller: entry.value,
                        keyboardType: TextInputType.number,
                      );
                    }).toList(),
                  ],
                );
              }),

              // 提交按钮
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  onPressed: () async {
                    // 准备要更新的数据
                    Map<String, Map<String, int>> updatedCollections = {};
                    roomPriceControllers.forEach((collectionType, controllers) {
                      Map<String, int> prices = {};
                      controllers.forEach((itemType, controller) {
                        // 将文本转换为int，如果为空则默认为0
                        int price = int.tryParse(controller.text) ?? 0;
                        prices[itemType] = price;
                      });
                      updatedCollections[collectionType] = prices;
                    });

                    // 更新Firebase，此处根据实际需要调用对应的函数，例如changeRoom、changeFoodChoice等
                    // 举例：假设有一个updateCollections的函数可以同时更新所有集合
                    await shopsNotifier.changeRoomPrice(
                        updatedCollections, currentUser);

                    // 提示用户更新成功
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('房型價錢更新成功')),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 231, 164, 183)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: const Text('更新所有房型價錢'),
                ),
              ),
              ...groomingPriceControllers.entries.map((GroomingEntry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 10),
                      child: Text("${GroomingEntry.key}價錢",
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    ...GroomingEntry.value.entries.map((entry) {
                      return TextFormField(
                        decoration: InputDecoration(
                          labelText: "${entry.key}的價錢（如果無此服務則不需要填）",
                        ),
                        controller: entry.value,
                        keyboardType: TextInputType.number,
                      );
                    }).toList(),
                  ],
                );
              }),
              // 提交按钮

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  onPressed: () async {
                    // 准备要更新的数据
                    Map<String, Map<String, int>> updatedCollections = {};
                    groomingPriceControllers
                        .forEach((collectionType, controllers) {
                      Map<String, int> prices = {};
                      controllers.forEach((itemType, controller) {
                        // 将文本转换为int，如果为空则默认为0
                        int price = int.tryParse(controller.text) ?? 0;
                        prices[itemType] = price;
                      });
                      updatedCollections[collectionType] = prices;
                    });
                    await shopsNotifier.changeGroomingPrice(
                        updatedCollections, currentUser);
                    // 提示用户更新成功
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('美容價錢價錢更新成功')),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 231, 164, 183)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                  ),
                  child: const Text('更新所有美容價錢'),
                ),
              ),
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
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 231, 164, 183)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
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
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 231, 164, 183)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
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
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromARGB(255, 231, 164, 183)),
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.white),
                ),
                child: const Text('更新醫療需求服務'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
