import 'package:flutter/material.dart';
import '../models/petshop.dart';
import 'package:intl/intl.dart';
import 'selectRoomInfo.dart';

class SelectRoomPage extends StatefulWidget {
  final petShop shop;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final int numberOfNights;
  final double totalPrice;

  SelectRoomPage({
    required this.shop,
    this.checkInDate,
    this.checkOutDate,
    required this.numberOfNights,
    required this.totalPrice,
  });

  @override
  _SelectRoomPageState createState() => _SelectRoomPageState();
}

class _SelectRoomPageState extends State<SelectRoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 使用PreferredSize来设置AppBar的高度
        toolbarHeight: kToolbarHeight + 10, // kToolbarHeight是默认的AppBar高度
        title: Column(
          children: [
            Text(
              '選擇客房', // 主标题
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.shop.legalName, // 商家名称
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),

        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color.fromARGB(255, 77, 73, 74),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // 处理分享按钮点击事件
            },
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 228, 228, 228),
      body: ListView.builder(
        itemCount: widget.shop.roomCollection.length,
        itemBuilder: (context, index) {
          final roomType = widget.shop.roomCollection.keys.toList()[index];
          final roomCount = widget.shop.roomCollection.values.toList()[index];

          return Container(
            margin: EdgeInsets.all(16.0), // 设置外边距为16像素
            decoration: BoxDecoration(
              color: Colors.grey, // 灰色背景
              borderRadius: BorderRadius.circular(8.0), // 圆角边框
            ),
            child: ListTile(
              title: Text(roomType), // 房型名称
              subtitle: Column(
                // 使用Column包装日期和价格信息
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('数量: $roomCount'), // 房间数量
                  if (widget.checkInDate != null && widget.checkOutDate != null)
                    Text(
                      '入住日期: ${DateFormat('MM-dd').format(widget.checkInDate!)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                  if (widget.checkInDate != null && widget.checkOutDate != null)
                    Text(
                      '退房日期: ${DateFormat('MM-dd').format(widget.checkOutDate!)}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                  Text(
                    '${widget.numberOfNights <= 0 ? "1晚價錢" : "${widget.numberOfNights.toStringAsFixed(0)}晚總價:TWD "}${widget.totalPrice.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(0.0), // No margin
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SelectRoomInfoPage(
                              shop: widget.shop,
                              checkInDate: widget.checkInDate,
                              checkOutDate: widget.checkOutDate,
                              numberOfNights: widget.numberOfNights,
                              totalPrice: widget.totalPrice,
                              roomType: roomType, // 将房型传递给 SelectRoomInfoPag
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(
                            color: Colors.blue, width: 2.0), // Blue border
                        backgroundColor:
                            Colors.transparent, // No background color
                      ),
                      child: Center(
                        child: Text(
                          '選擇',
                          style: TextStyle(
                            color: Colors.black, // Text color
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // 点击此项时，可以执行所需的操作
              onTap: () {
                // 处理选定房型的操作
              },
            ),
          );
        },
      ),
    );
  }
}
