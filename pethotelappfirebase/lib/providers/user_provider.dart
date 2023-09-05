//import 'dart:html';
import 'dart:io'; // Make sure to include this import

import 'package:firebase_storage/firebase_storage.dart';
import '../models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateNotifierProvider<UserNotifier, LocalUser>((ref) {
  return UserNotifier();
});

class LocalUser {
  const LocalUser({required this.id, required this.user});

  final String id;
  final FirebaseUser user;

  LocalUser copyWith({
    String? id,
    FirebaseUser? user,
  }) {
    return LocalUser(
      id: id ?? this.id,
      user: user ?? this.user,
    ); //如果 id 變數不為空，就將 id 的值指派給該屬性。如果 id 為空，則將使用 this.id 的值
  }
}

class UserNotifier extends StateNotifier<LocalUser> {
  UserNotifier()
      : super(
          const LocalUser(
            id: "error",
            user: FirebaseUser(
              email: "error", name: "error", profilePic: "error",
              isShopOwner: false, // 預設為 false
              shops: [], // 添加这个属性
            ),
          ),
        );
  //firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //store
  final FirebaseStorage _storage = FirebaseStorage.instance;

  //登入
  Future<void> login(String email) async {
    QuerySnapshot response = await _firestore
        .collection("users")
        .where('email', isEqualTo: email)
        .get();
    if (response.docs.isEmpty) {
      print("No firestore user assiciated to authenticated email $email");
      return;
    }
    if (response.docs.length != 1) {
      print("More than one firestore user associate with email: $email");
      return;
    }
    //？？？？？？？
    state = LocalUser(
        id: response.docs[0].id,
        user: FirebaseUser.fromMap(
            response.docs[0].data() as Map<String, dynamic>));
  }

  // 一般用戶註冊
  Future<void> signUp(String email) async {
    DocumentReference response = await _firestore.collection("users").add(
          FirebaseUser(
            email: email,
            name: "No Name",
            profilePic: "https://i.imgur.com/ZX0PtRb.png",
            isShopOwner: false, // 設定為 false
            shops: [],
          ).toMap(),
        );

    DocumentSnapshot snapshot = await response.get();
    state = LocalUser(
      id: response.id,
      user: FirebaseUser.fromMap(snapshot.data() as Map<String, dynamic>),
    );
  }

  // 店家註冊
  Future<void> shopSignUp(String email) async {
    DocumentReference response = await _firestore.collection("users").add(
          FirebaseUser(
            email: email,
            name: "No Name",
            profilePic: "https://i.imgur.com/ZX0PtRb.png",
            isShopOwner: true, // 設定為 true
            shops: [],
          ).toMap(),
        );//將users資料加進Cloud Firestore

    DocumentSnapshot snapshot = await response.get();
    state = LocalUser(
      id: response.id,
      user: FirebaseUser.fromMap(snapshot.data() as Map<String, dynamic>),
    );
  }

  Future<void> updateName(String name) async {
    await _firestore.collection("users").doc(state.id).update({'name': name});
    state = state.copyWith(user: state.user.copyWith(name: name));
  }
  //updateImage
  Future<void> updateImage(File image) async {
    //we want a folder in our storage
    Reference ref = _storage.ref().child("users").child(state.id);
    //upload image
    TaskSnapshot snapshot = await ref.putFile(image);
    //we got Url from uploaded image
    String profilePicUrl = await snapshot.ref.getDownloadURL();
    await _firestore
        .collection("users")
        .doc(state.id)
        .update({'profilePic': profilePicUrl});
    state =
        state.copyWith(user: state.user.copyWith(profilePic: profilePicUrl));
  }

  //登出
  void logout() {
    state = const LocalUser(
      id: "error",
      user: FirebaseUser(
        email: "error",
        name: "error",
        profilePic: "error",
        isShopOwner: false, // 設定為 false //?????但這樣登出後店家登入會不會被當作一般的使用者
        shops: [],
      ),
    );
  }
}
