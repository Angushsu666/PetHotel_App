import 'dart:convert';

class Message {
  final String senderName; // 发送者的名字，对应 FirebaseUser 中的 name
  final String receiverLegalName; // 接收者的法律名称，对应 petShop 中的 legalName
  final String messageContent; // 消息内容
  final DateTime timestamp; // 发送时间戳

  Message({
    required this.senderName,
    required this.receiverLegalName,
    required this.messageContent,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderName': senderName,
      'receiverLegalName': receiverLegalName,
      'messageContent': messageContent,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderName: map['senderName'],
      receiverLegalName: map['receiverLegalName'],
      messageContent: map['messageContent'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) => Message.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Message(senderName: $senderName, receiverLegalName: $receiverLegalName, messageContent: $messageContent, timestamp: $timestamp)';
  }
}
