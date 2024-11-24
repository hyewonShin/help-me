import 'dart:convert';
import 'package:flutter/services.dart';
import 'models.dart';

class DataService {
  Future<List<Give>> loadGives() async {
    final String responseGive =
        await rootBundle.loadString('lib/mock_data/give.json');
    final List<dynamic> dataGive = jsonDecode(responseGive);
    return dataGive.map((json) => Give.fromJson(json)).toList();
  }

  Future<List<Ask>> loadAsks() async {
    final String responseAsk =
        await rootBundle.loadString('lib/mock_data/ask.json');
    final List<dynamic> dataAsk = jsonDecode(responseAsk);
    return dataAsk.map((json) => Ask.fromJson(json)).toList();
  }

  Future<List<Users>> loadUsers() async {
    final String responseUsers =
        await rootBundle.loadString('lib/mock_data/users.json');
    final List<dynamic> dataUsers = jsonDecode(responseUsers);

    // 데이터 변환 중 타입 강제 처리
    return dataUsers.map((json) {
      return Users.fromJson({
        "user_id": json["user_id"],
        "name": json["name"],
        "give": List<String>.from(json["give"] ?? []),
        "ask": List<String>.from(json["ask"] ?? []),
      });
    }).toList();
  }

  /// userid로 사용자 name 가져오는 함수
  String getNameByUserId(List<Users> usersList, int userId) {
    final user = usersList.where((user) => user.userId == userId).toList();
    return user.isNotEmpty ? user.first.name : 'User not found';
  }

  /// `GiveCartList`를 생성하는 함수
  List<GiveCartList> createGiveCartList(
      List<Give> giveList, List<Users> usersList, int userId) {
    // 결과를 저장할 리스트
    List<GiveCartList> giveCartList = [];

    // userId로 사용자 객체 찾기
    final user = usersList.firstWhere(
      (u) => u.userId == userId,
      orElse: () => Users(
        userId: 0,
        name: 'Unknown',
        giveCart: [],
        askCart: [],
      ),
    );

    // user의 giveCart에 있는 giveId를 순회
    for (String giveIdStr in user.giveCart) {
      // String -> int로 변환
      int? giveId = int.tryParse(giveIdStr);

      // 변환에 실패하거나 잘못된 ID인 경우 무시
      if (giveId == null || giveId < 0) continue;

      // giveList에서 giveId에 해당하는 Give 객체를 찾기
      final give = giveList.firstWhere(
        (give) => give.giveId == giveId,
        orElse: () => Give(
          giveId: -1, // 기본 값으로 유효하지 않은 ID를 지정
          userId: -1,
          title: 'Unknown',
          desc: 'No description',
          price: 0,
          image: 'default_image.png', // 적절한 기본 이미지 경로
        ),
      );

      // give.userId에 해당하는 사용자 이름 찾기
      final username = usersList
          .firstWhere(
            (u) => u.userId == give.userId,
            orElse: () =>
                Users(userId: 0, name: 'Unknown', giveCart: [], askCart: []),
          )
          .name;

      // GiveCartList 객체 생성 및 추가
      giveCartList.add(GiveCartList(
        give.giveId,
        username,
        give.title,
        give.price,
        give.image,
      ));
    }

    return giveCartList;
  }
}
