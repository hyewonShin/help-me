import 'package:flutter/material.dart';
import 'mypage_ask_list.dart';
import 'mypage_give_list.dart';
import 'data_service.dart';
import 'models.dart';
import 'package:help_me/util/load_data_from_document.dart';
import 'package:help_me/constant/colors.dart';

class MypageScreen extends StatefulWidget {
  const MypageScreen({super.key});

  @override
  State<MypageScreen> createState() => _MypageScreenState();
}

class _MypageScreenState extends State<MypageScreen> {
  List<Give> giveList = []; // 데이터를 저장할 리스트
  bool isLoading = true; // 로딩 상태를 관리(true : 로딩중, false : 로딩 완료)
  int userLoginId = 0; // 로그인한 사용자 ID
  int giveCount = 0; //사용자가 담은 재능 개수
  int askCount = 0; //사용자가 요청한 재능개수
  String userName = ''; // 로그인한 사용자 이름

  final DataService dataService = DataService();

  @override
  void initState() {
    super.initState();
    loadData(); // 데이터 로드
  }

  Future<void> loadData() async {
    try {
      final asks = await loadDataFromDocument("ask.json");
      final users = await loadDataFromDocument("users.json");
      final userNameOfLoginUser =
          users.firstWhere((user) => user["user_id"] == userLoginId)["name"];
      List<dynamic> giveList =
          users.firstWhere((user) => user["user_id"] == userLoginId)["give"];
      final asksOfLoginUser = asks
          .where((item) => item["user_id"] == userLoginId)
          .toList()
          .map((ask) => ask = {...ask, "name": userNameOfLoginUser})
          .toList();

      setState(() {
        askCount = asksOfLoginUser.length;
        giveCount = giveList.length;
        userName = userNameOfLoginUser;
      });

      isLoading = false;
    } catch (e) {
      print('데이터 로드 에러: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      //로딩 중 보여주는 화면
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('마이페이지',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: 366,
                      height: 90,
                      decoration: ShapeDecoration(
                        color: AppColors.white,
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              width: 1, color: AppColors.lightGray),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                //userId를 이용하여 사용자의 이름 표시
                                '${userName}',
                                style: const TextStyle(
                                  color: AppColors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                )),
                            Row(
                              children: [
                                const Text('재능 담기',
                                    style: TextStyle(
                                      color: AppColors.darkGray,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    )),
                                Text(' $giveCount회 ',
                                    style: const TextStyle(
                                      color: AppColors.lightGreen,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    )),
                                Container(
                                    width: 1,
                                    height: 22,
                                    decoration: const BoxDecoration(
                                        color: AppColors.lightGray)),
                                const Text(' 재능 요청',
                                    style: TextStyle(
                                      color: AppColors.darkGray,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    )),
                                Text(' $askCount회 ',
                                    style: const TextStyle(
                                      color: AppColors.lightGreen,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    )),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      '나의 거래',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MypageGiveList(),
                          ),
                        ).then((_) {
                          // 다른 페이지(MypageGiveList)에서 돌아온 후 데이터 로드
                          loadData();
                        });
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.list),
                          SizedBox(
                            width: 12,
                          ),
                          Text('내가 담은 재능',
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MypageAskList(
                                  userLoginId: userLoginId // userLoginId 전달
                                  ),
                            ));
                      },
                      child: const Row(
                        children: [
                          Icon(Icons.search),
                          SizedBox(
                            width: 12,
                          ),
                          Text('내가 요청한 재능',
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 16,
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
