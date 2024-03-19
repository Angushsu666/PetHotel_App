import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/user_provider.dart';
import '../providers/shop_provider.dart';

import '../models/user.dart';

class ShopSignUp extends ConsumerStatefulWidget {
  const ShopSignUp({super.key});

  @override
  ConsumerState<ShopSignUp> createState() => _ShopSignUp();
}

class _ShopSignUp extends ConsumerState<ShopSignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _signInKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final RegExp emailValid =
      RegExp(r"^[a-zA-Z0-9.!#$%&'*+-/=?^_1{|}-]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: _signInKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(
                FontAwesomeIcons.dog,
                color: Color.fromARGB(255, 255, 195, 171),
                size: 70,
              ),
              const Text(
                'Welcome to join, please fill the email and password',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 255, 195, 171),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(30)),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'example@gmail.com',
                    border: InputBorder.none, //拿掉輸入框底線
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "請輸入電子信箱";
                    } else if (!emailValid.hasMatch(value)) {
                      return "請輸入完整電子信箱 ex. example@gmail.com";
                    } //輸入值不是空且不符合 emailValid 正則表達式所定義的電子郵件格式
                    return null; //有效則不會返回訊息
                  },
                ),
              ),
              Container(
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "at least 6 numbers",
                    border: InputBorder.none, //拿掉輸入框底線
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 20,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Pleas enter at least 6 numbers passwords";
                    } else if (value.length < 6) {
                      return "passwords need at lest 6 number";
                    }
                    return null;
                  },
                ),
              ),
              //create new account button
              Container(
                width: 250,
                height: 50,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 195, 171),
                    borderRadius: BorderRadius.circular(30)),
                child: TextButton(
                  onPressed: () async {
                    if (_signInKey.currentState!.validate()) {
                      try {
                        await _auth.createUserWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text);

                        await ref.read(userProvider.notifier).shopSignUp(
                              _emailController.text,
                            );
                        if (!mounted)
                          return; //目的是在 Flutter 應用中確保當前的 Widget 是否已經被掛載到了 Widget 樹上

                        Navigator.pop(context);
                      } on Exception catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())));
                      }
                    }
                  },
                  child: const Text(
                    '新增商家帳號',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w100,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'cancel',
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 195, 171),
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          )),
    );
  }
}
