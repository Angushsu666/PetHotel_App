import 'package:flutter/material.dart';
import '../../models/petshop.dart';
import 'package:intl/intl.dart';
import 'selectGroomingInfo.dart';

class SelectGroomingPage extends StatefulWidget {
  final petShop shop;

  const SelectGroomingPage({super.key, required this.shop});

  @override
  _SelectGroomingPageState createState() => _SelectGroomingPageState();
}

class _SelectGroomingPageState extends State<SelectGroomingPage> {
  DateTime? checkInDate;
  int numberOfNights = 1; // Fixed to one day
  int totalPrice = 0;
  Map<String, int> selectedGroomingPrices = {};
  String? selectedPetType;

  // Select a single date instead of a range
  Future<DateTime?> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: const Color.fromRGBO(255, 239, 239, 1.0),
            colorScheme: const ColorScheme.light(
              primary: Color.fromARGB(255, 188, 156, 192),
              onPrimary: Colors.white,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    return picked;
  }

  void _selectRoomPrice(String GroomingType, int price) {
    setState(() {
      selectedGroomingPrices[GroomingType] = price;
      checkInDate = null;
      totalPrice = 0;
    });
  }

  Future<void> _selectDateAndCalculateTotal(String GroomingType) async {
    final DateTime? selectedDate = await _selectDate();
    if (selectedDate != null) {
      setState(() {
        checkInDate = selectedDate;
        // Assuming the price is calculated per day
        totalPrice = selectedGroomingPrices[GroomingType]!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('widget.shop.petGrooming:${widget.shop.petGrooming}');
    return Scaffold(
      appBar: AppBar(
        title: const Text('選擇美容服務'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.shop.petGrooming.length,
        itemBuilder: (context, index) {
          final serviceType = widget.shop.petGrooming.keys.elementAt(index);
          final petTypes = widget.shop.petGrooming[serviceType]!;
          return Container(
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 204, 204, 204),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListTile(
              title: Text(serviceType),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                  if (selectedGroomingPrices.containsKey(serviceType))
                    Column(
                      children: [
                        if (selectedPetType != null)
                          TextButton(
                            onPressed: () => _selectDateAndCalculateTotal(serviceType),
                            child: Text(
                              checkInDate == null ? '選擇日期' : '更改日期',
                              style: const TextStyle(color: Color.fromARGB(255, 255, 121, 121)),
                            ),
                          ),
                        if (checkInDate != null)
                          Text(
                            '服務日期: ${DateFormat('yyyy-MM-dd').format(checkInDate!)}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        if (totalPrice > 0)
                          Text('總價錢: \$$totalPrice', style: const TextStyle(fontSize: 18, color: Colors.black)),
                      ],
                    ),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedPetType != null && checkInDate != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SelectGroomingInfoPage(
                              shop: widget.shop,
                              serviceType: serviceType,
                              petType: selectedPetType!,
                              checkInDate: checkInDate!,
                              checkOutDate: checkInDate!, // Same day since it's a single day service
                              numberOfNights: numberOfNights,
                              totalPrice: totalPrice,
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('請先選擇美容服務、寵物類型和日期')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: const Text('確認選擇', style: TextStyle(color: Colors.white)),
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
