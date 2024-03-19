import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/message_provider.dart';
import '../models/Message.dart';
import 'messageBox.dart';

final messageProvider = Provider((ref) => MessageProvider());

class MessagesListPage extends ConsumerWidget {
  final String currentUserName;

  MessagesListPage({required this.currentUserName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('訊息'),
        backgroundColor: Color.fromARGB(255, 226, 160, 182),
      ),
      body: Consumer(
        builder: (context, ref, _) {
          final messagesStream = ref.watch(messageProvider).getUserMessages(currentUserName);

          return StreamBuilder<List<Message>>(
            stream: messagesStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No messages"));
              }

              // 分组并找到每组的最新消息
              var latestMessages = _getLatestMessagesByShop(snapshot.data!);

              return ListView.separated(
                itemCount: latestMessages.length,
                itemBuilder: (context, index) {
                  var entry = latestMessages.entries.elementAt(index);
                  Message latestMessage = entry.value;

                  // 根据消息的发送者和接收者调整UI
                  bool isCurrentUserSender = latestMessage.senderName == currentUserName;
                  String displayTitle = isCurrentUserSender ? latestMessage.receiverLegalName : latestMessage.senderName;

                  return ListTile(
                    title: Text(displayTitle), // 显示对方的名称
                    subtitle: Text(latestMessage.messageContent),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessageBox(
                            currentUserId: currentUserName,
                            shopName: isCurrentUserSender ? latestMessage.receiverLegalName : latestMessage.senderName, // 根据当前用户角色调整shopName
                          ),
                        ),
                      );
                    },
                  );
                },
                separatorBuilder: (context, index) => Divider(color: Colors.grey[300]), // 添加分隔线
              );
            },
          );
        },
      ),
    );
  }

  Map<String, Message> _getLatestMessagesByShop(List<Message> messages) {
    Map<String, Message> latestMessages = {};

    for (var message in messages) {
      // 选择显示逻辑：若当前用户为发送者，则key为接收者；若当前用户为接收者，则key为发送者
      String key = message.senderName == currentUserName ? message.receiverLegalName : message.senderName;

      var existingMessage = latestMessages[key];
      if (existingMessage == null || existingMessage.timestamp.isBefore(message.timestamp)) {
        latestMessages[key] = message;
      }
    }

    return latestMessages;
  }
}
