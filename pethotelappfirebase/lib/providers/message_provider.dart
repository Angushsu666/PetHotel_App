import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/Message.dart'; // 假设您已经定义了 Message 类
import 'package:rxdart/rxdart.dart';

class MessageProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 发送消息的方法
  Future<void> sendMessage(Message message) async {
    await _firestore.collection('messages').add(message.toMap());
  }

// 修改获取消息列表的 Stream，使其同时查询当前用户作为发送者和接收者的消息
  Stream<List<Message>> getMessages(String currentUserId, String shopName) {
    // 查询当前用户作为发送者的消息
    var sentMessages = _firestore
        .collection('messages')
        .where('senderName', isEqualTo: currentUserId)
        .where('receiverLegalName', isEqualTo: shopName)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Message.fromMap(doc.data() as Map<String, dynamic>))
            .toList());

    // 查询当前用户作为接收者的消息
    var receivedMessages = _firestore
        .collection('messages')
        .where('receiverLegalName', isEqualTo: currentUserId)
        .where('senderName', isEqualTo: shopName)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Message.fromMap(doc.data() as Map<String, dynamic>))
            .toList());

    // 合并两个流并去重
    return Rx.combineLatest2<List<Message>, List<Message>, List<Message>>(
        sentMessages, receivedMessages, (sent, received) {
      var allMessages = {...sent, ...received};
      return allMessages.toList();
    });
  }

  // // 获取与当前用户相关的所有消息的 Stream
  // Stream<List<Message>> getUserMessages(String senderId) {
  //   return _firestore
  //       .collection('messages')
  //       .where('senderName', isEqualTo: senderId)
  //       .snapshots()
  //       .map((snapshot) => snapshot.docs
  //           .map((doc) => Message.fromMap(doc.data() as Map<String, dynamic>))
  //           .toList());
  // }

  // 获取与当前用户相关的消息
  Stream<List<Message>> getUserMessages(String currentUserName) {
    // 获取当前用户作为发送者的消息
    var sentMessages = _firestore
        .collection('messages')
        .where('senderName', isEqualTo: currentUserName)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Message.fromMap(doc.data() as Map<String, dynamic>))
            .toList());

    // 获取当前用户作为接收者的消息
    var receivedMessages = _firestore
        .collection('messages')
        .where('receiverLegalName', isEqualTo: currentUserName)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Message.fromMap(doc.data() as Map<String, dynamic>))
            .toList());

    // 不使用集合来合并流
    return Rx.combineLatest2<List<Message>, List<Message>, List<Message>>(
        sentMessages, receivedMessages, (sent, received) {
      // 连接列表并按时间戳排序
      var allMessages = [...sent, ...received];
      allMessages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      return allMessages;
    });
  }

  Stream<List<Message>> getShopMessages(String shopName) {
    return _firestore
        .collection('messages')
        .where('receiverLegalName', isEqualTo: shopName)
        .orderBy('timestamp', descending: true) // 根据时间戳降序排列
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Message.fromMap(doc.data() as Map<String, dynamic>))
            .toList());
  }
}
