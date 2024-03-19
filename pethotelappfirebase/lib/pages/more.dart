import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/navigator.dart';
import '../providers/user_provider.dart';

import 'setting.dart';
import 'shopSetting.dart';

class MorePage extends ConsumerWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LocalUser currentUser = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('更多'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color.fromARGB(255, 226, 160, 182), // 更改AppBar的背景顏色
      ),
      backgroundColor:
          Color.fromARGB(255, 226, 160, 182), // 設定整個 MorePage 的背景顏色
      body: Column(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '資料管理',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                MoreButton(
                    title: '設定使用者的資料',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                settings()), // 導航到 ShopListPage
                      ); //user更改自己的資料
                    }),
                MoreButton(
                  title: '設定商家資料',
                  onPressed: () {
                    // 從你的使用者數據源獲取用戶數據
                    // print(currentUser.user.isShopOwner);
                    // print(currentUser.user.email);
                    if (currentUser.user.isShopOwner) {
                      // print('設定商家資料');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ShopSettings()),
                      );
                      //顯示商家資料設定頁面或相關操作
                    } else {
                      //用戶無權限訪問
                      // print('您不是店家，無法訪問商家資料設定');
                    }
                  },
                ),
                MoreButton(
                    title: '你的收藏店家的清單',
                    onPressed: () {
                      //收藏清單list
                    }),
                MoreButton(
                    title: '付款方式設定',
                    onPressed: () {
                      //綁定信用卡之類的
                    }),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '推薦與折扣',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                //還未做
                MoreButton(title: '折扣碼', onPressed: () {}),
                MoreButton(title: '邀請朋友', onPressed: () {}),
              ],
            ),
          ),
          NavigatorPage(),
        ],
      ),
    );
  }
}

class MoreButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  MoreButton({required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 226, 160, 182), // 設定為與背景色相同的顏色
        elevation: 1, // 調整陰影的強度
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(title),
        ),
      ),
    );
  }
}
