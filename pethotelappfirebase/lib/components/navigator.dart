import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../pages/search.dart';
import '../pages/more.dart';
import '../pages/message.dart';
import '../pages/order.dart';

import '../providers/navigator_provider.dart';

class NavigatorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Row(
        children: [
          NavigationButton(0, 'Search', Icons.search),
          NavigationButton(1, 'Order', Icons.event_note),
          NavigationButton(2, 'Message', Icons.message),
          NavigationButton(3, 'More', Icons.more_vert),
        ],
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

    return ElevatedButton(
      onPressed: () {
        selectedIndex = index;
        //看按到哪一頁
        // print(selectedIndex);
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
            MaterialPageRoute(builder: (context) => MessagePage()),
          );
        } else if (selectedIndex == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MorePage()),
          );
        }
      },
      style: ButtonStyle(
        fixedSize: MaterialStateProperty.all(Size(buttonWidth, 40)), // 設定寬度和高度
        backgroundColor: MaterialStateProperty.all(
            const Color.fromARGB(255, 255, 255, 255)), // 設定背景顏色
        foregroundColor: MaterialStateProperty.all(
            const Color.fromARGB(255, 255, 185, 185)), // 設定文字顏色
        padding: MaterialStateProperty.all(EdgeInsets.all(0)), // 設定內邊距
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // 設定圓角
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconData, size: iconSize),
          SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: const Color.fromARGB(255, 255, 172, 172),
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }
}
