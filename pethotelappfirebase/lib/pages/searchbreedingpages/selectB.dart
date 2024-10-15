import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // 用于格式化日期
import '../../models/petshop.dart';
import '../messageBox.dart'; // 注意这里导入 MessagePage 的路径
import '../../providers/user_provider.dart'; // 引入 userProvider
import '../../providers/shop_provider.dart';

class SelectBPage extends ConsumerStatefulWidget {
  final petShop shop; // 接收商店物件

  const SelectBPage({super.key, required this.shop});

  @override
  _SelectBPageState createState() => _SelectBPageState();
}

class _SelectBPageState extends ConsumerState<SelectBPage> {
  String selectedContent = '介紹'; // 预设选择介绍内容

  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  final Map<String, TextEditingController> _replyControllers = {};

  double _currentRating = 0;

  @override
  void dispose() {
    // 遍历 _replyControllers 映射，并对每个控制器调用 dispose 方法
    for (var controller in _replyControllers.values) {
      controller.dispose();
    }

    // 如果有其他需要手动释放的资源，也在这里处理
    _commentController.dispose();

    // 调用 super.dispose() 来完成 dispose 流程
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LocalUser currentUser = ref.watch(userProvider);
    double averageRating = calculateAverageRating(widget.shop.reviews);
    String starsDisplay = generateStars(averageRating);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.shop.legalName, // 顯示商家名稱
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // 讓標題自動居中
        leading: IconButton(
          //ios5
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.favorite), // 愛心圖示
            onPressed: () {
              // 在這裡處理分享按鈕的點擊事件
            },
          ),
          IconButton(
            icon: const Icon(Icons.share), // 分享圖示
            onPressed: () {
              // 在這裡處理分享按鈕的點擊事件
              //ex line, facebook, instagram
            },
          ),
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: () {
              // 导航到 MessagePage，并传递当前用户ID和商家ID
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessageBox(
                    currentUserId:
                        currentUser.user.name, // 使用当前用户的 name 作为 senderId
                    shopName: widget.shop.legalName, // 商家名稱
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //照片
            SizedBox(
              height: 200, // Adjust the height as needed
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.shop.album
                    .length, // This counts the number of images in the album
                itemBuilder: (context, index) {
                  return Container(
                    width: 200, // Adjust the width as needed
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black12, // This is just a placeholder color
                      image: DecorationImage(
                        image: NetworkImage(widget
                            .shop.album[index]), // Load image from the album
                        fit: BoxFit
                            .cover, // This ensures the image covers the full container
                      ),
                    ),
                  );
                },
              ),
            ),

