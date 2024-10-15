import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart'; // 匯入 services 庫來使用 LengthLimitingTextInputFormatter
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../providers/user_provider.dart';
import '../pages/search.dart';
import '../pages/privacyPolicyPage.dart';

class SignUp extends ConsumerStatefulWidget {
  const SignUp({super.key});

  @override
  ConsumerState<SignUp> createState() => _SignUpState();
}

class _SignUpState extends ConsumerState<SignUp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _signInKey = GlobalKey();
  bool _isChecked = false; // 用于跟踪勾选框的状态

  final ValueNotifier<int> _charCount = ValueNotifier(0); // Character count notifier

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() {
      _charCount.value = _nameController.text.length; // Update character count
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _charCount.dispose(); // Dispose of the ValueNotifier
    super.dispose();
  }

  String? _verificationId;
  int? _resendToken;
  final String _countryCode = '+886';
  Future<void> _verifyPhoneNumber() async {
    // Formatting the phone number to include the country code
    String formattedPhoneNumber = _formatPhoneNumber(_phoneController.text);
    print('formattedPhoneNumber:$formattedPhoneNumber');
    // Check if phone number is already registered
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('phone', isEqualTo: formattedPhoneNumber)
        .limit(1)
        .get();

    if (result.docs.isNotEmpty) {
      // Phone number has already been registered
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('此手機號碼已經註冊過')),
      );
      return; // Stop the function execution
    }
    await _auth.verifyPhoneNumber(
      phoneNumber: formattedPhoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // await _auth.signInWithCredential(credential);
        // 這行不要做任何動作
      },
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('驗證失敗，請重試。錯誤訊息：${e.message}')),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _resendToken = resendToken;
        });
      },
      timeout: const Duration(seconds: 60),
      forceResendingToken: _resendToken,
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          _verificationId = verificationId;
        });
      },
    );
  }

  String _formatPhoneNumber(String rawNumber) {
    if (rawNumber.startsWith('0')) {
      return '$_countryCode${rawNumber.substring(1)}';
    }
    return '$_countryCode$rawNumber';
  }

  Future<void> _verifyOTP() async {
    if (_verificationId != null) {
      try {
        final AuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId!,
          smsCode: _otpController.text,
        );
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        if (userCredential.user != null) {
          await ref.read(userProvider.notifier).signUp(
                userCredential.user!.phoneNumber!,
                _nameController.text,
              );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SearchPage()),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("驗證錯誤: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("驗證碼錯誤，請重新要求驗證碼。")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '註冊',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _signInKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  FontAwesomeIcons.dog,
                  color: Color.fromRGBO(255, 239, 239, 1.0), // 设置背景色

                  size: 70,
                ),
                const SizedBox(height: 20),
                const Text(
                  '請填入手機號碼',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(255, 239, 239, 1.0), // 设置背景色
                  ),
                ),
                const SizedBox(height: 20),
                // 新增用户名输入字段

                // Username input field and character count
                Container(
                  margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          hintText: '用戶名',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                        ),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(20),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: ValueListenableBuilder<int>(
                            valueListenable: _charCount,
                            builder: (_, value, __) {
                              return Text('$value/20',
                                  style: TextStyle(color: Colors.grey[600]));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

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
                      // prefixText: '$_countryCode ',
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
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await _verifyPhoneNumber();
                    } catch (e) {
                      print(
                          "Error occurred during phone number verification: $e");
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        const Color.fromRGBO(255, 239, 239, 1.0)),
                  ),
                  child: const Text(
                    '發送驗證碼',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black45,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextFormField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: '驗證碼',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ), // 移除输入框底线
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 20,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "請輸入驗證碼";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Checkbox(
                      value: _isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          _isChecked = value!;
                        });
                      },
                    ),
                    const Text('我已閱讀並同意'),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const PrivacyPolicyPage()), // 假设 PrivacyPolicyPage 是隐私政策的页面
                        );
                      },
                      child: const Text(
                        '隱私政策',
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),

                ElevatedButton(
                  onPressed: _isChecked
                      ? () async {
                          if (_signInKey.currentState!.validate()) {
                            _verifyOTP();
                          }
                        }
                      : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                        if (_isChecked) {
                          return const Color.fromRGBO(255, 239, 239, 1.0);
                        }
                        return Colors.grey;
                      },
                    ),
                  ),
                  child: const Text(
                    '立即註冊',
                    style: TextStyle(color: Colors.black45),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child:
                      const Text('已有帳號', style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          )),
    );
  }
}
