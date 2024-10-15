import 'package:flutter/material.dart';
import '../../models/petshop.dart';
import 'package:intl/intl.dart';
import 'selectRoomInfo.dart';

//只能提前一個月預訂！！！！！！！！！！
class SelectRoomPage extends StatefulWidget {
  final petShop shop;

  const SelectRoomPage({super.key, 
    required this.shop,
  });

  @override
  _SelectRoomPageState createState() => _SelectRoomPageState();
}

class _SelectRoomPageState extends State<SelectRoomPage> {
  DateTime? checkInDate;
  DateTime? checkOutDate;
  int numberOfNights = 0;
  int totalPrice = 0;
  Map<String, int> selectedRoomPrices = {}; // 用來儲存每個房型選擇的價格
  String? selectedPetType; // 新增一個用來儲存選擇的寵物類型的變量

  //選擇日期
  Future<List<DateTime?>?> _selectDates() async {
    return await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)), // 修改這裡設置為一個月後
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color.fromRGBO(255, 239, 239, 1.0), // 主要颜色

            colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 188, 156, 192), // 選擇器主題色
              onPrimary: Colors.white, // 選擇的日期文字顏色
            ),
            dialogBackgroundColor: Colors.white, // 對話框背景色
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    ).then((picked) {
      if (picked != null) {
        return [picked.start, picked.end];
      }
      return null;
    });
  }

// 這個方法會被選擇房型按鈕觸發，以更新選中的房型價格和重置日期
  void _selectRoomPrice(String roomType, int price) {
    setState(() {
      selectedRoomPrices[roomType] = price;
      checkInDate = null;
      checkOutDate = null;
      totalPrice = 0;
    });
  }

  // 這個方法用於展示日期選擇器並計算總價
  Future<void> _selectDatesAndCalculateTotal(String roomType) async {
    final selectedDates = await _selectDates();
    if (selectedDates != null) {
      setState(() {
        checkInDate = selectedDates[0];
        checkOutDate = selectedDates[1];
        numberOfNights = checkOutDate!.difference(checkInDate!).inDays;
        // 這裏計算選中房型的總價格
        totalPrice = selectedRoomPrices[roomType]! * numberOfNights;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 使用PreferredSize来设置AppBar的高度
        toolbarHeight: kToolbarHeight + 10, // kToolbarHeight是默认的AppBar高度
        title: Column(
          children: [
            const Text(
              '選擇客房', // 主标题
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.shop.legalName, // 商家名称
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ],
        ),

        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // 处理分享按钮点击事件
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.shop.roomCollection.length,
        itemBuilder: (context, index) {
          final serviceType = widget.shop.roomCollection.keys.elementAt(index);
          final petTypes = widget.shop.roomCollection[serviceType]!;
          return Container(
            margin: const EdgeInsets.all(16.0), // 设置外边距为16像素
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 204, 204, 204), // 灰色背景
              borderRadius: BorderRadius.circular(8.0), // 圆角边框
            ),
            child: ListTile(
              title: Text(serviceType), // 房型名称
              subtitle: Column(
                // 使用Column包装日期和价格信息
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 展示每個房型的價格並允許選擇

                  ...petTypes.keys.map((petType) {
                    return RadioListTile<String>(
                      title: Text("$petType: ${petTypes[petType]}元"),
                      value: petType,
                      groupValue: selectedPetType,
                      onChanged: (value) {
                        setState(() {
                          selectedPetType = value;
                          _selectRoomPrice(serviceType, petTypes[value]!);
                        });
                      },
                    );
                  }).toList(),
                  // 如果該房型被選擇，展示日期選擇器
                  if (selectedRoomPrices.containsKey(serviceType))
                    Column(
                      children: [
                        // 日期選擇器按鈕
                        if (selectedPetType != null)
                          TextButton(
                            onPressed: () =>
                                _selectDatesAndCalculateTotal(serviceType),
                            child: Text(
                              checkInDate == null || checkOutDate == null
                                  ? '選擇日期'
                                  : '更改日期',
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 255, 121, 121)),
                            ),
                          ),
                        // 显示选择的日期和计算出的总价
                        if (checkInDate != null && checkOutDate != null)
                          Text(
                            '入住日期: ${DateFormat('yyyy-MM-dd').format(checkInDate!)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        if (checkInDate != null && checkOutDate != null)
                          Text(
                            '退房日期: ${DateFormat('yyyy-MM-dd').format(checkOutDate!)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        if (totalPrice > 0)
                          Text(
                            '總價錢: \$$totalPrice',
                            style: const TextStyle(fontSize: 18, color: Colors.black),
                          ),
                      ],
                    ),
                  // 展示選中房型的總價格
                  // if (selectedRoomPrices.containsKey(roomType))
                  // Text(
                  // '${numberOfNights <= 0 ? "價錢:" : "${numberOfNights}晚總價:"}\$${selectedRoomPrices[roomType]! * numberOfNights}',
                  // style: TextStyle(fontSize: 18, color: Colors.black87),
                  // ),

                  // 確認選擇按鈕，加入了petType的傳遞
                  ElevatedButton(
                    onPressed: () {
                      print('選擇的寵物類型:$selectedPetType');
                      if (selectedPetType != null && // 確認寵物類型已選擇
                          checkInDate != null &&
                          checkOutDate != null) {
                        // 如果已選擇房型、寵物類型和日期，進入房間詳情頁面
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SelectRoomInfoPage(
                              shop: widget.shop,
                              serviceType: serviceType,
                              petType: selectedPetType!, // 傳遞寵物類型
                              checkInDate: checkInDate!,
                              checkOutDate: checkOutDate!,
                              numberOfNights: numberOfNights,
                              totalPrice: totalPrice,
                            ),
                          ),
                        );
                      } else {
                        // 提示用戶完成所有選擇
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('請先選擇房型、寵物類型和日期'),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // 按钮的背景色,
                    ),
                    child: const Text(
                      '確認選擇',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
