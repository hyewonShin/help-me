import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:help_me/constant/colors.dart';
import 'package:help_me/screens/give/give_detail.dart';
import 'package:help_me/screens/give/give_submit.dart';

class GiveScreen extends StatefulWidget {
  const GiveScreen({super.key});

  @override
  State<GiveScreen> createState() => _GiveScreenState();
}

class _GiveScreenState extends State<GiveScreen> {
  final giveJsonUrl = "lib/mock_data/give.json";
  final userJsonUrl = "lib/mock_data/users.json";
  List<dynamic> _giveData = [];
  List<dynamic> _sellerData = [];
  List<dynamic> userGiveList = []; // 내가 담은 재능 리스트

  final USER_ID = 1; //현재 로그인한 사용자의 user_id 임의로 지정해둠

  String? image;
  String? title;
  String? desc;
  int? price;

  @override
  void initState() {
    super.initState();
    _loadData(giveJsonUrl);
  }

  Future<void> _loadData(url) async {
    try {
      final String response = await rootBundle.loadString(url);
      final data = json.decode(response);
      setState(() {
        _giveData = data;
      });
    } catch (e) {
      print('error: $e');
    }
  }

  Future<void> _loadAndFindSellerData(url, sellerId) async {
    try {
      final String response = await rootBundle.loadString(url);
      final data = json.decode(response);

      final filterData =
          data.where((item) => item['user_id'] == sellerId).toList();

      setState(() {
        _sellerData = filterData;
      });
    } catch (e) {
      print('error: $e');
    }
  }

  void submitGiveData({
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

  void cartGiveData(giveId) async {
    final String response = await rootBundle.loadString(userJsonUrl);
    final data = json.decode(response);

    final user = data.where((item) => item['user_id'] == USER_ID).toList();

    List giveList = user[0]['give'];

    setState(() {
      userGiveList = {...userGiveList, ...giveList, giveId}.toList();
    });
    print('userGiveList > $userGiveList');
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
                            _loadAndFindSellerData(
                                userJsonUrl, item['user_id']);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return GiveDetail(
                                    image: item['image'],
                                    sellerId: item['user_id'],
                                    title: item['title'],
                                    desc: item['desc'],
                                    price: item['price'],
                                    sellerGive: _sellerData[0]['give'].length,
                                    sellerAsk: _sellerData[0]['ask'].length,
                                    giveId: item['give_id'],
                                    cartGiveData: cartGiveData);
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
                                        "사용자",
                                        style: TextStyle(
                                            color: AppColors.darkGray),
                                      ),
                                      // Text(
                                      //   item['give_id'].toString(), // test용
                                      //   style: TextStyle(
                                      //       color: AppColors.darkGray),
                                      // ),
                                      Text("1회 ${item['price']}원",
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
