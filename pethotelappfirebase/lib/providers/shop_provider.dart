import 'dart:io'; // Make sure to include this import
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../providers/user_provider.dart';
import '../models/petshop.dart'; // 根據你的資料模型路徑
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// 尝试解析日期字符串
DateTime parseValidDate(String dateString) {
  dateString = dateString.replaceAll('上午', 'AM').replaceAll('下午', 'PM');
  // 注意：根据实际的日期时间格式调整下面的格式
  DateFormat format = DateFormat("yyyy/M/d a hh:mm:ss");

  try {
    return format.parse(dateString);
  } on FormatException catch (e) {
    print('Date parsing error: $e');
    // 返回一个默认日期或当前日期，或者处理错误
    return DateTime.now();
  }
}

class ShopsNotifier extends StateNotifier<List<petShop>> {
  ShopsNotifier() : super(([]));
  final DateFormat format = DateFormat("yyyy/M/d a hh:mm:ss"); // 根据实际格式调整

  bool _shopsFetched = false;
  Future<void> fetchShops() async {
    if (_shopsFetched) return; // 如果已经获取了数据，就不再执行
    _shopsFetched = true; // 标记为已获取数据

    final response = await http.get(Uri.parse(
        'https://data.moa.gov.tw/Service/OpenData/TransService.aspx?UnitId=fNT9RMo8PQRO&\$top=1000&\$skip=0&legalname=%e6%9d%b1%e6%a3%ae'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      // 解析并排序（根据ID降序排列）
      final List<petShop> shops =
          jsonData.map((item) => petShop.fromJson(item)).toList();
      shops.sort((a, b) => int.parse(b.id).compareTo(int.parse(a.id)));

      final firestore = FirebaseFirestore.instance;
      final petShopsCollection = firestore.collection('petShops');

      // 使用Map来记录已处理的legalname
      final Map<String, petShop> addedShops = {};

      for (var shop in shops) {
        // 如果validdate已过期或者已添加了相同legalname的最新记录，则跳过
        final DateTime validDate = parseValidDate(shop.validDate);
        if (validDate.isBefore(DateTime.now()) ||
            addedShops.containsKey(shop.legalName)) continue;

// 检查Firestore中是否已存在
        var existingDoc = await petShopsCollection
            .where('legalName', isEqualTo: shop.legalName)
            .get();

        if (existingDoc.docs.isEmpty) {
          // 如果不存在，则添加到Firestore和addedShops记录中
          await petShopsCollection.add(shop.toMap());
          addedShops[shop.legalName] = shop; // 添加记录
          print(
              "Added shop with legalName: ${shop.legalName} and ID: ${shop.id}"); // 使用正确的属性名
        } else {
          // 这家商店已经存在
          print("Skipped existing shop with legalName: ${shop.legalName}");
        }
      }

      // 更新状态
      state = addedShops.values.toList();
    } else {
      _shopsFetched = false; // 如果失败，重置标志以允许重新尝试
      throw Exception('Failed to fetch shops data');
    }
  }

  //從firestore抓資料
  Future<List<petShop>> fetchFirestoreShops() async {
    final firestore = FirebaseFirestore.instance;
    CollectionReference petShopsCollection = firestore.collection('petShops');

    QuerySnapshot querySnapshot = await petShopsCollection.get();
    print(
        "Found ${querySnapshot.docs.length} documents in petShops collection.");

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
      //可判斷誰可以更改。
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

  Future<void> addShopResponse(
      LocalUser currentUser, String reviewTimestamp, String responseContent) async {
    final firestore = FirebaseFirestore.instance;
    print('responseContent::' + responseContent);
    // 获取包含要更新评论的 petShop 文档
    QuerySnapshot querySnapshot = await firestore
        .collection('petShops')
        .where('uid', isEqualTo: currentUser.user.name)
        .get();
    DocumentReference shopDocRef = querySnapshot.docs.first.reference;
    await firestore.runTransaction((transaction) async {
      DocumentSnapshot shopSnapshot = await transaction.get(shopDocRef);
      if (!shopSnapshot.exists) {
        throw Exception("Shop does not exist!");
      }

      // 获取当前的 reviews 数组
      var shopData = shopSnapshot.data() as Map<String, dynamic>;
      List<dynamic> reviews = shopData['reviews'] ?? [];

      // 创建回复对象
      final response = Response(
        content: responseContent,
        responseTimestamp: DateTime.now(),
      ).toMap();

      // 遍历 reviews，找到匹配的 review 并更新 shopResponse
      for (var review in reviews) {
        if (review['reviewTimestamp'] == reviewTimestamp) {
          review['shopResponse'] = response;
          break; // 找到匹配的评论后就退出循环
        }
      }

      // 将更新后的 reviews 数组写回 Firestore
      transaction.update(shopDocRef, {'reviews': reviews});
    });
  }
}

final shopsProvider = StateNotifierProvider<ShopsNotifier, List<petShop>>(
    (ref) => ShopsNotifier());