            //店家文字資訊
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.shop.legalName,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '評分: ${averageRating.toStringAsFixed(1)} $starsDisplay',
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            //店家的資訊
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: buildContentButton(
                      '介紹', selectedContent == '介紹', Colors.black),
                ),
                // Expanded(
                // child: buildContentButton(
                // '服務', selectedContent == '服務', Colors.grey),
                // ),
                Expanded(
                  child: buildContentButton(
                      '評論', selectedContent == '評論', Colors.grey),
                ),
              ],
            ),
            if (selectedContent == '介紹')
              buildIntroductionContent(widget.shop.introduction), // 顯示介紹內容
            // if (selectedContent == '服務')
            //   buildServiceContent(widget.shop.serviceIntroduction), // 顯示服務內容
            if (selectedContent == '評論')
              buildReviewContent(widget.shop.reviews), // 顯示用戶評論內容
          ],
        ),
      ),
    );
  }

  Widget buildContentButton(
      String title, bool isSelected, Color indicatorColor) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedContent = title; // 切換選擇的內容
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? const Color.fromRGBO(255, 239, 239, 1.0)
            : Colors.black12, // 设置按钮的背景颜色
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }

  Widget buildIntroductionContent(String? introduction) {
    // Check if the introduction is null or empty
    if (introduction == null || introduction.isEmpty) {
      // If true, display a placeholder message
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          "店家尚未添加介紹，請稍等~",
          style: TextStyle(
              fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey),
        ),
      );
    } else {
      // If not, display the actual introduction content
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          introduction,
          style: const TextStyle(fontSize: 16),
        ),
      );
    }
  }

  Widget buildServiceContent(List<String> services) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: services.map((service) => Text(service)).toList(),
      ),
    );
  }

  Widget buildReviewContent(List<Review> reviews) {
    print("目前評論数量: ${reviews.length}");
    for (var review in reviews) {
      print(
          "作者: ${review.author}, 内容: ${review.content}, 评分: ${review.rating}");
    }
    // 遍历评论列表，并打印 shopResponse 数据
    for (var review in reviews) {
      print("Review by ${review.author}: ${review.content}");
      if (review.shopResponse != null) {
        print(
            "Shop Response: ${review.shopResponse!.content} at ${review.shopResponse!.responseTimestamp}");
      } else {
        print("No shop response.");
      }
    }

    final currentUser = ref.watch(userProvider);
    //商家才可以回覆判斷：使用者電話跟商家手動設定的uid相同
    final canReply = currentUser.user.isShopOwner &&
        currentUser.user.phone == widget.shop.uid;

    print('判斷canReply:');
    print(canReply);
    return Column(
      children: [
        // 评论提交区域
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: '留下您的評論',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      Icons.star,
                      color:
                          _currentRating > index ? Colors.amber : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _currentRating = index + 1;
                      });
                    },
                  );
                }),
              ),
              ElevatedButton(
                onPressed: () {
                  submitReview(_commentController.text, _currentRating);
                },
                child: const Text('提交評論'),
              ),
            ],
          ),
        ),
        ...reviews.map((review) {
          // 为每条评论创建一个新的TextEditingController，并存储到映射中
          String reviewKey = review.reviewTimestamp.toIso8601String();
          _replyControllers[reviewKey] = TextEditingController();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                title: Text(
                  '用戶名稱：${review.author}',
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '評價內容：${review.content}',
                  style: const TextStyle(
                    color: Colors.black45,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: Column(
                  mainAxisSize: MainAxisSize.min, // 让Column占用尽可能小的空间
                  children: [
                    Text(
                      DateFormat('yyyy-MM-dd').format(review.reviewTimestamp),
                      style: const TextStyle(
                          fontSize: 14, color: Colors.black), // 调整日期文字的样式
                    ),
                    Text(
                      '${review.rating} 星',
                      style: const TextStyle(
                        color: Colors.black45,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (review.shopResponse != null)
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        const WidgetSpan(
                          child: Icon(Icons.arrow_right,
                              size: 30, color: Colors.black), // 添加向右的箭头图标
                          alignment: PlaceholderAlignment.middle, // 调整图标的垂直对齐
                        ),
                        const WidgetSpan(
                          child: SizedBox(width: 4), // 在图标和文本之间添加一些间隔
                        ),
                        TextSpan(
                          text: '${widget.shop.legalName}: ',
                          style: const TextStyle(
                            color: Colors.black45,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const WidgetSpan(
                          child: SizedBox(width: 2), // 在商家名称和回复内容之间添加一些间隔
                        ),
                        TextSpan(
                          text: '${review.shopResponse!.content} ',
                          style: const TextStyle(fontSize: 16, color: Colors.black),
                        ),
                        const WidgetSpan(
                          child: SizedBox(width: 8), // 在回复内容和日期之间添加更多间隔
                        ),
                        TextSpan(
                          text:
                              '(${DateFormat('yyyy-MM-dd').format(review.shopResponse!.responseTimestamp)})',
                          style: const TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
              // 只有当允许回复且评论没有商家回复时才显示回复输入框
              if (canReply && review.shopResponse == null)
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                  child: TextField(
                    controller: _replyControllers[reviewKey], // 使用对应的控制器
                    decoration: InputDecoration(
                      hintText: '回覆此評論',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () {
                          // 获取当前评论对应的控制器中的文本
                          String replyText = _replyControllers[reviewKey]!.text;
                          if (replyText.isNotEmpty) {
                            // 调用添加商家回复的方法
                            ref.read(shopsProvider.notifier).addShopResponse(
                                currentUser, reviewKey, replyText);

                            // 清空当前评论的回复输入框
                            _replyControllers[reviewKey]!.clear();
                          }
                        },
                      ),
                    ),
                  ),
                ),
              const Divider(
                color: Colors.grey,
                thickness: 1,
                height: 20,
              ),
            ],
          );
        }).toList(),
      ],
    );
  }

  void submitReview(String content, double rating) {
    final currentUser = ref.read(userProvider);
    final newReview = Review(
      author: currentUser.user.name,
      content: content,
      rating: rating,
      reviewTimestamp: DateTime.now(),
      shopResponse: null,
    );
    print('widget.shop.id:${widget.shop.id}');
    ref.read(shopsProvider.notifier).addReview(widget.shop.id, newReview);

    setState(() {
      _commentController.clear();
      _currentRating = 0;
    });
  }
}

double calculateAverageRating(List<Review> reviews) {
  if (reviews.isEmpty) {
    return 0.0;
  }
  double sum = reviews.fold(
      0.0, (previousValue, review) => previousValue + review.rating);
  return sum / reviews.length;
}

String generateStars(double averageRating) {
  int fullStars = averageRating.floor();
  double remaining = averageRating - fullStars;
  String stars = '★' * fullStars;
  if (remaining >= 0.5) {
    stars += '⭐'; // 半星用 ⭐ 表示
  }
  stars += '☆' * (5 - stars.length);
  return stars;
}
