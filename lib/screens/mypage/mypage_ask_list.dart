import 'package:flutter/material.dart';
import 'mypage_ask_list.dart';
import 'models.dart';

class MypageAskList extends StatelessWidget {
  //List<Ask> userAskList : 로그인 유저의 asklist
  //decrementAskCount() : ask 삭제시 상태 변경 함수
  final List<Ask> askLists; // askLists를 final로 정의
  final Function decrementAskCount; // decrementAskCount를 final로 정의

  // 명명된 매개변수로 생성자 정의
  const MypageAskList(
      {super.key, required this.askLists, required this.decrementAskCount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('내가 요청한 재능'),
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [Container()],
      ),
    );
  }
}
