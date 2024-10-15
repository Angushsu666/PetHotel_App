import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // 引入flutter_svg
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:carousel_slider/carousel_slider.dart'; // 引入 carousel_slider
import '../pages/signin.dart';
import '../components/navigator.dart';
import '../models/petshop.dart';
import '../providers/shop_provider.dart';
import 'searchhotelpages/searchSortPetHotel.dart';
import 'searchgroomingpages/searchSortPetGrooming.dart';
import 'searchbreedingpages/searchSortPetBreeding.dart';
import 'insurancePage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchPage extends ConsumerWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(shopsProvider.notifier);
    //只在数据未加载时调用fetchSho
    //原本是notifier.fetchShops(); 但應該是不用對吧，因為firebase裡面已經有了！！！！！
    notifier.fetchFirestoreShops(); // 获取商店数据

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(255, 239, 239, 1.0),
        leading: null,
        actions: [
          TextButton(
            onPressed: () async {
              try {
                print("正在尝试登出");
                await FirebaseAuth.instance.signOut();
                print("登出成功");
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const SignIn()));
              } catch (e) {
                print("登出失败: $e");
              }
            },
            child: const Text(
              '登出',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomButton(
                      iconAsset: 'assets/home.svg',
                      label: '寵物旅館住宿',
                      onPressed: () async {
                        List<petShop> firestoreShops = await notifier
                            .fetchFirestoreShops(); // 获取最新的 Firestore 数据
                        List<petShop> filteredShops = firestoreShops
                            .where((shop) =>
                                shop.busItem.contains('C') ||
                                shop.busItem.contains('BC') ||
                                shop.busItem.contains('ABC'))
                            .toList();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SortPetHotel(shops: filteredShops),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomButton(
                      iconAsset: 'assets/bathing.svg',
                      label: '寵物洗澡美容',
                      onPressed: () async {
                        List<petShop> firestoreShops = await notifier
                            .fetchFirestoreShops(); // 获取最新的 Firestore 数据
                        List<petShop> filteredShops = firestoreShops
                            .where((shop) =>
                                shop.busItem.contains('C') ||
                                shop.busItem.contains('BC') ||
                                shop.busItem.contains('ABC'))
                            .toList();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SortPetGrooming(shops: filteredShops),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomButton(
                      iconAsset: 'assets/pets.svg',
                      label: '寵物繁殖買賣',
                      onPressed: () async {
                        List<petShop> firestoreShops = await notifier
                            .fetchFirestoreShops(); // 获取最新的 Firestore 数据
                        List<petShop> filteredShops = firestoreShops
                            .where((shop) =>
                                shop.busItem.contains('A') ||
                                shop.busItem.contains('AC') ||
                                shop.busItem.contains('B') ||
                                shop.busItem.contains('BC') ||
                                shop.busItem.contains('AB') ||
                                shop.busItem.contains('ABC'))
                            .toList();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SortPetBreeding(shops: filteredShops),
                          ),
                        );
                      },
                    ),
                  ),
                  // 自動滑動的廣告長方形
                  SizedBox(
                    height: 200, // 設定長方形的高度
                    child: CarouselSlider(
                      options: CarouselOptions(
                        autoPlay: true,
                        aspectRatio: 2.0,
                        enlargeCenterPage: true,
                      ),
                      items: [
                        {'image': 'assets/partnerAd3.png', 'text': '合作廠商：哈嚕貓社'},
                        {
                          'image': 'assets/partnerAd1.png',
                          'text': '合作廠商：大天使工作室'
                        },
                        {'image': 'assets/partnerAd2.png', 'text': '合作廠商：咪亞貓社'},
                      ]
                          .map((item) => Container(
                                margin: const EdgeInsets.all(5.0),
                                child: ClipRRect(
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(5.0)),
                                  child: Stack(
                                    children: <Widget>[
                                      Image.asset(item['image']!,
                                          fit: BoxFit.cover, width: 1000.0),
                                      Positioned(
                                        bottom: 0.0,
                                        left: 0.0,
                                        right: 0.0,
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color.fromARGB(200, 0, 0, 0),
                                                Color.fromARGB(0, 0, 0, 0)
                                              ],
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 20.0),
                                          child: Text(
                                            item['text']!,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  // 可點擊的長方形
                  GestureDetector(
                    onTap: () {
                      // 添加點擊事件
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const InsurancePage()),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 10.0),
                      padding: const EdgeInsets.all(20.0),
                      color: const Color.fromRGBO(255, 239, 239, 1.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "捲毛寶寶平台預定含保險保障",
                            style: TextStyle(
                                fontSize: 24,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "捲毛寶寶平台提供全面的保險保障，讓您的寵物在我們的旅館、洗澡美容服務中享有最佳的保障（除了繁殖買賣以外）。無論是住宿還是美容，我們都確保您的寵物得到最好的照顧和保護。",
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const InsurancePage()),
                              );
                            },
                            child: const Text(
                              "點擊看更多內容>>>",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const NavigatorPage(), // 放置導航按鈕
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String iconAsset;
  final String label;
  final VoidCallback onPressed;

  const CustomButton({super.key, 
    required this.iconAsset,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    double buttonWidth = screenWidth * 0.9; // 按钮宽度设置为屏幕宽度的85%

    // if (screenWidth <= 320) {
    // buttonWidth = 200; // 在較小的屏幕上，將按鈕寬度設置為150
    // } else {
    // buttonWidth = 400; // 在較大的屏幕上，將按鈕寬度設置為200
    // }
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          onPressed();
        },
        style: ButtonStyle(
          fixedSize:
              MaterialStateProperty.all(Size(buttonWidth, 80)), // 設定寬度和高度
          backgroundColor: MaterialStateProperty.all(
            const Color.fromRGBO(255, 239, 239, 0.5),
          ), // 設定背景顏色
          foregroundColor: MaterialStateProperty.all(Colors.white), // 設定文字顏色
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              iconAsset, // 使用SVG圖像路徑
              width: 40,
              height: 40,
            ),
            const SizedBox(width: 40),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
