import 'package:flutter/material.dart';
import '../models/petshop.dart';

//篩選器頁面

class FilterConditionsPage extends StatefulWidget {
  final List<petShop> sortedShops;

  FilterConditionsPage({required this.sortedShops});

  @override
  _FilterConditionsPageState createState() => _FilterConditionsPageState();
}

class _FilterConditionsPageState extends State<FilterConditionsPage> {
  List<petShop> filteredShops = [];
  bool showAll = true;
  double _currentPrice = 0;
  String _currentPetType = '未选择'; // 初始化为默认值

  // 新增筛选标签的选中状态
  Map<String, bool> roomTypeSelections = {
    '獨立房型': false,
    '開放式住宿': false,
    '半開放式住宿': false,
  };

  Map<String, bool> foodSelections = {
    '鮮食': false,
    '罐頭': false,
    '乾飼料': false,
    '處方飼料': false,
  };

  Map<String, bool> serviceAndFacilitySelections = {
    '24小時監控': false,
    '24小時寵物保姆': false,
    '開放式活動空間': false,
    '游泳池': false,
  };

  Map<String, bool> medicalServiceSelections = {
    '口服藥': false,
    '外傷藥': false,
    '陪伴看診': false,
  };

  @override
  void initState() {
    super.initState();
    filteredShops = List.from(widget.sortedShops);
  }

  // 更新 handlePetTypeSelection 方法以包含新的筛选条件
  void handlePetTypeSelection(String petType) {
    setState(() {
      _currentPetType = petType; // 更新当前宠物类型
      applyFilters();
    });
  }

  // 应用所有筛选条件的方法
  void applyFilters() {
    setState(() {
      filteredShops = widget.sortedShops.where((shop) {
        // 宠物类型筛选
        bool petTypeMatch = _currentPetType == '未选择' ||
            shop.animalType.contains(_currentPetType);

        // 房型筛选
        bool roomTypeMatch = roomTypeSelections.entries.every((entry) =>
            !entry.value ||
            shop.roomCollection.containsKey(entry.key) &&
                shop.roomCollection[entry.key]!);

        // 食物选择筛选
        bool foodMatch = foodSelections.entries.every(
            (entry) => !entry.value || shop.foodChoice[entry.key] == true);

        // 服务及设施筛选
        bool serviceAndFacilityMatch = serviceAndFacilitySelections.entries
            .every((entry) =>
                !entry.value || shop.serviceAndFacilities[entry.key] == true);

        // 医疗服务筛选
        bool medicalServiceMatch = medicalServiceSelections.entries.every(
            (entry) => !entry.value || shop.medicalNeeds[entry.key] == true);

        return petTypeMatch &&
            roomTypeMatch &&
            foodMatch &&
            serviceAndFacilityMatch &&
            medicalServiceMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('篩選條件'),
        leading: IconButton(
          icon: Icon(Icons.cancel),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // 应用所有筛选条件
              applyFilters();

              // 返回筛选结果
              Navigator.pop(context, filteredShops);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildPriceFilter(),
            buildPetTypeFilter(),
            buildFilterSection('寵物房型:', roomTypeSelections),
            buildFilterSection('食物選擇:', foodSelections),
            buildFilterSection('服務及設施:', serviceAndFacilitySelections),
            buildFilterSection('醫療服務:', medicalServiceSelections),
          ],
        ),
      ),
    );
  }

  Widget buildPriceFilter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text('您的預算:'),
          Slider(
            value: _currentPrice,
            min: 0,
            max: 2000, // 價格的最大值，您可以自行更改
            divisions: 20, // Optional: Add divisions for discrete values
            label: '${_currentPrice.toInt()}',
            onChanged: (value) {
              setState(() {
                _currentPrice = value;
              });
            },
          ),
          Text('\$${_currentPrice.toInt()}'), // 显示选择的价格，转换为整数
        ],
      ),
    );
  }

  Widget buildPetTypeFilter() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('寵物類型:'),
          SizedBox(width: 10),
          buildFilterChip(
              '狗', _currentPetType == '狗', () => handlePetTypeSelection('狗')),
          SizedBox(width: 10),
          buildFilterChip(
              '貓', _currentPetType == '貓', () => handlePetTypeSelection('貓')),
          SizedBox(width: 10),
          buildFilterChip('顯示所有', _currentPetType == '未选择',
              () => handlePetTypeSelection('未选择')),
        ],
      ),
    );
  }

  Widget buildFilterSection(String title, Map<String, bool> selections) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title),
          SizedBox(height: 10), // 添加一点垂直间距
          Row(
            crossAxisAlignment: CrossAxisAlignment.start, // 从行的开始处对齐
            children: [
              Expanded(
                // 使用 Expanded 包裹以填满行的宽度
                child: Wrap(
                  spacing: 8.0, // 水平间距
                  runSpacing: 4.0, // 垂直间距
                  children: selections.keys
                      .map((key) => buildFilterChip(key, selections[key]!, () {
                            setState(() {
                              selections[key] = !selections[key]!;
                              applyFilters();
                            });
                          }))
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildFilterChip(
      String label, bool isSelected, VoidCallback onSelected) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) => onSelected(),
    );
  }
}
