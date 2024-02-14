import 'package:flutter/material.dart';
import '../pages/select.dart';
import '../models/petshop.dart';
import 'filterPetHotel.dart';

class SortPetHotel extends StatefulWidget {
  final List<petShop> shops;

  SortPetHotel({required this.shops});

  @override
  _SortPetHotelState createState() => _SortPetHotelState();
}

class _SortPetHotelState extends State<SortPetHotel> {
  List<petShop> sortedShops = [];
  List<petShop> initialShops = []; // 存储最初的 sortedShops

  String selectedCategory = '寵物種類';
  String? selectedAnimalType;
  String? selectedLocation;

  @override
  void initState() {
    super.initState();
    sortedShops = List.from(widget.shops);
    initialShops = List.from(widget.shops); // 存储最初的 sortedShops
  }

  void sortShops() {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '寵物旅館搜尋結果',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(255, 226, 160, 182),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      FilterConditionsPage(sortedShops: initialShops),
                ),
              );

              if (result != null) {
                setState(() {
                  sortedShops = List.from(result);
                });
              }
            },
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 226, 160, 182),
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
                // 将每个房型的可用性转换为字符串，如果为 false 则显示 "无"
                String roomsInfo = shop.roomCollection.entries
                    .map((entry) => '${entry.key}: ${entry.value ? "有" : "无"}')
                    .join(', ');

                // 转换食物选择、服务及设施和医疗服务的 Map 为字符串
                String foodChoices = shop.foodChoice.entries
                     .map((entry) => '${entry.key}: ${entry.value ? "有" : "无"}')
                    .join(', ');
                String servicesAndFacilities = shop.serviceAndFacilities.entries
                     .map((entry) => '${entry.key}: ${entry.value ? "有" : "无"}')
                    .join(', ');
                String medicalServices = shop.medicalNeeds.entries
                     .map((entry) => '${entry.key}: ${entry.value ? "有" : "无"}')
                    .join(', ');

                return ListTile(
                  title: Text(shop.legalName),
                  subtitle: Text(
                      '${shop.busItem}  - ${shop.animalType} '
                      // - ${shop.legalType}
                      //  - UID: ${shop.uid} \n
                      // '寵物房型: $roomsInfo \n '
                      // '食物選擇: $foodChoices  \n '
                      // '服務及設施: $servicesAndFacilities \n '
                      // '醫療服務: $medicalServices /'
                      ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SelectPage(shop: shop)),
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Color.fromARGB(255, 226, 160, 182)), // 设置背景颜色
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
