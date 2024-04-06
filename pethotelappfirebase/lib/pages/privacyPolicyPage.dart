import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('隱私政策'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: const Text(
          '这里是您的隐私政策内容。', // 这里替换为您的隐私政策内容
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}