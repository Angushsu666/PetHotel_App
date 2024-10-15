//import 'dart:html';
import 'dart:io'; // Make sure to include this import

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/user.dart';

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
              phone: "error", name: "error", profilePic: "error",
              isShopOwner: false, // 預設為 false
              shops: [], // 添加这个属性
            ),
          ),
        );
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  //登入
  Future<void> login(String phone) async {
    QuerySnapshot response = await _firestore
        .collection("users")
        .where('phone', isEqualTo: phone)
        .get();
    if (response.docs.isEmpty) {
      print("No firestore user assiciated to authenticated phone $phone");
      return;
    }
    if (response.docs.length != 1) {
      print("More than one firestore user associate with phone: $phone");
      return;
    }
    //？？？？？？？
    state = LocalUser(
        id: response.docs[0].id,
        user: FirebaseUser.fromMap(
            response.docs[0].data() as Map<String, dynamic>));
  }

  // 一般用戶註冊
  Future<void> signUp(String phone, String name) async {
    DocumentReference response = await _firestore.collection("users").add(
          FirebaseUser(
            phone: phone,
            name: name, // 使用传入的name参数
            profilePic: "https://i.imgur.com/ZX0PtRb.png",
            isShopOwner: false,
            shops: [],
          ).toMap(),
        );

    DocumentSnapshot snapshot = await response.get();
    state = LocalUser(
      id: response.id,
      user: FirebaseUser.fromMap(snapshot.data() as Map<String, dynamic>),
    );
  }

  // 一般用戶註冊
  // Future<void> signUpwemail(String phone) async {
    // DocumentReference response = await _firestore.collection("users").add(
          // FirebaseUser(
            // phone: phone,
            // name: "No Name",
            // profilePic: "https://i.imgur.com/ZX0PtRb.png",
            // isShopOwner: false, // 設定為 false
            // shops: [],
          // ).toMap(),
        // );

    // DocumentSnapshot snapshot = await response.get();
    // state = LocalUser(
      // id: response.id,
      // user: FirebaseUser.fromMap(snapshot.data() as Map<String, dynamic>),
    // );
  // }

  // 店家註冊
  Future<void> shopSignUp(String phone, String name) async {
    DocumentReference response = await _firestore.collection("users").add(
          FirebaseUser(
            phone: phone,
            name: name, // 使用传入的name参数
            profilePic: "https://i.imgur.com/ZX0PtRb.png",
            isShopOwner: true, // 設定為 true
            shops: [],
          ).toMap(),
        ); //將users資料加進Cloud Firestore

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

  //更新圖片
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

  //刪除使用者資料
  Future<void> deleteUser() async {
  try {
    // 獲取當前用戶的 Firebase Authentication 紀錄
    User? currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception('No user is currently signed in.');
    }

    // 刪除 Firestore 中的用戶文檔
    await _firestore.collection("users").doc(state.id).delete();

    // 刪除 Firebase Authentication 紀錄
    await currentUser.delete();

    // 重設狀態
    logout(); // 假設 logout 重設了狀態，如之前提供的代碼所示
  } catch (e) {
    print('Failed to delete user: $e');
    throw Exception('Failed to delete user: ${e.toString()}');
  }
}

  // Update existing logout method to just clear state
  void logout() {
    state = const LocalUser(
      id: "error",
      user: FirebaseUser(
        phone: "error",
        name: "error",
        profilePic: "error",
        isShopOwner: false,
        shops: [],
      ),
    );
  }
}
