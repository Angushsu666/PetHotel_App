import 'package:flutter/material.dart';
import '../models/petshop.dart';
import 'package:intl/intl.dart';
import 'selectRoomPayment.dart';
class SelectRoomInfoPage extends StatefulWidget {
  final petShop shop;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final int numberOfNights;
  final int totalPrice;
  final String roomType; // 添加这行来接收房型信息

  SelectRoomInfoPage({
    required this.shop,
    this.checkInDate,
    this.checkOutDate,
    required this.numberOfNights,
    required this.totalPrice,
    required this.roomType, // 接收房型信息
  });

  @override
  _SelectRoomInfoPageState createState() => _SelectRoomInfoPageState();
}

class _SelectRoomInfoPageState extends State<SelectRoomInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '客房資訊',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //店家資訊
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.shop.legalName, // 商家名称
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '地址: ${widget.shop.legalAddress}', // 商家地址
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text('房型：${widget.roomType}'),
              ],
            ),
          ),
          //分割線
          Center(
            child: Container(
              width: 360, // 要再根據螢幕大小去改。
              height: 1,
              color: const Color.fromARGB(255, 29, 29, 29),
            ),
          ),
          //日期
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.checkInDate != null && widget.checkOutDate != null)
                  Text(
                    '入住日期: ${DateFormat('MM月dd日 EEEE', 'zh_CN').format(widget.checkInDate!)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
          backgroundColor: Color.fromRGBO(255, 239, 239, 1.0),
                    ),
                  ),
                Container(
                  width: 1, // 分割线
                  height: 16,
                  color: Colors.grey,
                ),
                if (widget.checkInDate != null && widget.checkOutDate != null)
                  Text(
                    '退房日期: ${DateFormat('MM月dd日 EEEE', 'zh_CN').format(widget.checkOutDate!)}',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
          backgroundColor: Color.fromRGBO(255, 239, 239, 1.0),
                    ),
                  ),
              ],
            ),
          ),
          //分割線
          Center(
            child: Container(
              width: 360, // 要再根據螢幕大小去改。
              height: 1,
              color: const Color.fromARGB(255, 29, 29, 29),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('寵物類型:'),
                //從搜尋傳下來
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '費用：${widget.totalPrice.toStringAsFixed(0)} TWD', // 显示费用
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // 处理下一步按钮点击事件
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SelectRoomPaymentPage(
                        shop: widget.shop,
                        checkInDate: widget.checkInDate,
                        checkOutDate: widget.checkOutDate,
                        numberOfNights: widget.numberOfNights,
                        totalPrice: widget.totalPrice,
                        roomType: widget.roomType,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // 蓝色背景
                ),
                child: Text(
                  '下一步',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
