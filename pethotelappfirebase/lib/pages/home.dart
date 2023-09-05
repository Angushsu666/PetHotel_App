import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/user_provider.dart';
// import '../providers/tweet_provider.dart';

// import '../models/tweet.dart';
import 'setting.dart';
// import 'create.dart';

class Home extends ConsumerWidget {
  const Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    LocalUser currentUser = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4.0),
          child: Container(
            color: Colors.grey,
            height: 1,
          ),
        ),
        // title: const Image(
        //   image: AssetImage('assets/petlogo.png'),
        //   width: 50,
        // ),
        leading: Builder(builder: (context) {
          return GestureDetector(
            //要再建一個builder
            onTap: () => Scaffold.of(context).openDrawer(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(currentUser.user.profilePic),
              ),
            ),
          );
        }),
      ),

      //show在螢幕上
      body: Column(children: [
        Text(currentUser.user.email),
        Text(currentUser.user.name),
      ]),

      // body: ref.watch(feedProvider).when(
      //     data: (List<Tweet> tweets) {
      //       return ListView.separated(
      //         separatorBuilder: (context, index) => Divider(
      //           color: Colors.black,
      //         ),
      //         itemCount: tweets.length,
      //         itemBuilder: (context, count) {
      //           return ListTile(
      //             leading: CircleAvatar(
      //               foregroundImage: NetworkImage(
      //                 tweets[count].profilePic,
      //               ),
      //             ),
      //             title: Text(
      //               tweets[count].name,
      //               style: const TextStyle(fontWeight: FontWeight.bold),
      //             ),
      //             subtitle: Text(
      //               tweets[count].tweet,
      //               style: const TextStyle(
      //                 color: Colors.black,
      //                 fontSize: 16,
      //               ),
      //             ),
      //           );
      //         },
      //       );
      //     },
      //     error: (error, StackTrace) => const Center(
      //           child: Text('error'),
      //         ),
      //     loading: () => const CircularProgressIndicator()),
      //Drawer
      drawer: Drawer(
        child: Column(
          children: [
            Image.network(currentUser.user.profilePic),
            ListTile(
              title: Text(
                "Hello,${currentUser.user.name} ",
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            ListTile(
              title: Text("Settings"),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const settings()));
              },
            ),
            ListTile(
              //點擊後登出，
              title: Text("Sign"),
              onTap: () {
                FirebaseAuth.instance.signOut();
                ref.read(userProvider.notifier).logout();
                //userProvider.notifier?
              },
            ),
          ],
        ),
      ),
      //右下角的Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.of(context)
          //     .push(MaterialPageRoute(builder: (context) => CreateTweet()));
        },
        //加號呈現
        child: Icon(Icons.add),
      ),
    );
  }
}
