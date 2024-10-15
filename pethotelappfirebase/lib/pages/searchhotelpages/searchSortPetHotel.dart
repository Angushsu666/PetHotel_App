import 'package:flutter/material.dart';
import 'selectR.dart';
import '../../models/petshop.dart';
import 'searchSortPetHotelFilter.dart';

class SortPetHotel extends StatefulWidget {
  final List<petShop> shops;

  const SortPetHotel({super.key, required this.shops});

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

    // 將有"選擇服務"按鈕的店家移到最上面
    sortedShops.sort((a, b) {
      bool aHasButton = a.uid.isNotEmpty;
      bool bHasButton = b.uid.isNotEmpty;
      return aHasButton == bHasButton ? 0 : (aHasButton ? -1 : 1);
    });
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
        return true; // 如果没有选择，则返回所有商店
      }).toList();

      // 將有"選擇服務"按鈕的店家移到最上面
      sortedShops.sort((a, b) {
        bool aHasButton = a.uid.isNotEmpty;
        bool bHasButton = b.uid.isNotEmpty;
        return aHasButton == bHasButton ? 0 : (aHasButton ? -1 : 1);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '寵物旅館搜尋結果',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
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
                  // 將有"選擇服務"按鈕的店家移到最上面
                  sortedShops.sort((a, b) {
                    bool aHasButton = a.uid.isNotEmpty;
                    bool bHasButton = b.uid.isNotEmpty;
                    return aHasButton == bHasButton ? 0 : (aHasButton ? -1 : 1);
                  });
                });
              }
            },
          ),
        ],
      ),
      body: Column(children: [
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
              hint: const Text('選擇地點'), // 提示字眼
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
          ],
        ),
        Expanded(
          child: ListView.separated(
            // 使用 ListView.separated 添加分隔线
            itemCount: sortedShops.length,
            itemBuilder: (context, index) {
              final shop = sortedShops[index];
              String additionalInfo = '';
              Widget? trailingButton;

              if (shop.uid.isNotEmpty) {
                // 处理房型信息，跳过值为0的项
                String roomsInfo = shop.roomCollection.entries
                    .map((entry) {
                      List<String> typeList = entry.value.entries
                          .where((typeEntry) => typeEntry.value > 0) // 过滤掉值为0的项
                          .map((typeEntry) => typeEntry.key)
                          .toList();
                      String typesInfo = typeList.length > 1
                          ? typeList.join('/')
                          : typeList.join('');
                      return typesInfo.isNotEmpty
                          ? '${entry.key} - $typesInfo'
                          : ''; // 如果 typesInfo 为空，则不显示该房型
                    })
                    .where((info) => info.isNotEmpty)
                    .join('\n'); // 过滤掉空字符串

                // 处理食物选择、服务及设施和医疗服务的信息
                String foodChoices = shop.foodChoice.entries
                    .where((entry) => entry.value) // 过滤掉值为 false 的项
                    .map((entry) => entry.key)
                    .join(', ');
                String servicesAndFacilities = shop.serviceAndFacilities.entries
                    .where((entry) => entry.value)
                    .map((entry) => entry.key)
                    .join(', ');
                String medicalServices = shop.medicalNeeds.entries
                    .where((entry) => entry.value)
                    .map((entry) => entry.key)
                    .join(', ');

                // 拼接额外信息
                additionalInfo =
                    roomsInfo.isNotEmpty ? '寵物房型:$roomsInfo\n' : '';
                additionalInfo +=
                    foodChoices.isNotEmpty ? '食物選擇:$foodChoices\n' : '';
                additionalInfo += servicesAndFacilities.isNotEmpty
                    ? '服務及設施: $servicesAndFacilities\n'
                    : '';
                additionalInfo +=
                    medicalServices.isNotEmpty ? '醫療服務: $medicalServices' : '';

                // 创建"选择服务"按钮
                trailingButton = ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectPage(shop: shop)),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 254, 146, 184)),
                  ),
                  child: const Text(
                    '選擇服務',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              return Column(
                children: [
                  ListTile(
                    leading: Container(
                      width: 50, // 设置宽度
                      height: 50, // 设置高度，和宽度一样确保是正方形
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4), // 轻微的圆角效果
                        image: DecorationImage(
                          fit: BoxFit.cover, // 填充方式
                          image: shop.album.isNotEmpty
                              ? NetworkImage(shop.album[0])
                              : const AssetImage('assets/logo3.png')
                                  as ImageProvider, // 如果有相册图片则显示，否则显示默认图片
                        ),
                      ),
                    ),
                    title: Text(shop.legalName),
                    subtitle: Text('服務寵物：${shop.animalType}\n電話: ${shop.uid.isNotEmpty ? shop.uid : "無"} \n$additionalInfo'),
                    trailing: trailingButton,
                  ),
                  const Divider(color: Colors.grey), // 添加分隔线
                ],
              );
            },
            separatorBuilder: (context, index) => const SizedBox(), // 添加分隔线
          ),
        ),
      ]),
    );
  }

  Widget buildDropdownButton(String labelText, List<String> options,
      void Function(String?) onChanged) {
    return DropdownButton<String>(
      value: labelText == '寵物種類' ? selectedAnimalType : selectedLocation,
      hint: Text(labelText), // 提示字眼
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
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
            const Color.fromARGB(255, 254, 146, 184)),
      ),
      onPressed: () {
        sortShops();
      },
      child: Text(
        category,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
