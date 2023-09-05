import 'package:flutter/material.dart';
import '../components/navigator.dart';

class MessagePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('messagePage'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color.fromARGB(255, 226, 160, 182), // 更改AppBar的背景顏色
      ),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                // 其他功能的元件放在這裡
              ],
            ),
          ),
          NavigatorPage(),
        ],
      ),
    );
  }
}
