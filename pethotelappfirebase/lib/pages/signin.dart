import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
// import '../components/shoplist.dart';
import '../providers/user_provider.dart';
import 'signUp.dart';
import 'shopSignUp.dart';
//firebase auth
import 'package:firebase_auth/firebase_auth.dart';

class SignIn extends ConsumerStatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  ConsumerState<SignIn> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  //firebase auth
  FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _signInKey = GlobalKey();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final RegExp emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_1{|}-]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 195, 171),
      // appBar: AppBar(
      //   title: Text('Sign In'),
      // ),
      body: Form(
          key: _signInKey, //key很重要
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
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
                        return "please enter your email";
                      } else if (!emailValid.hasMatch(value)) {
                        return "Please enter the complete email account ex. example@gmail.com";
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(15),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextFormField(
                    //password 需要使用validator
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: "password",
                      border: InputBorder.none, //拿掉輸入框底線
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        //沒輸入直接送出爲null，輸入後刪除則爲Empty
                        return "Please enter at least six passpords";
                      } else if (value.length < 6) {
                        return "Passpord's length > 6";
                      }
                      return null; //沒有問題
                    },
                  ),
                ),
                //Login button
                Container(
                  margin: const EdgeInsets.all(15),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  width: 150,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(45),
                  ),
                  child: TextButton(
                    // async function 先等User輸入資料後再執行後續
                    onPressed: () async {
                      if (_signInKey.currentState!.validate()) {
                        //await 等User輸入資料
                        try {
                          await _auth.signInWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text);
                          ref
                              .read(userProvider.notifier)
                              .login(_emailController.text);
                          //userProvider
                        } catch (e) {
                          // 若有 異常(e) 則以ScaffoldMessager顯示讓User知道 e 的內容
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())));
                        }
                      }
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 195, 171),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                //Signup button
                Container(
                  margin: const EdgeInsets.all(15),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextButton(
                    onPressed: () {
                      // // print('print Signup button');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignUp()),
                      );
                    },
                    child: const Text(
                      'SignUp',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 195, 171),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                //ShopSignUp
                Container(
                  margin: const EdgeInsets.all(15),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  width: 150,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: TextButton(
                    onPressed: () {
                      // print('print Signup button');
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ShopSignUp()),
                      );
                    },
                    child: const Text(
                      'ShopSignUp',
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 195, 171),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
               
                //socialmedia login button
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Padding(
                //       padding: EdgeInsets.all(20),
                //       child: IconButton(
                //         onPressed: () {
                //           // 在此處添加處理 Facebook 登入的程式碼
                //         },
                //         icon: Image.asset(
                //           'assets/facebook_icon.png', // 替換為您的圖標
                //           width: 30, // 設定圖標的寬度
                //           height: 30, // 設定圖標的高度
                //           color: Color.fromARGB(255, 89, 77, 77),
                //         ),
                //       ),
                //     ),
                //     // Facebook 登入按鈕

                //     Padding(
                //       padding: EdgeInsets.all(20),
                //       child: IconButton(
                //         onPressed: () {
                //           // 在此處添加處理 Google 登入的程式碼
                //         },
                //         icon: Image.asset(
                //           'assets/google_icon.png', // 替換為您的圖標
                //           width: 30, // 設定圖標的寬度
                //           height: 30, // 設定圖標的高度
                //           color: Color.fromARGB(255, 89, 77, 77),
                //         ),
                //       ),
                //     ),
                //     // Google 登入按鈕

                //     Padding(
                //       padding: EdgeInsets.all(20),
                //       child: IconButton(
                //         onPressed: () {
                //           // 在此處添加處理 Apple 登入的程式碼
                //         },
                //         icon: Image.asset(
                //           'assets/apple_icon.png', // 替換為您的圖標
                //           width: 30, // 設定圖標的寬度
                //           height: 30, // 設定圖標的高度
                //           color: Color.fromARGB(255, 89, 77, 77),
                //         ),
                //       ),
                //     )
                //     // Apple 登入按鈕
                //   ],
                // ),
              ])),
    );
  }
}
