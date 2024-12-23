import 'package:flutter/material.dart';
import 'data_service.dart';
import 'models.dart';
import 'package:flutter/cupertino.dart';
import 'package:help_me/util/load_data_from_document.dart';
import 'package:help_me/util/delete_usersgive_to_document.dart';
import 'package:intl/intl.dart';
import 'package:help_me/constant/colors.dart';
import 'dart:io';

class MypageGiveList extends StatefulWidget {
  const MypageGiveList({super.key});

  @override
  State<MypageGiveList> createState() => _MypageGiveListState();
}

class _MypageGiveListState extends State<MypageGiveList> {
  bool isLoading = true; // 로딩 상태를 관리(true : 로딩중, false : 로딩 완료)
  List<int> giveIdList = []; // List<GiveCartList> 타입으로 수정
  List<Users> usersList = [];
  DataService dataService = DataService();
  int userLoginId = 0; // 로그인한 사용자 ID
  List<dynamic> gives = [];
  List<dynamic> users = [];
  String userName = '';
  final comma = NumberFormat("#,###,###원");

  @override
  void initState() {
    super.initState();
    loadData(); // 데이터 로드
  }

  Future<void> loadData() async {
    try {
      gives = await loadDataFromDocument("give.json");
      users = await loadDataFromDocument("users.json");

      setState(() {
        // 로그인한 사용자 ID에 맞는 'give' 데이터를 필터링하여 가져옴
        giveIdList = dataService.findGiveIdsByUserId(users, userLoginId);
        usersList = dataService.convertDynamicListToUsersList(users);
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
      appBar: AppBar(
        title: const Text(
          '내가 담은 재능',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: AppColors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    height: 650,
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                    ),
                    child: giveIdList.isEmpty
                        ? Column(
                            children: [
                              SizedBox(
                                width: 40,
                                height: 40,
                                child: Icon(
                                  Icons.cancel,
                                  color: AppColors.lightGreen,
                                ),
                              ),
                              Text(
                                '담은 재능이 없습니다!',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.black,
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            itemCount: giveIdList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return buildContainerList(
                                  index); // giveList[index] 사용
                            },
                          ),
                  ),
                  Spacer(),
                  Container(
                    width: 370,
                    height: 42,
                    decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.lightGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        int totalSumPrice = 0; //장바구니 총 금액
                        for (int i = 0; i < giveIdList.length; i++) {
                          int price = dataService.findPriceByGiveId(
                              gives, giveIdList[i]);
                          int quantity =
                              dataService.findQuantityByUserIdAndGiveId(
                                  users, userLoginId, giveIdList[i]);
                          totalSumPrice += price * quantity;
                        }
                        if (totalSumPrice != 0) {
                          showCupertinoDialog(
                            context: context,
                            builder: (context) {
                              return CupertinoAlertDialog(
                                title: Text('모두 구매하시겠습니까?'),
                                content:
                                    Text('금액 : ${comma.format(totalSumPrice)}'),
                                actions: [
                                  CupertinoDialogAction(
                                    isDefaultAction: true,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('취소'),
                                  ),
                                  CupertinoDialogAction(
                                    isDestructiveAction: true,
                                    onPressed: () {
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
                            },
                          );
                        }
                      },
                      child: Text(
                        '모두 구매 하기',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4)
                ],
              ),
            ),
    );
  }

  Container buildContainerList(int index) {
    int price = dataService.findPriceByGiveId(gives, giveIdList[index]);
    int quantity = dataService.findQuantityByUserIdAndGiveId(
        users, userLoginId, giveIdList[index]);
    int totalPrice = quantity * price;
    int giveNameId = dataService.findNameByGiveId(gives, giveIdList[index]);
    String userName = dataService.getNameByUserId(usersList, giveNameId);
    String imgUrl = dataService.findImgUrlByGiveId(gives, giveIdList[index]);

    // 수량 증감 함수
    void increaseQuantity(bool plus) {
      dataService.increaseQuantity(
          usersList, userLoginId, giveIdList[index], plus);
      setState(() {
        quantity = dataService.getGiveQuantity(
            usersList, userLoginId, giveIdList[index]);
      });
    }

    return Container(
      height: 153,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[300]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: imgUrl.substring(0, 5) == "https"
                ? Image.network(imgUrl,
                    width: 111, height: 113, fit: BoxFit.cover)
                : Image.file(File(imgUrl),
                    width: double.infinity, height: 409, fit: BoxFit.cover),
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
                          '${dataService.findTitleByGiveId(gives, giveIdList[index])}', //***
                          style: const TextStyle(
                            color: AppColors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                            onTap: () async {
                              await deleteGiveEntry(
                                  userLoginId, giveIdList[index]);
                              // 데이터 재로드
                              await loadData(); // 데이터를 다시 불러옵니다.
                              // 상태 갱신
                              setState(() {});
                            },
                            child: Icon(Icons.close)),
                      ],
                    ),
                    Text(
                      '$userName',
                      style: const TextStyle(
                        color: AppColors.darkGray,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      '1회 ${comma.format(price)}', //***
                      style: const TextStyle(
                        color: AppColors.darkGreen,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
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
                                },
                                child: Icon(
                                  Icons.indeterminate_check_box,
                                  color: AppColors.lightGray,
                                ),
                              ),
                              Text(
                                '$quantity',
                                style: TextStyle(
                                  color: AppColors.lightGreen,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  increaseQuantity(true);
                                },
                                child: Icon(
                                  Icons.add_box,
                                  color: AppColors.lightGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${comma.format(totalPrice)}',
                          style: TextStyle(
                            color: AppColors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
