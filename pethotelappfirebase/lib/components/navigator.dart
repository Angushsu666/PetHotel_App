import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../pages/search.dart';
import '../pages/more.dart';
import '../pages/message.dart';
import '../pages/orderPage.dart';
import '../pages/orderShopPage.dart';

import '../providers/navigator_provider.dart';
import '../providers/user_provider.dart';

class NavigatorPage extends StatelessWidget {
  const NavigatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 230, 228, 228), // 设置底部导航栏的背景颜色
      child: const Padding(
        padding: EdgeInsets.all(14.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 水平均匀分布按钮
          children: [
            NavigationButton(0, '搜尋', Icons.search),
            NavigationButton(1, '訂單', Icons.event_note),
            NavigationButton(2, '訊息', Icons.message),
            NavigationButton(3, '更多', Icons.more_vert),
          ],
        ),
      ),
    );
  }
}

class NavigationButton extends ConsumerWidget {
  final int index;
  final String label;
  final IconData iconData;

  const NavigationButton(this.index, this.label, this.iconData, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var selectedIndex = ref.watch(navigatorIndexProvider);
    var screenWidth = MediaQuery.of(context).size.width;

    double buttonWidth;
    double iconSize;
    double fontSize;
    double spacing;

    if (screenWidth <= 320) {
      buttonWidth = 70;
      iconSize = 16;
      fontSize = 12;
      spacing = 8;
    } else {
      buttonWidth = 90;
      iconSize = 20;
      fontSize = 13;
      spacing = 12;
    }

    return InkWell(
      onTap: () {
        selectedIndex = index;
        //看按到哪一頁
        // print(selectedIndex);
        final currentUser = ref.read(userProvider);

        if (selectedIndex == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SearchPage()),
          );
          // print("searchPAge");
        } else if (selectedIndex == 1) {
          if(currentUser.user.isShopOwner) {
            // 如果是店铺所有者，跳转到 OrderShopPage
            Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderShopPage()));
          } else {
            // 如果不是店铺所有者，跳转到 OrderPage
            Navigator.push(context, MaterialPageRoute(builder: (context) => const OrderPage()));
          }
        } else if (selectedIndex == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MessagesListPage(
                  currentUserName: currentUser.user.name), //先用user的name //但要判
            ),
          );
        } else if (selectedIndex == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MorePage()),
          );
        }
      },
      highlightColor: Colors.transparent, // 设置点击高亮颜色为透明
      splashColor: Colors.transparent,
      child: Container(
        width: buttonWidth,
        height: 50,
        color: const Color.fromARGB(0, 238, 234, 234), // 设置按钮的背景颜色为透明
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(iconData,
                size: iconSize, color: const Color.fromARGB(255, 13, 13, 13)),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: const Color.fromARGB(255, 13, 13, 13),
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ), // 设置点击溅墨颜色为透明
    );
  }
}
