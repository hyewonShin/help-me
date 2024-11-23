import 'package:flutter/material.dart';
import 'package:help_me/screens/mypage/mypage_ask_list.dart';
import 'package:help_me/screens/mypage/mypage_give_list.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class MypageScreen extends StatefulWidget {
  const MypageScreen({super.key});

  @override
  State<MypageScreen> createState() => _MypageScreenState();
}

class _MypageScreenState extends State<MypageScreen> {
  List<Give> giveList = []; // 데이터를 저장할 리스트
  List<Ask> askList = [];
  List<Users> usersList = [];
  bool isLoading = true; // 로딩 상태를 관리
  int userLoginId = 0; // 로그인한 사용자 ID
  int giveCount = 0; //사용자가 담은 재능 개수
  int askCount = 0; //사용자가 요청한 재능개수

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
      final String responseAsk =
          await rootBundle.loadString('lib/mock_data/ask.json');
      final String responseUsers =
          await rootBundle.loadString('lib/mock_data/users.json');
      final List<dynamic> dataGive = jsonDecode(responseGive);
      final List<dynamic> dataAsk = jsonDecode(responseAsk);
      final List<dynamic> dataUsers = jsonDecode(responseUsers);

      // 데이터를 객체 리스트로 변환
      setState(() {
        giveList = dataGive.map((json) => Give.fromJson(json)).toList();
        askList = dataAsk.map((json) => Ask.fromJson(json)).toList();
        usersList = dataUsers.map((json) => Users.fromJson(json)).toList();

        isLoading = false; // 로딩 완료      print('eee');
      });
    } catch (e) {
      // 에러 처리
      setState(() {
        isLoading = false;
      });
      print('JSON 로드 에러: $e');
    }
    setState(() {
      giveCount = giveList.fold(
        0,
        (previousValue, give) =>
            give.userId == userLoginId ? previousValue + 1 : previousValue,
      );
      askCount = askList.fold(
        0,
        (previousValue, ask) =>
            ask.userId == userLoginId ? previousValue + 1 : previousValue,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('마이페이지',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 20,
                fontWeight: FontWeight.w700,
              )),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 366,
            height: 90,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: Color(0xFFD9D9D9)),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${DataMethod.getNameByUserId(usersList, 0)}',
                      style: TextStyle(
                        color: Color(0xFF222222),
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w700,
                      )),
                  Row(
                    children: [
                      Text('재능 담기',
                          style: TextStyle(
                            color: Color(0xFF9E9E9E),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                      Text(' $giveCount회 ',
                          style: TextStyle(
                            color: Color(0xFF44D596),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                      Container(
                          width: 1,
                          height: 22,
                          decoration: BoxDecoration(color: Color(0xFFD9D9D9))),
                      Text(' 재능 요청',
                          style: TextStyle(
                            color: Color(0xFF9E9E9E),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                      Text(' $askCount회 ',
                          style: TextStyle(
                            color: Color(0xFF44D596),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            '나의 거래',
            style: TextStyle(
              color: Color(0xFF222222),
              fontSize: 16,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MypageGiveList();
              }));
            },
            child: Row(
              children: [
                Icon(Icons.list),
                SizedBox(
                  width: 12,
                ),
                Text('내가 담은 재능',
                    style: TextStyle(
                      color: Color(0xFF222222),
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                    ))
              ],
            ),
          ),
          SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MypageAskList();
              }));
            },
            child: Row(
              children: [
                Icon(Icons.search),
                SizedBox(
                  width: 12,
                ),
                Text('내가 요청한 재능',
                    style: TextStyle(
                      color: Color(0xFF222222),
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                    ))
              ],
            ),
          )
        ],
      ),
    ));
  }
}

class DataMethod {
  /// userid로 사용자 name 가져오는 함수
  static getNameByUserId(List<Users> usersList, int userId) {
    final user = usersList.where((user) => user.userId == userId).toList();
    return user.isNotEmpty ? user.first.name : 'User not found';
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

// Ask 데이터 모델 클래스
class Ask {
  final int askId;
  final int userId;
  final String title;
  final String desc;
  final int price;

  Ask({
    required this.askId,
    required this.userId,
    required this.title,
    required this.desc,
    required this.price,
  });

  // JSON 데이터를 Dart 객체로 변환
  factory Ask.fromJson(Map<String, dynamic> json) {
    return Ask(
      askId: json['ask_id'],
      userId: json['user_id'],
      title: json['title'],
      desc: json['desc'],
      price: json['price'],
    );
  }
}

// Users 데이터 모델 클래스
class Users {
  final int userId;
  final String name;
  // final List<String> give;
  // final List<String> ask;

  Users({
    required this.userId,
    required this.name,
    // required this.give,
    // required this.ask,
  });

  // JSON 데이터를 Dart 객체로 변환
  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      userId: json['user_id'],
      name: json['name'],
      // give: json['give'],
      // ask: json['ask'],
    );
  }
}
