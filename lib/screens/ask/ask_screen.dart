import 'package:flutter/material.dart';
import 'package:help_me/constant/colors.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:help_me/screens/ask/ask_submit.dart';

String wonCurrency(int price) {
  return "${price.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (match) => '${match[1]},',
      )} 원";
}

class AskScreen extends StatefulWidget {
  const AskScreen({super.key});

  @override
  State<AskScreen> createState() => _AskScreenState();
}

class _AskScreenState extends State<AskScreen> {
  String askJsonUrl = "lib/mock_data/ask.json";
  List<dynamic> _askData = [];

  String? title;
  String? user_id; //TODO: 사용자 이름으로 변경해야 할 것 같습니다.
  int? price;

  @override
  void initState() {
    super.initState();
    _loadData(askJsonUrl);
  }

  Future<void> _loadData(url) async {
    try {
      final String response = await rootBundle.loadString(url);
      final data = json.decode(response);
      setState(() {
        _askData = data;
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
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 17),
              child: SizedBox(
                width: double.infinity,
                //height: 20,
                child: Text(
                  '재능요청',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: _askData.length,
                  itemBuilder: (context, index) {
                    final item = _askData[index];
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      width: 362,
                      height: 110,
                      decoration: BoxDecoration(
                          border: index == _askData.length - 1
                              ? null
                              : Border(
                                  bottom: BorderSide(
                                      color: AppColors.lightGray, width: 1))),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['title'],
                                style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.black,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 2),
                            Text(item['user_id'].toString(),
                                style: TextStyle(
                                    fontSize: 14, color: AppColors.darkGray)),
                            SizedBox(height: 2),
                            Text("사례금 ${wonCurrency(item['price'])}",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: AppColors.darkGreen,
                                    fontWeight: FontWeight.bold))
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ]),
        ),
        floatingActionButton: SizedBox(
          width: 99,
          height: 47,
          child: FloatingActionButton(
            heroTag: "2",
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AskSubmit();
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
