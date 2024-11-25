import 'package:flutter/material.dart';
import 'package:help_me/constant/colors.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

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
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                      return SizedBox(
                        width: 320,
                        height: 110,
                        child: ListTile(
                          title: Text(item['title'],
                              style: TextStyle(
                                  fontSize: 16, color: AppColors.black)),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['user_id'].toString(),
                                  style: TextStyle(
                                    fontSize: 14,
                                  )),
                              Text("사례금 ${wonCurrency(item['price'])}",
                                  style: TextStyle(
                                      color: AppColors.darkGreen,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ])));
  }
}
