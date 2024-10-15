import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/Order.dart' as model; // 給 Order 模型添加前綴 'model'

final orderProvider = StreamProvider<List<model.Order>>((ref) {
  return FirebaseFirestore.instance.collection('orders').snapshots().map(
    (snapshot) {
      return snapshot.docs.map((doc) {
        // 確保這裡使用 'model.Order'
        return model.Order.fromMap(doc.data());
      }).toList();
    },
  );
});
