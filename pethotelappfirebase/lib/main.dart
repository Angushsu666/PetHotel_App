import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../providers/user_provider.dart';
import '../pages/search.dart';
import '../pages/signin.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } on FirebaseException catch (e) {
    // 检查异常是否因为 Firebase App 已存在
    if (e.code != 'duplicate-app') {
      // 如果不是因为 App 已存在的异常，重新抛出
      rethrow;
    }
    // 如果是因为 App 已存在，则忽略此异常
  }
  initializeDateFormatting('zh_CN', null).then((_) {
    runApp(ProviderScope(child: MyApp()));
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:
          // StreamBuilder<User?>(
          //   stream: FirebaseAuth.instance.authStateChanges(),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       // 使用 FlutterSpinKit 的一个加载动画
          //       return Center(
          //         child: SpinKitFadingCircle(
          //           color: Colors.blue,
          //           size: 50.0,
          //         ),
          //       );
          //     } else if (snapshot.hasData) {
          //       // 数据加载完成，且有用户数据，跳转到SearchPage
          //       ref.read(userProvider.notifier).login(snapshot.data!.phoneNumber!);
          //       return SearchPage();
          //     } else {
          //       // 数据加载完成，但没有用户数据，跳转到SignIn
          //       return SignIn();
          //     }
          //   },
          // ),
          StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 显示加载动画
            return Center(
              child: SpinKitFadingCircle(
                color: const Color.fromRGBO(255, 239, 239, 1.0),
                size: 50.0,
              ),
            );
          } else {
            // 人为延迟2秒以观察加载动画，仅用于测试
            return FutureBuilder(
              future: Future.delayed(Duration(seconds: 2)),
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    color: Color.fromRGBO(255, 239, 239, 1.0), // 设置背景色
                    child: Center(
                      child: Image.asset('assets/loading.png', width: 150.0, height: 150.0,), // 使用您自己的图片
                    ),
                  );
                } else {
                  // 数据加载完成，判断是否有用户数据
                  if (snapshot.hasData) {
                    ref
                        .read(userProvider.notifier)
                        .login(snapshot.data!.phoneNumber!);
                    return SearchPage();
                  } else {
                    return SignIn();
                  }
                }
              },
            );
          }
        },
      ),
      theme: ThemeData(
          fontFamily: 'SourceHanSans', // 设置默认字体为 SourceHanSans
          appBarTheme: AppBarTheme(
            backgroundColor: Color.fromRGBO(255, 239, 239, 1.0),
            shadowColor: Colors.transparent,
            titleTextStyle: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            centerTitle: true,
          ),
          scaffoldBackgroundColor: Colors.white // 设置所有页面背景色
          ),
    );
  }
}
