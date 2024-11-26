import 'package:flutter/material.dart';
import 'package:help_me/constant/colors.dart';
import 'package:help_me/util/load_data_from_document.dart';
import 'package:help_me/util/save_json_to_file.dart';
import 'package:intl/intl.dart';

class MypageAskList extends StatefulWidget {
  final int userLoginId;

  const MypageAskList({super.key, required this.userLoginId});

  @override
  State<MypageAskList> createState() => _MypageAskListState();
}

class _MypageAskListState extends State<MypageAskList> {
  List<dynamic> userData = [];
  List<dynamic> askData = [];
  String userName = "";

  @override
  void initState() {
    super.initState();
    loadData(); // 데이터 로드
  }

  Future<void> loadData() async {
    try {
      final asks = await loadDataFromDocument("ask.json");
      final users = await loadDataFromDocument("users.json");
      final userNameOfLoginUser = users
          .firstWhere((user) => user["user_id"] == widget.userLoginId)["name"];
      final asksOfLoginUser = asks
          .where((item) => item["user_id"] == widget.userLoginId)
          .toList()
          .map((ask) => ask = {...ask, "name": userNameOfLoginUser})
          .toList();

      setState(() {
        userData = users;
        askData = asksOfLoginUser;
        userName = userNameOfLoginUser;
      });
    } catch (e) {
      print('데이터 로드 에러: $e');
    }
  }

  void addStateAndData() async {
    final newAsk = {
      "ask_id": 11,
      "user_id": 0,
      "title": "바퀴벌레 잡아주세요.",
      "desc": "제발 잡아주세요.",
      "price": 20000
    };
    setState(() {
      askData.add({...newAsk, "name": userName});
    });

    writeDataToFile(newAsk, "ask.json");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내가 요청한 재능'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          height: 650,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: ListView.builder(
              itemCount: askData.length, //data 길이만큼 리스트 뷰 생성
              itemBuilder: (BuildContext context, int index) {
                return buildContainerList(index);
              }),
        ),
      ),
    );
  }

  Container buildContainerList(int index) {
    final comma = NumberFormat("#,###,###원");
    //index를 파라미터로 받아 Container를 생성하는 함수
    Map ask = askData[index];
    return Container(
      height: 110,
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(
          // 밑변에 선 추가
          color: AppColors.lightGray,
          width: 1, // 선의 두께
        ),
      )),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                ask["title"],
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              Text(ask["name"],
                  style: TextStyle(fontSize: 16.0, color: AppColors.darkGray)),
              Text("사례금 ${comma.format(ask["price"])}",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: AppColors.lightGreen)),
            ],
          ),
          Icon(Icons.close)
        ],
      ),
    );
  }
}
