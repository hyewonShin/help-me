import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:help_me/constant/colors.dart';
import 'package:help_me/screens/give/give_submit.dart';

class GiveScreen extends StatefulWidget {
  const GiveScreen({super.key});

  @override
  State<GiveScreen> createState() => _GiveScreenState();
}

class _GiveScreenState extends State<GiveScreen> {
  String giveJsonUrl = "lib/mock_data/give.json";
  List<dynamic> _data = [];

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
        _data = data;
      });
    } catch (e) {
      print('error: $e');
    }
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
                  itemCount: _data.length,
                  itemBuilder: (context, index) {
                    final item = _data[index];
                    return Column(
                      children: [
                        ListTile(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title'],
                                      style: TextStyle(color: AppColors.black),
                                    ),
                                    Text(
                                      "사용자",
                                      style:
                                          TextStyle(color: AppColors.darkGray),
                                    ),
                                    Text("1회 ${item['price']}원",
                                        style: TextStyle(
                                            color: AppColors.lightGreen,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: 1.0, // 구분선 두께
                          color: AppColors.lightGray, // 구분선 색상
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
