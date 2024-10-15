import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/navigator.dart';
import '../providers/user_provider.dart';
import 'privacyPolicyPage.dart';
import 'moreSetting.dart';
import 'moreShopSetting.dart';
import 'moreAccountSecurity.dart';

class MorePage extends ConsumerWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LocalUser currentUser = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('更多'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ), // 設定整個 MorePage 的背景顏色
      body: Column(
        children: [
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(
                padding: EdgeInsets.all(16.0),
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
                        builder: (context) => const settings()), // 導航到設定頁面
                  );
                },
                iconData: Icons.person, // Specify the icon for each button
              ),
              MoreButton(
                title: '設定商家資料',
                onPressed: () {
                  if (currentUser.user.isShopOwner) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ShopSettings()),
                    );
                  }
                },
                iconData: Icons.store,
              ),
              MoreButton(
                title: '你的收藏店家的清單',
                onPressed: () {},
                iconData: Icons.favorite,
              ),
              MoreButton(
                title: '帳號安全',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            AccountSecurityPage(currentUser: currentUser)),
                  );
                },
                iconData: Icons.security,
              ),
              MoreButton(
                title: '隱私權',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyPage()),
                  );
                },
                iconData: Icons.privacy_tip,
              ),
// Add other buttons as needed
            ]),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    '推薦與折扣',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                //還未做
                MoreButton(
                  title: '折扣碼',
                  onPressed: () {},
                  iconData: Icons.discount,
                ),
                MoreButton(
                  title: '邀請朋友',
                  onPressed: () {},
                  iconData: Icons.mail,
                ),
              ],
            ),
          ),
          const NavigatorPage(),
        ],
      ),
    );
  }
}

class MoreButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final IconData iconData; // Add IconData to the class

  const MoreButton({super.key, 
    required this.title,
    required this.onPressed,
    required this.iconData, // Include iconData in constructor
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromRGBO(255, 239, 239, 1.0), // 設定為與背景色相同的顏色
        elevation: 1, // 調整陰影的強度
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisSize:
                MainAxisSize.min, // Keep content at the start of the button
            children: [
              Icon(iconData, color: Colors.grey[700]), // Use the passed icon
              const SizedBox(width: 10), // Space between icon and text
              Text(
                title,
                style: const TextStyle(color: Color.fromARGB(255, 168, 168, 168)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
