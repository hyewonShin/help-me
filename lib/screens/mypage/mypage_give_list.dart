import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class MypageGiveList extends StatefulWidget {
  const MypageGiveList({super.key});

  @override
  State<MypageGiveList> createState() => _MypageGiveListState();
}

class _MypageGiveListState extends State<MypageGiveList> {
  List<Give> giveList = []; // 데이터를 저장할 리스트
  bool isLoading = true; // 로딩 상태를 관리

  void initState() {
    super.initState();
    loadData(); // 데이터 로드
  }

  // JSON 데이터를 로드하고 파싱하는 함수
  Future<void> loadData() async {
    try {
      // JSON 파일 읽기
      final String responseGive =
          await rootBundle.loadString('lib/mock_data/give.json');
      final List<dynamic> dataGive = jsonDecode(responseGive);

      final String responseAsk =
          await rootBundle.loadString('lib/mock_data/ask.json');
      final List<dynamic> dataAsk = jsonDecode(responseAsk);

      final String responseUsers =
          await rootBundle.loadString('lib/mock_data/users.json');
      final List<dynamic> dataUsers = jsonDecode(responseUsers);

      // 데이터를 Give 객체 리스트로 변환
      setState(() {
        giveList = dataGive.map((json) => Give.fromJson(json)).toList();
        isLoading = false; // 로딩 완료
      });
    } catch (e) {
      // 에러 처리
      setState(() {
        isLoading = false;
      });
      print('JSON 로드 에러: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            '내가 담은 재능',
            style: TextStyle(
              color: Color(0xFF222222),
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            height: 650,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: ListView.builder(
                itemCount: giveList.length, //data 길이만큼으로 수정할 것
                itemBuilder: (BuildContext context, int index) {
                  return buildContainerList(index);
                }),
          ),
        ));
  }

  Container buildContainerList(int index) {
    final Give give = giveList[index];
    return Container(
      height: 153,
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(
          // 밑변에 선 추가
          color: Colors.grey[300]!,
          width: 1, // 선의 두께
        ),
      )),
      child: Row(
        children: [
          Container(
            width: 111,
            height: 113,
            decoration: BoxDecoration(color: Colors.amber),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: SizedBox(
              width: 251,
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${give.title}',
                          style: TextStyle(
                            color: Color(0xFF222222),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.close),
                      ],
                    ),
                    Text(
                      '김대성',
                      style: TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 14,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '1회 ${give.price}원',
                      style: TextStyle(
                        color: Color(0xFF17B36F),
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 79,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Icon(
                                Icons.indeterminate_check_box,
                                color: Color(0xFFD9D9D9),
                              ),
                              Text('2',
                                  style: TextStyle(
                                      color: Color(0xFF44D596),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)), //수량넣기
                              Icon(
                                Icons.add_box,
                                color: Color(0xFFD9D9D9),
                              ),
                            ],
                          ),
                        ),
                        Text('40,000원',
                            style: TextStyle(
                              color: Color(0xFF222222),
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// Give 데이터 모델 클래스
class Give {
  final int giveId;
  final int userId;
  final String title;
  final String desc;
  final int price;
  final String image;

  Give({
    required this.giveId,
    required this.userId,
    required this.title,
    required this.desc,
    required this.price,
    required this.image,
  });

  // JSON 데이터를 Dart 객체로 변환
  factory Give.fromJson(Map<String, dynamic> json) {
    return Give(
      giveId: json['give_id'],
      userId: json['user_id'],
      title: json['title'],
      desc: json['desc'],
      price: json['price'],
      image: json['image'],
    );
  }
}
