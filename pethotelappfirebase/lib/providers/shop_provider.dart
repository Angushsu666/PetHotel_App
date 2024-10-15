import 'dart:io'; // Make sure to include this import
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

  final FirebaseStorage storage = FirebaseStorage.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final bool _shopsFetched = false;

  // Future<void> fetchShops() async {
    // if (_shopsFetched) return; // 如果已经获取了数据，就不再执行
    // _shopsFetched = true; // 标记为已获取数据

    // final response = await http.get(Uri.parse(
        // 'https://data.moa.gov.tw/Service/OpenData/TransService.aspx?UnitId=fNT9RMo8PQRO&\$top=5000&\$skip=0'));
       //https://data.moa.gov.tw/Service/OpenData/TransService.aspx?UnitId=fNT9RMo8PQRO&$top=5000&$skip=0

    // if (response.statusCode == 200) {
      // final List<dynamic> jsonData = json.decode(response.body);
//      // 解析并排序（根据ID降序排列）
      // final List<petShop> shops =
          // jsonData.map((item) => petShop.fromJson(item)).toList();
      // shops.sort((a, b) => int.parse(b.id).compareTo(int.parse(a.id)));

      // final firestore = FirebaseFirestore.instance;
      // final petShopsCollection = firestore.collection('petShops');

//     //使用Map来记录已处理的legalname
      // final Map<String, petShop> addedShops = {};

      // for (var shop in shops) {
        // final DateTime validDate = parseValidDate(shop.validDate);
        // if (validDate.isBefore(DateTime.now()) ||
            // addedShops.containsKey(shop.legalName)) continue;

        // var existingDoc = await petShopsCollection
            // .where('legalName', isEqualTo: shop.legalName)
            // .get();

        // if (existingDoc.docs.isEmpty) {
//          //设置默认值
          // shop.roomCollection['獨立房型'] ??= {
            // '小型犬': 0,
            // '中型犬': 0,
            // '大型犬': 0,
            // '貓': 0
          // };
          // shop.roomCollection['開放式住宿'] ??= {
            // '小型犬': 0,
            // '中型犬': 0,
            // '大型犬': 0,
            // '貓': 0
          // };
          // shop.roomCollection['半開放式住宿'] ??= {
            // '小型犬': 0,
            // '中型犬': 0,
            // '大型犬': 0,
            // '貓': 0
          // };
          // shop.petGrooming['小美容'] ??= {'小型犬': 0, '中型犬': 0, '大型犬': 0, '貓': 0};
          // shop.petGrooming['大美容'] ??= {'小型犬': 0, '中型犬': 0, '大型犬': 0, '貓': 0};

