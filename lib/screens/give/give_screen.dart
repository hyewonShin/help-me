import 'dart:io';

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
  List<dynamic> _userData = [];
  List<dynamic> _askData = [];

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
        _userData = userData;
        _askData = askData;
      });
    } catch (e) {
      print('error: $e');
    }
  }

  void submitGiveData(newData) {
    final user = _userData.firstWhere(
        (userItem) => userItem['user_id'] == newData['user_id'],
        orElse: () => null);

    final sellerAsk = _askData
        .where(
          (askItem) => askItem['user_id'] == newData['user_id'],
        )
        .length;

    final trimData = {
      ...newData,
      'seller_name': user['name'],
      'seller_give': user['give'].length,
      'seller_ask': sellerAsk
    };
    setState(() {
      _giveData.add(trimData);
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
                                    child:
                                        item["image"].substring(0, 5) == "https"
                                            ? Image.network(item['image'],
                                                width: 111,
                                                height: 113,
                                                fit: BoxFit.cover)
                                            : Image.file(File(item['image']),
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
                return GiveSubmit(submitGiveData: submitGiveData);
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
