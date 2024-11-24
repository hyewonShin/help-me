import 'package:flutter/material.dart';
import 'mypage_ask_list.dart';
import 'mypage_give_list.dart';
import 'data_service.dart';
import 'models.dart';

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

  final DataService dataService = DataService();

  void initState() {
    super.initState();
    loadData(); // 데이터 로드
  }

  Future<void> loadData() async {
    try {
      final gives = await dataService.loadGives();
      final asks = await dataService.loadAsks();
      final users = await dataService.loadUsers();

      setState(() {
        giveList = gives;
        askList = asks;
        usersList = users;

        giveCount = giveList
            .where((give) => give.userId == userLoginId)
            .length; // 재능 담기 개수 계산
        askCount = askList
            .where((ask) => ask.userId == userLoginId)
            .length; // 재능 요청 개수 계산

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('데이터 로드 에러: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
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
                            Text('${dataService.getNameByUserId(usersList, 0)}',
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
                                    decoration: BoxDecoration(
                                        color: Color(0xFFD9D9D9))),
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
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
