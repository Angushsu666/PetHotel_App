import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../pages/search.dart';
import '../pages/more.dart';
import '../pages/message.dart';
import '../pages/order.dart';

import '../providers/navigator_provider.dart';
import '../providers/user_provider.dart';

class NavigatorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 185, 182, 182), // 设置底部导航栏的背景颜色
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 水平均匀分布按钮
          children: [
            NavigationButton(0, 'Search', Icons.search),
            NavigationButton(1, 'Order', Icons.event_note),
            NavigationButton(2, 'Message', Icons.message),
            NavigationButton(3, 'More', Icons.more_vert),
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

  NavigationButton(this.index, this.label, this.iconData);

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
            MaterialPageRoute(builder: (context) => SearchPage()),
          );
          // print("searchPAge");
        } else if (selectedIndex == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OrderPage()),
          );
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
            MaterialPageRoute(builder: (context) => MorePage()),
          );
        }
      },
      child: Container(
        width: buttonWidth,
        height: 50,
        color: Colors.transparent, // 设置按钮的背景颜色为透明
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(iconData,
                size: iconSize, color: Color.fromARGB(255, 13, 13, 13)),
            SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Color.fromARGB(255, 13, 13, 13),
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      highlightColor: Colors.transparent, // 设置点击高亮颜色为透明
      splashColor: Colors.transparent, // 设置点击溅墨颜色为透明
    );
  }
}
