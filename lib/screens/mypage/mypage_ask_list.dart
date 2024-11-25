import 'package:flutter/material.dart';
import 'package:help_me/constant/colors.dart';
import 'package:help_me/screens/mypage/data_service.dart';
import 'mypage_ask_list.dart';
import 'models.dart';

class MypageAskList extends StatefulWidget {
  //List<Ask> userAskList : 로그인 유저의 asklist
  //decrementAskCount() : ask 삭제시 상태 변경 함수
  final List<Ask> askLists; // askLists를 final로 정의
  final Function decrementAskCount; // decrementAskCount를 final로 정의
  final int userLoginId; // userLoginId 받아오기

  // 명명된 매개변수로 생성자 정의
  const MypageAskList(
      {super.key,
      required this.askLists,
      required this.decrementAskCount,
      required this.userLoginId});

  @override
  State<MypageAskList> createState() => _MypageAskListState();
}

class _MypageAskListState extends State<MypageAskList> {
  DataService dataService = DataService();
  List<Map> askCartList = [];

  @override
  void initState() {
    super.initState();
    loadData(); // 데이터 로드
  }

  Future<void> loadData() async {
    try {
      final asks = await dataService.loadAsks();
      final users = await dataService.loadUsers();

      setState(() {
        askCartList =
            dataService.createAskCartList(asks, users, widget.userLoginId);
      });
    } catch (e) {
      print('데이터 로드 에러: $e');
    }
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
              itemCount: askCartList.length, //data 길이만큼 리스트 뷰 생성
              itemBuilder: (BuildContext context, int index) {
                return buildContainerList(index);
              }),
        ),
      ),
    );
  }

  Container buildContainerList(int index) {
    //index를 파라미터로 받아 Container를 생성하는 함수
    Map ask = askCartList[index];
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
        children: [
          Text(ask["title"]),
          Text(ask["username"]),
          Text(ask["askId"].toString()),
          Text(ask["price"].toString()),
        ],
      ),
    );
  }
}
