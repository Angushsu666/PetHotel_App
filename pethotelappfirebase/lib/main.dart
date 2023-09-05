import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../providers/user_provider.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pages/home.dart';
import '../pages/search.dart';
import '../pages/signin.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Initialize Flutter bindings first
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MyApp()); // Replace MyApp with your app's main widget
// }
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: Scaffold(body:Container(
      //   child:Text("ssssa"),
      // )),
      home: StreamBuilder<User?>(
          // Stream 會回傳 User type
          stream: FirebaseAuth.instance
              .authStateChanges(), // 等串流，這裡是firebase回傳的_auth state)
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //refresh後才不會消失？？？？？？
              ref.read(userProvider.notifier).login(snapshot.data!.email!);
              // snapshot裡面是否有User
              return SearchPage();
            }
            return SignIn();
          }),
      theme: ThemeData(
          appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        titleTextStyle: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        centerTitle: true,
      )),
    );
  }
}