//         // 添加到 Firestore
          // await petShopsCollection.add(shop.toMap());
          // addedShops[shop.legalName] = shop;
          // print(
              // "Added shop with legalName: ${shop.legalName} and ID: ${shop.id}");
        // } else {
          // print("Skipped existing shop with legalName: ${shop.legalName}");
        // }
      // }

      // state = addedShops.values.toList();
    // } else {
      // _shopsFetched = false;
      // throw Exception('Failed to fetch shops data');
    // }
  // }

  // 添加多张照片到 Firebase Storage
  Future<void> uploadAlbum(
      List<File> images, String shopName, LocalUser currentUser) async {
    {
      CollectionReference petShopsCollection = firestore.collection('petShops');
      QuerySnapshot querySnapshot = await petShopsCollection
          .where('uid', isEqualTo: currentUser.user.phone)
          .limit(1) // 限制只获取一个匹配的文档
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String shopId = querySnapshot.docs.first.id;

        List<String> imageUrls = [];
        int counter = 0;
        print('uploadAlbum的shopName:$shopName');
        print('uploadAlbum的shopId:$shopId');

        // 上傳到store, Upload each image and collect URLs
        for (var image in images) {
          String fileName =
              'petshop/$shopName/${DateTime.now().millisecondsSinceEpoch}_$counter.jpg';
          counter++;
          UploadTask uploadTask = storage.ref(fileName).putFile(image);
          TaskSnapshot snapshot = await uploadTask;
          String imageUrl = await snapshot.ref.getDownloadURL();
          imageUrls.add(imageUrl);
        }
        // 上傳到firestore, Update Firestore document
        try {
          await firestore
              .collection('petShops')
              .doc(shopId)
              .update({'album': FieldValue.arrayUnion(imageUrls)});
          print('Images uploaded and Firestore updated.');
        } catch (e) {
          print('Error uploading images to Firebase: $e');
        }
      } else {
        print('No shop found for the current user.');
        return;
      }
    }
  }

  //從firestore抓資料
  Future<List<petShop>> fetchFirestoreShops() async {
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

  //取得單獨商家資料
  Future<petShop> getShopData(LocalUser currentUser) async {
    final petShopsCollection = firestore.collection('petShops');

    final querySnapshot = await petShopsCollection
        .where('uid', isEqualTo: currentUser.user.phone)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final shopData = querySnapshot.docs.first.data();
      print("getShopData: $shopData"); // 打印获取到的数据
      final shop = petShop.fromMap(shopData);
      return shop;
    } else {
      throw Exception("No shop found for the current user.");
    }
  }

  //沒用到->參考用
  Future<void> postPrice(int updatedprice, LocalUser currentUser) async {
    CollectionReference petShopsCollection = firestore.collection('petShops');
    print(' currentUser.user.name:${currentUser.user.name}');
    print(' currentUser.id:${currentUser.id}');
    //手動去更新商家的uid讓他跟currentUser的phone一樣，即可判斷誰可以更新價錢。
    QuerySnapshot querySnapshot = await petShopsCollection
        .where('uid', isEqualTo: currentUser.user.phone)
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

  Future<void> changeIntro(String updatedIntro, LocalUser currentUser) async {
    CollectionReference petShopsCollection = firestore.collection('petShops');
    QuerySnapshot querySnapshot = await petShopsCollection
        .where('uid', isEqualTo: currentUser.user.phone)
        .limit(1)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      String shopId = querySnapshot.docs.first.id;
      try {
        await petShopsCollection
            .doc(shopId)
            .update({'introduction': updatedIntro});
        print('Intro updated successfully');
      } catch (e) {
        print('Error updating Intro: $e');
      }
    } else {
      print('No matching document found');
    }
  }

  Future<void> changeRoomPrice(
      Map<String, Map<String, int>> updatedRoomCollection,
      LocalUser currentUser) async {
    CollectionReference petShopsCollection = firestore.collection('petShops');
    print('Querying for uid: ${currentUser.user.phone}');
    QuerySnapshot querySnapshot = await petShopsCollection
        .where('uid', isEqualTo: currentUser.user.phone)
        .limit(1)
        .get();
    print('Found ${querySnapshot.docs.length} matching documents');

    if (querySnapshot.docs.isNotEmpty) {
      String shopId = querySnapshot.docs.first.id;

      try {
        await petShopsCollection.doc(shopId).update({
          'roomCollection': updatedRoomCollection.map((key, value) => MapEntry(
              key, value.map((subKey, subValue) => MapEntry(subKey, subValue))))
        });
        print('Room collection updated successfully');
      } catch (e) {
        print('Error updating room collection: $e');
      }
    } else {
      print('No matching document found');
    }
  }

  Future<void> changeGroomingPrice(
      Map<String, Map<String, int>> updatedGroomingCollection,
      LocalUser currentUser) async {
    CollectionReference petShopsCollection = firestore.collection('petShops');
    print('Querying for uid: ${currentUser.user.phone}');
    QuerySnapshot querySnapshot = await petShopsCollection
        .where('uid', isEqualTo: currentUser.user.phone)
        .limit(1)
        .get();
    print('Found ${querySnapshot.docs.length} matching documents');
    if (querySnapshot.docs.isNotEmpty) {
      String shopId = querySnapshot.docs.first.id;
      try {
        await petShopsCollection.doc(shopId).update({
          'petGrooming': updatedGroomingCollection.map((key, value) => MapEntry(
              key, value.map((subKey, subValue) => MapEntry(subKey, subValue))))
        });
        print('Grooming collection updated successfully');
      } catch (e) {
        print('Error updating Grooming collection: $e');
      }
    } else {
      print('No matching document found');
    }
  }

  Future<void> changeFoodChoice(
      Map<String, bool> updatedFoodChoice, LocalUser currentUser) async {
    CollectionReference petShopsCollection = firestore.collection('petShops');

    QuerySnapshot querySnapshot = await petShopsCollection
        .where('uid', isEqualTo: currentUser.user.phone)
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
    CollectionReference petShopsCollection = firestore.collection('petShops');

    QuerySnapshot querySnapshot = await petShopsCollection
        .where('uid', isEqualTo: currentUser.user.phone)
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
    CollectionReference petShopsCollection = firestore.collection('petShops');

    QuerySnapshot querySnapshot = await petShopsCollection
        .where('uid', isEqualTo: currentUser.user.phone)
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

  //用戶評論商家
  Future<void> addReview(String customShopId, Review newReview) async {
    //使用商家的id查询文档，並加入評論的欄位，petshops裡面的id。
    //可能要改方式
    QuerySnapshot querySnapshot = await firestore
        .collection('petShops')
        .where('id', isEqualTo: customShopId)
        .get();

    // 确认查询返回了文档
    if (querySnapshot.docs.isNotEmpty) {
      // 获取第一个匹配的文档引用
      DocumentReference shopDocRef = querySnapshot.docs.first.reference;

      // 進行更新操作
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

  //商家回覆用戶，只有商家可以回覆
  Future<void> addShopResponse(LocalUser currentUser, String reviewTimestamp,
      String responseContent) async {
    print('responseContent::$responseContent');
    // 获取包含要更新评论的 petShop 文档
    QuerySnapshot querySnapshot = await firestore
        .collection('petShops')
        .where('uid', isEqualTo: currentUser.user.phone)
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
