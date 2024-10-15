import 'package:flutter/material.dart';
import '../../models/petshop.dart';
import 'package:intl/intl.dart';
import 'selectGroomingPayment.dart';

class SelectGroomingInfoPage extends StatefulWidget {
  final petShop shop;
  final DateTime? checkInDate;
  final DateTime? checkOutDate;
  final int numberOfNights;
  final int totalPrice;
  final String serviceType; // 添加这行来接收美容信息
  final String petType;
  const SelectGroomingInfoPage({super.key, 
    required this.shop,
    this.checkInDate,
    this.checkOutDate,
    required this.numberOfNights,
    required this.totalPrice,
    required this.serviceType, // 接收美容信息
    required this.petType,
  });

  @override
  _SelectGroomingInfoPageState createState() => _SelectGroomingInfoPageState();
}

class _SelectGroomingInfoPageState extends State<SelectGroomingInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '美容資訊',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
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
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '地址：${widget.shop.legalAddress}', // 商家地址
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text('美容服務：${widget.serviceType}'),
                const SizedBox(height: 8),
                Text('寵物類型：${widget.petType}'),
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
            child: Center(
              child: Container(
                child: Text(
                  '美容日期: ${DateFormat('MM月dd日 EEEE', 'zh_CN').format(widget.checkInDate!)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    backgroundColor: Color.fromRGBO(255, 239, 239, 1.0),
                  ),
                ),
                // Container(
                // width: 16, // 分割线
                // height: 1,
                // color: Colors.grey,
                // ),
                // if (widget.checkInDate != null && widget.checkOutDate != null)
                // Text(
                // '退房日期: ${DateFormat('MM月dd日 EEEE', 'zh_CN').format(widget.checkOutDate!)}',
                // style: TextStyle(
                // fontWeight: FontWeight.w600,
                // backgroundColor: Color.fromRGBO(255, 239, 239, 1.0),
                // ),
                // ),
              ),
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
          //這邊可以彈性增加，放一些服務資訊。
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //可以放一些服務資訊
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '費用：${widget.totalPrice.toStringAsFixed(0)} TWD', // 显示费用
                style: const TextStyle(
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
                        checkOutDate: widget.checkInDate,
                        numberOfNights: widget.numberOfNights,
                        totalPrice: widget.totalPrice,
                        serviceType: widget.serviceType,
                        petType: widget.petType,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // 蓝色背景
                ),
                child: const Text(
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
