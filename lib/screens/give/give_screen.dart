import 'package:flutter/material.dart';
import 'package:help_me/constant/colors.dart';
import 'package:help_me/screens/give/give_detail.dart';
import 'package:help_me/screens/give/give_submit.dart';
import 'package:help_me/util/load_data_from_document.dart';
import 'package:intl/intl.dart';

class GiveScreen extends StatefulWidget {
  const GiveScreen({super.key});

  @override
  State<GiveScreen> createState() => _GiveScreenState();
}

class _GiveScreenState extends State<GiveScreen> {
  final USER_ID = 0; //현재 로그인한 사용자의 user_id 임의로 지정해둠
  final comma = NumberFormat("#,###,###원");
  List<dynamic> _giveData = [];

  // give_submit 페이지에서 등록하는 데이터
  String? image;
  String? title;
  String? desc;
  int? price;

  @override
  void initState() {
    super.initState();
    _loadCombineData();
  }

  Future<void> _loadCombineData() async {
    try {
      final giveData = await loadDataFromDocument("give.json");
      final userData = await loadDataFromDocument("users.json");
      final askData = await loadDataFromDocument("ask.json");

      final combinedData = giveData.map((giveItem) {
        final user = userData.firstWhere(
            (userItem) => userItem['user_id'] == giveItem['user_id'],
            orElse: () => null);

        final sellerAsk = askData
            .where(
              (askItem) => askItem['user_id'] == giveItem['user_id'],
            )
            .length;

        return {
          ...giveItem,
          'seller_name': user['name'],
          'seller_give': user['give'].length,
          'seller_ask': sellerAsk
        };
      }).toList();

      setState(() {
        _giveData = combinedData;
      });
    } catch (e) {
      print('error: $e');
    }
  }

  void submitAskData({
    image,
    title,
    price,
    desc,
  }) {
    int lastGiveId = _giveData.last['give_id'];
    setState(() {
      _giveData.add({
        "give_id": lastGiveId += 1, // 재능기부 포스트 고유번호: 추가 시 마다 +1
        "user_id": USER_ID, // 우선 임의로 고정값 넣어줌
        // 진용님 => GiveSubmit에서 해당 함수 사용시 파라미터에 아래 4가지 값만 담아주시면 됩니다
        "image": image,
        "title": title,
        "price": price,
        "desc": desc,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.white,
        body: Padding(
          padding: const EdgeInsets.all(7.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 17),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    '재능기부',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _giveData.length,
                  itemBuilder: (context, index) {
                    final item = _giveData[index];
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return GiveDetail(
                                  image: item['image'],
                                  sellerName: item['seller_name'],
                                  title: item['title'],
                                  desc: item['desc'],
                                  price: item['price'] ?? 0,
                                  sellerGive: item['seller_give'],
                                  sellerAsk: item['seller_ask'],
                                  giveId: item['give_id'],
                                );
                              }),
                            );
                          },
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(item['image'],
                                        width: 111,
                                        height: 113,
                                        fit: BoxFit.cover),
                                  ),
                                  SizedBox(
                                    width: 13,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['title'],
                                        style:
                                            TextStyle(color: AppColors.black),
                                      ),
                                      Text(
                                        item['seller_name'],
                                        style: TextStyle(
                                            color: AppColors.darkGray),
                                      ),
                                      Text(comma.format(item['price']),
                                          style: TextStyle(
                                              color: AppColors.darkGreen,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 1.0,
                          color: AppColors.lightGray,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: SizedBox(
          width: 99,
          height: 47,
          child: FloatingActionButton(
            heroTag: "1",
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return GiveSubmit();
                // return GiveSubmit(submitGiveData: submitGiveData);  // 진용님 => give_submit에서 submitGiveData() 테스트시 사용하시면 됩니다
              }));
            },
            foregroundColor: AppColors.white,
            backgroundColor: AppColors.lightGreen,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            child: Text(
              '+ 글쓰기',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }
}
