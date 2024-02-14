import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // 引入flutter_svg
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pethotelappfirebase/pages/home.dart';
import '../components/navigator.dart';
// import '../components/shoplist.dart';
import '../models/petshop.dart';
import '../providers/shop_provider.dart';
import 'sortPetHotel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SearchPage extends ConsumerWidget {
  SearchPage({Key? key}) : super(key: key);

  // static bool _shopsFetched = false; // 使用静态变量来全局跟踪是否已获取数据

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(shopsProvider.notifier);
    // 只在数据未加载时调用fetchShops

    notifier.fetchShops(); // 获取商店数据

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home 選擇你要的服務',
          style: TextStyle(color: Color.fromARGB(255, 226, 160, 182)),
        ),
        backgroundColor: Color.fromARGB(255, 226, 160, 182),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut(); // 將FirebaseAuth的狀態登出
            },
            child: const Text(
              'Sign out',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 226, 160, 182),
      body: Column(
        children: [
          //測試商店列表
          // Container(
          //   child: InkWell(
          //     onTap: () {
          //       // Navigator.push(
          //       //   context,
          //       //   MaterialPageRoute(
          //       //       builder: (context) => ShopListPage()), // 導航到 ShopListPage
          //       // );
          //     },
          //     child: Container(
          //       width: 120,
          //       height: 50,
          //       color: Color.fromARGB(255, 226, 160, 182),
          //       child: const Center(
          //         child: Text(
          //           '前往商店列表頁面',
          //           style: TextStyle(color: Colors.white),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          //           Container(
          //   child: InkWell(
          //     onTap: () {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //             builder: (context) => Home()),
          //       );
          //     },
          //     child: Container(
          //       width: 120,
          //       height: 50,
          //       color: Color.fromARGB(255, 226, 160, 182),
          //       child: const Center(
          //         child: Text(
          //           'Home page',
          //           style: TextStyle(color: Colors.white),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          //服務列表
          Expanded(
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        // CustomButton(
                        //   iconAsset: 'assets/home.svg',
                        //   label: '寵物旅館住宿',
                        //   onPressed: () {
                        //     notifier
                        //         .fetchShops(); // Call fetchShops from the notifier
                        //     List<petShop> filteredShops = allShops
                        //         .where((shop) =>
                        //             shop.busItem.contains('C') ||
                        //             shop.busItem.contains('BC') ||
                        //             shop.busItem.contains('ABC'))
                        //         .toList();
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) =>
                        //             SortPetHotel(shops: filteredShops),
                        //       ),
                        //     );
                        //   },
                        // ),
                        CustomButton(
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

                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: CustomButton(
                  //     iconAsset: 'assets/paw3.svg',
                  //     label: '寵物日托安親',
                  //     onPressed: () {
                  //       // 在這裡執行按鈕被點擊時的操作
                  //     },
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomButton(
                      iconAsset: 'assets/bathing.svg',
                      label: '寵物美容洗澡',
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
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: CustomButton(
                  //     iconAsset: 'assets/scissor.svg',
                  //     label: '寵物美容剪毛',
                  //     onPressed: () {
                  //       // 在這裡執行按鈕被點擊時的操作
                  //     },
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomButton(
                      iconAsset: 'assets/pets.svg',
                      label: '寵物繁殖買賣',
                      onPressed: () {
                        // 在這裡執行按鈕被點擊時的操作
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          NavigatorPage(), // 放置導航按鈕
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String iconAsset;
  final String label;
  final VoidCallback onPressed;

  CustomButton({
    required this.iconAsset,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    double buttonWidth;
    if (screenWidth <= 320) {
      buttonWidth = 200; // 在較小的屏幕上，將按鈕寬度設置為150
    } else {
      buttonWidth = 400; // 在較大的屏幕上，將按鈕寬度設置為200
    }
    return ElevatedButton(
      onPressed: () async {
        // print("Button pressed"); // 確保按鈕被點擊時該語句被執行
        onPressed();
        // if (label == '寵物旅館住宿') {
        //   allShops.when(
        //     data: (shops) {
        //       List<petShop> filteredShops =
        //           shops.where((shop) => shop.busItem == 'C').toList();
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => SortPage(shops: filteredShops),
        //         ),
        //       );
        //     },
        //     loading: () {
        //       // 正在加載的情況下，可以執行一些操作
        //     },
        //     error: (error, stackTrace) {
        //       // 錯誤情況下，可以執行一些操作
        //     },
        //   );
        // }
      },
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(Size(buttonWidth, 80)), // 設定寬度和高度
        backgroundColor: MaterialStateProperty.all(
            const Color.fromARGB(255, 226, 160, 182)), // 設定背景顏色
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
          SizedBox(width: 40),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
