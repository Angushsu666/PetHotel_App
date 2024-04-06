import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import '../providers/user_provider.dart';
import '../pages/search.dart';
import 'signUp.dart';
import 'signUpShop.dart';
//firebase auth
import 'package:firebase_auth/firebase_auth.dart';

class SignIn extends ConsumerStatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  ConsumerState<SignIn> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  //firebase auth
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _signInKey = GlobalKey();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  String? _verificationId;

  final String _countryCode = '+886';

  Future<void> _verifyPhoneNumber(BuildContext context) async {
    print(
        "开始执行验证电话号码的过程，电话号码为: $_countryCode${_phoneController.text}"); // 打印电话号码
    await _auth.verifyPhoneNumber(
      phoneNumber: '$_countryCode${_phoneController.text}',
      verificationCompleted: (PhoneAuthCredential credential) async {
        print("验证完成回调被调用"); // 在验证完成的回调中添加日志
        await _auth.signInWithCredential(credential);
        print("使用凭证成功登录");
      },
      verificationFailed: (FirebaseAuthException e) {
        print("验证失败回调被调用，错误信息：${e.message}"); // 在验证失败的回调中添加日志
      },
      codeSent: (String verificationId, int? resendToken) {
        print("验证码已发送，verificationId: $verificationId"); // 在验证码发送的回调中添加日志
        setState(() {
          _verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        print("验证码自动检索超时，verificationId: $verificationId"); // 在自动检索超时的回调中添加日志
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  Future<void> signInWithPhoneNumber(BuildContext context) async {
    // 先检查验证码ID是否存在
    if (_verificationId != null) {
      try {
        final AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!,
          smsCode: _otpController.text,
        );

        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);

        // 如果登录成功，跳转到搜索页，并执行登录操作
        if (userCredential.user != null) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => SearchPage()));
          await ref
              .read(userProvider.notifier)
              .login('${_countryCode}${_phoneController.text}');
        }
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Login failed: $e")));
      }
    } else {
      // 如果 _verificationId 为 null，使用对话框显示错误信息
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Verification ID is null. Please request OTP again."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('登入'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 50), // 可以調整與 Container 的間距

          Image.asset(
            'assets/logo3.png',
            width: 150,
            height: 150,
          ),
          const SizedBox(height: 20), // 可以調整與 Container 的間距

          Form(
              key: _signInKey, //key很重要
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 16), // 可以調整與 Container 的間距
                    // 手机号码输入框
                    Container(
                      margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: '手機號碼',
                          prefixText: '$_countryCode ',
                          prefixStyle: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // 发送验证码按钮
                    ElevatedButton(
                      onPressed: () async {
                        print("發送驗證碼按钮被点击"); // 在按钮点击时添加日志
                        await _verifyPhoneNumber(context);
                      },
                      child: const Text(
                        '發送驗證碼',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black38,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Color.fromRGBO(255, 239, 239, 1.0), // 设置背景色
                        ), // 设置按钮背景颜色
                      ),
                    ),

                    const SizedBox(height: 20),
                    // 验证码输入框
                    Container(
                      margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextFormField(
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          hintText: '驗證碼',
                          border: InputBorder.none, // 移除输入框底线
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "please enter the OTP";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 登录按钮
                    Container(
                      margin: const EdgeInsets.all(15),
                      width: 150,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 239, 239, 1.0), // 设置背景色
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          if (_signInKey.currentState!.validate()) {
                            try {
                              await signInWithPhoneNumber(context);
                            } catch (e) {
                              // 若有 異常(e) 則以ScaffoldMessager顯示讓User知道 e 的內容
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                            }
                          }
                        },
                        child: const Text(
                          '登入',
                          style: TextStyle(
                            color: Colors.black38,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    //Signup button 記得將用戶跟商家並排！！！
                    //ShopSignUp// 用户注册和商家注册按钮并排布局
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center, // 按钮水平居中
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8), // 在两个按钮之间添加一些间隔
                            height: 50,
                            decoration: BoxDecoration(
                              color:
                                  Color.fromRGBO(255, 239, 239, 1.0), // 设置背景色
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUp()),
                                );
                              },
                              child: const Text(
                                '用戶註冊',
                                style: TextStyle(
                                  color: Colors.black38,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8), // 在两个按钮之间添加一些间隔
                            height: 50,
                            decoration: BoxDecoration(
                              color:
                                  Color.fromRGBO(255, 239, 239, 1.0), // 设置背景色
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ShopSignUp()),
                                );
                              },
                              child: const Text(
                                '商家註冊',
                                style: TextStyle(
                                  color: Colors.black38,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ])),
        ],
      ),
    );
  }
}
