import 'package:flutter/material.dart';
// import '../pages/selectPage.dart';
import '../models/petshop.dart';

class SortPetHotel extends StatefulWidget {
  final List<petShop> shops;

  SortPetHotel({required this.shops});

  @override
  _SortPetHotelState createState() => _SortPetHotelState();
}

class _SortPetHotelState extends State<SortPetHotel> {
  List<petShop> sortedShops = [];
  String selectedCategory = '寵物種類';
  String? selectedAnimalType;
  String? selectedLocation;

  // Map<String, String> locationMap = {
  //   'A090': '桃園市',
  //   'A020': '新北市',
  //   // 其他地點的映射
  // };
  @override
  void initState() {
    super.initState();
    sortedShops = List.from(widget.shops);
  }

  void sortShops() {
    // print('selectedCategory: $selectedCategory');
    // print('selectedAnimalType: $selectedAnimalType');
    // print('selectedLocation: $selectedLocation');

    setState(() {
      sortedShops = widget.shops.where((shop) {
        if (selectedLocation != null && selectedAnimalType != null) {
          return shop.legalType == selectedLocation &&
              shop.animalType == selectedAnimalType;
        } else if (selectedLocation != null) {
          return shop.legalType == selectedLocation;
        } else if (selectedAnimalType != null) {
          return shop.animalType == selectedAnimalType;
        }
        return false;
      }).toList();

      // print('sortedShops: $sortedShops'); // 打印篩選後的商店列表
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '排序後的寵物旅館列表',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 226, 160, 182), // 更改AppBar的背景顏色
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildDropdownButton('寵物種類', ['貓', '狗', '狗、貓'],
                  (value) => setState(() => selectedAnimalType = value)),
              DropdownButton<String>(
                value: selectedLocation,
                onChanged: (value) {
                  setState(() {
                    selectedLocation = value;
                  });
                },
                 items: const [
                  DropdownMenuItem<String>(
                    value: 'A010',
                    child: Text('台北市'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'A020',
                    child: Text('新北市'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'A090',
                    child: Text('桃園市'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'A100',
                    child: Text('新竹市'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'A110',
                    child: Text('新竹縣'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'A130',
                    child: Text('苗栗縣'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'A060',
                    child: Text('台中市'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'A170	',
                    child: Text('彰化縣'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'A150',
                    child: Text('南投縣'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'A030',
                    child: Text('基隆市'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'A180',
                    child: Text('雲林縣'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'A190',
                    child: Text('嘉義市'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'A200',
                    child: Text('嘉義縣'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'A210',
                    child: Text('臺南市'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'A040',
                    child: Text('高雄市'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'A240',
                    child: Text('屏東縣'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'A260',
                    child: Text('宜蘭縣'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'A280',
                    child: Text('花蓮縣'),
                  ),
                  DropdownMenuItem<String>(
                    value: 'A300',
                    child: Text('台東縣'),
                  ),
                ],
              ),
              buildSortButton('確認'), // 新增 "確認" 按鈕

              //buildSortButton('時間'),
            ],
          ),
          Expanded(
            child: ListView.builder(
              itemCount: sortedShops.length,
              itemBuilder: (context, index) {
                final shop = sortedShops[index];
                return ListTile(
                  title: Text(shop.legalName),
                  subtitle: Text(
                      '${shop.busItem} - ${shop.legalType} - ${shop.animalType} - UID:${shop.uid}'),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => SelectPage(shop: shop)),
                      // );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 226, 160, 182)), // 設置背景顏色為藍色
                    ),
                    child: Text(
                      '選擇服務',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDropdownButton(String labelText, List<String> options,
      void Function(String?) onChanged) {
    return DropdownButton<String>(
      value: labelText == '寵物種類' ? selectedAnimalType : selectedLocation,
      onChanged: (value) {
        onChanged(value);
      },
      items: options.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
    );
  }

  Widget buildSortButton(String category) {
    return ElevatedButton(
      onPressed: () {
        sortShops();
      },
      child: Text(category),
    );
  }
}
