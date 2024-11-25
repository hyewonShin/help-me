import 'package:flutter/material.dart';
import 'data_service.dart';
import 'models.dart';
import 'package:flutter/cupertino.dart';

class MypageGiveList extends StatefulWidget {
  const MypageGiveList({super.key});

  @override
  State<MypageGiveList> createState() => _MypageGiveListState();
}

class _MypageGiveListState extends State<MypageGiveList> {
  List<GiveCartList> giveList = []; // 데이터를 저장할 리스트
  List<Users> usersList = [];
  DataService dataService = DataService();
  int userLoginId = 0; // 로그인한 사용자 ID

  @override
  void initState() {
    super.initState();
    loadData(); // 데이터 로드
  }

  Future<void> loadData() async {
    try {
      final gives = await dataService.loadGives();
      final users = await dataService.loadUsers();
      final giveCartData =
          await dataService.createGiveCartList(gives, users, userLoginId);

      setState(() {
        giveList = giveCartData;
        usersList = users;
      });
    } catch (e) {
      print('데이터 로드 에러: $e');
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
          child: Column(
            children: [
              Container(
                height: 650,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: ListView.builder(
                    itemCount: giveList.length, //data 길이만큼 리스트 뷰 생성
                    itemBuilder: (BuildContext context, int index) {
                      return buildContainerList(index);
                    }),
              ),
              Container(
                width: 370,
                height: 42,
                decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF44D596),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),

                    ///버튼 터치시 호출할 함수
                    onPressed: () {
                      showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text('모두 구매하시겠습니까?'),
                              content: Text('금액 : 원'),
                              actions: [
                                CupertinoDialogAction(
                                  isDefaultAction: true,
                                  onPressed: () {
                                    //취소 버튼 터치시 알림창 종료
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('취소'),
                                ),
                                CupertinoDialogAction(
                                  isDestructiveAction: true,
                                  onPressed: () {
                                    // 스택에서 현재 페이지 포함 3번째 페이지로 이동
                                    int count = 0;
                                    Navigator.of(context).popUntil((route) {
                                      count++;
                                      return count == 3;
                                    });
                                  },
                                  child: Text('확인'),
                                ),
                              ],
                            );
                          });
                    },
                    child: Text(
                      '모두 구매 하기',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    )),
              )
            ],
          ),
        ));
  }

  Container buildContainerList(int index) {
    //index를 파라미터로 받아 Container를 생성하는 함수
    GiveCartList give = giveList[index];
    String imgUrl = give.image;
    int giveListQuantity = 0;

    giveListQuantity =
        dataService.getGiveQuantity(usersList, userLoginId, give.giveId);

    // 수량 감소 함수
    void decreaseQuantity() {
      setState(() {
        if (giveListQuantity > 0) {
          giveListQuantity--; // 값 1 감소
        }
      });
    }

    // 수량 증가 감소 함수
    void increaseQuantity(bool plus) {
      dataService.increaseQuantity(usersList, userLoginId, give.giveId, plus);
      setState(() {
        giveListQuantity =
            dataService.getGiveQuantity(usersList, userLoginId, give.giveId);
      });
    }

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
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(imgUrl,
                width: 111, height: 113, fit: BoxFit.cover),
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
                          style: const TextStyle(
                            color: Color(0xFF222222),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.close), //delete 기능 넣을것#####
                      ],
                    ),
                    Text(
                      '${give.username}',
                      style: const TextStyle(
                        color: Color(0xFF9E9E9E),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '1회 ${give.price}원',
                      style: const TextStyle(
                        color: Color(0xFF17B36F),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
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
                              GestureDetector(
                                onTap: () {
                                  increaseQuantity(false);
                                }, // 아이콘 터치 시 감소 함수 호출
                                child: Icon(
                                  Icons
                                      .indeterminate_check_box, //+- 기능 넣기 ###########
                                  color: Color(0xFFD9D9D9),
                                ),
                              ),
                              Text('$giveListQuantity',
                                  style: TextStyle(
                                      color: Color(0xFF44D596),
                                      fontSize: 20,
                                      fontWeight:
                                          FontWeight.bold)), //수량넣기############
                              GestureDetector(
                                onTap: () {
                                  increaseQuantity(true);
                                }, // 아이콘 터치 시 증가 함수 호출
                                child: Icon(
                                  Icons.add_box,
                                  color: Color(0xFFD9D9D9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                            '${giveListQuantity * give.price}원', //금액 변경 함수 넣기 #########
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
