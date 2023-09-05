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

  void updateShops(List<petShop> newShops) {
    state = (newShops);
  }

  Future<void> fetchShops() async {
    final response = await http.get(Uri.parse(
        'https://data.moa.gov.tw/Service/OpenData/TransService.aspx?UnitId=fNT9RMo8PQRO&\$top=10&\$skip=0'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      final List<petShop> shops =
          jsonData.map((item) => petShop.fromJson(item)).toList();
      // 將商店寫入 Firestore 數據庫
      final firestore = FirebaseFirestore.instance;

      // 將商店列表逐個添加到集合中
      CollectionReference petShopsCollection = firestore.collection('petShops');
      shops.forEach((shop) {
        petShopsCollection.add(shop.toMap());
      });
      state = shops; // Update the state
    } else {
      throw Exception('Unable to fetch shop data');
    }
  }

  // Future<void> postPrice(String updatedprice, LocalUser currentUser) async {
  //   final firestore = FirebaseFirestore.instance;
  //   CollectionReference petShopsCollection = firestore.collection('petShops');
  //   print(' currentUser.user.name:' + currentUser.user.name);
  //   print(' currentUser.id:' + currentUser.id);

  //   QuerySnapshot querySnapshot = await petShopsCollection
  //       .where('legalName', isEqualTo: currentUser.user.name)
  //       .limit(1) // 限制只获取一个匹配的文档
  //       .get();
  //   // print('Query Snapshot: $querySnapshot');

  //   if (querySnapshot.docs.isNotEmpty) {
  //     String shopId = querySnapshot.docs.first.id;
  //     print(shopId);
  //     print(updatedprice);
  //     try {
  //       await petShopsCollection.doc(shopId).update({'price': updatedprice});
  //       print('Price updated successfully in PostPrice');
  //     } catch (e) {
  //       print('Error updating price: $e');
  //     }
  //   } else {
  //     print('No matching document found');
  //   }
  // }
 
}

final shopsProvider = StateNotifierProvider<ShopsNotifier, List<petShop>>(
    (ref) => ShopsNotifier());
