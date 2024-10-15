import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/message_provider.dart'; // 引入 MessageProvider
import '../models/Message.dart'; // 引入 Message 模型
import 'package:intl/intl.dart'; // 用于格式化日期
import 'package:cloud_firestore/cloud_firestore.dart';

final messageProvider = Provider((ref) => MessageProvider());

class MessageBox extends ConsumerStatefulWidget {
  final String currentUserId;
  final String shopName;

  const MessageBox({super.key, required this.currentUserId, required this.shopName});

  @override
  _MessageBoxState createState() => _MessageBoxState();
}

class _MessageBoxState extends ConsumerState<MessageBox> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("訊息內當前用戶ID: ${widget.currentUserId}"); // 打印当前用户ID

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.shopName),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer(
              builder: (context, ref, _) {
                final messagesStream = ref
                    .watch(messageProvider)
                    .getMessages(widget.currentUserId, widget.shopName);

                return StreamBuilder<List<Message>>(
                  stream: messagesStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No messages"));
                    } else {
                      // 为了调试，打印出返回的消息
                      for (var msg in snapshot.data!) {
                        print(
                            "Message: ${msg.messageContent}, Sender: ${msg.senderName}, Receiver: ${msg.receiverLegalName}, Time: ${msg.timestamp}");
                      }
                    }

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_scrollController.hasClients) {
                        _scrollController
                            .jumpTo(_scrollController.position.maxScrollExtent);
                      }
                    });

                    // Sort messages by timestamp before displaying them
                    var messages = snapshot.data!;
                    messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        Message message = messages[index];
                        bool isSentByMe =
                            message.senderName == widget.currentUserId;
                        // 检查并转换时间戳
                        DateTime dateTime;
                        if (message.timestamp is Timestamp) {
                          // 如果 timestamp 是 Timestamp 类型，则转换为 DateTime
                          dateTime = (message.timestamp as Timestamp).toDate();
                        } else {
                          // 如果 timestamp 已经是 DateTime 类型，则直接使用
                        dateTime = message.timestamp;
                        }
                      

                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          child: Align(
                            // 使用 isSentByMe 来正确设置对齐方向
                            alignment: isSentByMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 16),
                              decoration: BoxDecoration(
                                color: isSentByMe
                                    ? Colors.blue
                                    : Colors.grey[300], // 发送者使用不同的背景色
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    message.messageContent,
                                    style: TextStyle(
                                        color: isSentByMe
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    DateFormat('yyyy-MM-dd – kk:mm')
                                        .format(dateTime),
                                    style: TextStyle(
                                        color: Colors.grey[600], fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Material(
                    // 使用 Material 组件包裹 TextField
                    elevation: 2.0, // 添加阴影效果
                    borderRadius: BorderRadius.circular(5.0), // 设置边框圆角
                    child: Container(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: '輸入訊息',
                          border: OutlineInputBorder(
                            // 使用 OutlineInputBorder 设置边框样式
                            borderRadius: BorderRadius.circular(5.0), // 设置边框圆角
                            borderSide: BorderSide.none, // 隐藏默认边框
                          ),
                          filled: true, // 启用填充颜色
                          fillColor:
                              const Color.fromRGBO(255, 239, 239, 1.0), // 设置背景色
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0), // 设置内边距
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      ref.read(messageProvider).sendMessage(
                            Message(
                              senderName: widget.currentUserId,
                              receiverLegalName: widget.shopName,
                              messageContent: _messageController.text,
                              timestamp: DateTime.now(),
                            ),
                          );
                      _messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
