import 'dart:io'; // Make sure to include this import
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../providers/user_provider.dart';
import '../models/petshop.dart'; // 根據你的資料模型路徑
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ShopsNotifier extends StateNotifier<List<petShop>> {
  ShopsNotifier() : super(([]));
  bool _shopsFetched = false; // 使用静态变量来全局跟踪是否已获取数据

  void updateShops(List<petShop> newShops) {
    state = (newShops);
  }

  //從開放式網站抓資料
  Future<void> fetchShops() async {
    if (state.isNotEmpty) {
      // 如果已经有数据，不再执行 HTTP 请求
      print('full');
      return;
    } else {
      print('empty');
      final response = await http.get(Uri.parse(
          'https://data.moa.gov.tw/Service/OpenData/TransService.aspx?UnitId=fNT9RMo8PQRO&\$top=1000&\$skip=0'));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final List<petShop> shops =
            jsonData.map((item) => petShop.fromJson(item)).toList();
        // 將商店寫入 Firestore 數據庫
        final firestore = FirebaseFirestore.instance;

        // 將商店列表逐個添加到集合中
        CollectionReference petShopsCollection =
            firestore.collection('petShops');
        shops.forEach((shop) {
          petShopsCollection.add(shop.toMap());
        });
        state = shops; // Update the state
      } else {
        throw Exception('Unable to fetch shop data');
      }
    }
    _shopsFetched = true; // 将标志设置为true，表示已加载数据
  }

  //從firestore抓資料
  Future<List<petShop>> fetchFirestoreShops() async {
    final firestore = FirebaseFirestore.instance;
    CollectionReference petShopsCollection = firestore.collection('petShops');

    QuerySnapshot querySnapshot = await petShopsCollection.get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>?; // 强制转换为非空值
        if (data != null) {
          return petShop.fromMap(data);
        } else {
          // 处理数据为空的情况，这里可以返回默认值或者抛出异常
          throw Exception('Firestore shop data is null');
          // 这里返回一个默认值，可以根据实际情况修改
        }
      }).toList();
    } else {
      throw Exception('No Firestore shop data found');
    }
  }

  Future<void> postPrice(int updatedprice, LocalUser currentUser) async {
    final firestore = FirebaseFirestore.instance;
    CollectionReference petShopsCollection = firestore.collection('petShops');
    print(' currentUser.user.name:' + currentUser.user.name);
    print(' currentUser.id:' + currentUser.id);
    //手動去更新商家的uid讓他跟currentUser的name一樣，即可判斷誰可以更新加錢。
    QuerySnapshot querySnapshot = await petShopsCollection
        .where('uid', isEqualTo: currentUser.user.name)
        .limit(1) // 限制只获取一个匹配的文档
        .get();
    // print('Query Snapshot: $querySnapshot');

    if (querySnapshot.docs.isNotEmpty) {
      String shopId = querySnapshot.docs.first.id;
      print(shopId);
      print(updatedprice);
      try {
        await petShopsCollection.doc(shopId).update({'price': updatedprice});
        print('Price updated successfully in PostPrice');
      } catch (e) {
        print('Error updating price: $e');
      }
    } else {
      print('No matching document found');
    }
  }

  Future<void> changeRoom(
      Map<String, bool> updatedRoomCollection, LocalUser currentUser) async {
    final firestore = FirebaseFirestore.instance;
    CollectionReference petShopsCollection = firestore.collection('petShops');

    QuerySnapshot querySnapshot = await petShopsCollection
        .where('uid', isEqualTo: currentUser.user.name)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String shopId = querySnapshot.docs.first.id;

      try {
        await petShopsCollection
            .doc(shopId)
            .update({'roomCollection': updatedRoomCollection});
        print('Room collection updated successfully');
      } catch (e) {
        print('Error updating room collection: $e');
      }
    } else {
      print('No matching document found');
    }
  }

  Future<void> changeFoodChoice(
      Map<String, bool> updatedFoodChoice, LocalUser currentUser) async {
    final firestore = FirebaseFirestore.instance;
    CollectionReference petShopsCollection = firestore.collection('petShops');

    QuerySnapshot querySnapshot = await petShopsCollection
        .where('uid', isEqualTo: currentUser.user.name)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String shopId = querySnapshot.docs.first.id;

      try {
        await petShopsCollection
            .doc(shopId)
            .update({'foodChoice': updatedFoodChoice});
        print('Food choice updated successfully');
      } catch (e) {
        print('Error updating food choice: $e');
      }
    } else {
      print('No matching document found');
    }
  }

  Future<void> changeServiceAndFacilities(
      Map<String, bool> updatedServiceAndFacilities,
      LocalUser currentUser) async {
    final firestore = FirebaseFirestore.instance;
    CollectionReference petShopsCollection = firestore.collection('petShops');

    QuerySnapshot querySnapshot = await petShopsCollection
        .where('uid', isEqualTo: currentUser.user.name)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String shopId = querySnapshot.docs.first.id;

      try {
        await petShopsCollection
            .doc(shopId)
            .update({'serviceAndFacilities': updatedServiceAndFacilities});
        print('Service and facilities updated successfully');
      } catch (e) {
        print('Error updating service and facilities: $e');
      }
    } else {
      print('No matching document found');
    }
  }

  Future<void> changeMedicalNeeds(
      Map<String, bool> updatedMedicalNeeds, LocalUser currentUser) async {
    final firestore = FirebaseFirestore.instance;
    CollectionReference petShopsCollection = firestore.collection('petShops');

    QuerySnapshot querySnapshot = await petShopsCollection
        .where('uid', isEqualTo: currentUser.user.name)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String shopId = querySnapshot.docs.first.id;

      try {
        await petShopsCollection
            .doc(shopId)
            .update({'medicalNeeds': updatedMedicalNeeds});
        print('Medical needs updated successfully');
      } catch (e) {
        print('Error updating medical needs: $e');
      }
    } else {
      print('No matching document found');
    }
  }

  Future<void> addReview(String customShopId, Review newReview) async {
    final firestore = FirebaseFirestore.instance;

    // 使用自定义字段查询文档
    QuerySnapshot querySnapshot = await firestore
        .collection('petShops')
        .where('id', isEqualTo: customShopId)
        .get();

    // 确认查询返回了文档
    if (querySnapshot.docs.isNotEmpty) {
      // 获取第一个匹配的文档引用
      DocumentReference shopDocRef = querySnapshot.docs.first.reference;

      // 进行更新操作
      await firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(shopDocRef);
        if (!snapshot.exists) {
          throw Exception("Shop does not exist!");
        }

        var snapshotData = snapshot.data() as Map<String, dynamic>?;
        List<dynamic> currentReviews = snapshotData?['reviews'] ?? [];
        currentReviews.add(newReview.toMap());

        transaction.update(shopDocRef, {'reviews': currentReviews});
      });

      // 更新本地状态
      state = [
        for (final shop in state)
          if (shop.id == customShopId)
            shop.copyWith(reviews: [...shop.reviews, newReview])
          else
            shop,
      ];
    } else {
      print("No shop found with id $customShopId");
    }
  }
}

final shopsProvider = StateNotifierProvider<ShopsNotifier, List<petShop>>(
    (ref) => ShopsNotifier());
