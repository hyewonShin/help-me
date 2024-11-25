import 'dart:convert';
import 'package:flutter/services.dart';
import 'models.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart'; // path_provider 임포트

class DataService {
  //json 파일 로드하여 models의 class로 변환
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
        "give": List<Map<String, dynamic>>.from(json["give"] ?? []),
        "ask": List<Map<String, dynamic>>.from(json["ask"] ?? []),
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
        // 못 찾았을 시 반환 값
        userId: 0,
        name: 'Unknown',
        giveCart: [],
        askCart: [],
      ),
    );

    // user의 giveCart를 순회
    for (var giveCartSet in user.giveCart) {
      // Map 형식의 giveCartSet에서 give_id와 quantity 추출
      final giveId = giveCartSet['give_id'];
      final quantity = giveCartSet['quantity'];

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
        quantity,
        give.price,
        give.image,
      ));
    }

    return giveCartList;
  }

  int getGiveQuantity(List<Users> users, int userId, int giveId) {
    // 특정 userId를 가진 사용자를 찾기
    final user = users.firstWhere((user) => user.userId == userId);

    // 해당 사용자의 give 목록에서 giveId를 가진 항목 찾기
    final giveItem =
        user.giveCart.firstWhere((give) => give['give_id'] == giveId);

    return giveItem['quantity'] ?? 0; // 유효한 경우 quantity 반환
  }

  // `increaseQuantity` 함수 추가: userId와 giveId를 받아 quantity를 1 증가시키는 함수
  Future<void> increaseQuantity(
      List<Users> usersList, int userLoginId, int giveId, bool plus) async {
    try {
      // usersList에서 해당 userLoginId를 가진 사용자 찾기
      final user = usersList.firstWhere(
        (user) => user.userId == userLoginId,
      );

      // 해당 사용자의 give 목록에서 give_id를 가진 항목 찾기
      final giveItem = user.giveCart.firstWhere(
        (give) => give['give_id'] == giveId,
      );

      if (plus) {
        // quantity 증가
        giveItem['quantity'] += 1;
      } else if (giveItem['quantity'] > 0) {
        // quantity 감소
        giveItem['quantity'] -= 1;
      } else {
        return;
      } // quantity 0 이하일 때 do nothing

      // 수정된 usersList를 JSON으로 변환
      final updatedJsonString =
          jsonEncode(usersList.map((user) => user.toJson()).toList());

      // 파일에 저장
      await FileIO.writeFileAsString(
          data: updatedJsonString, path: 'users.json');

      print('quantity가 성공적으로 1 증가되었습니다.');
    } catch (e) {
      print('오류 발생: $e');
    }
  }
}

class FileIO {
  static Future<File> _getLocalFile(String path) async {
    // 앱의 로컬 문서 디렉토리 경로를 얻음
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$path'; // 경로 형성
    print("저장할 경로: $filePath"); // 경로 확인 로그 추가
    return File(filePath);
  }

  static Future<File> writeFileAsString({String? data, String? path}) async {
    final file = await _getLocalFile(path ?? 'default.json'); // 기본 파일명 설정
    print("파일 쓰기 중..."); // 로그 추가
    return file.writeAsString(data ?? '').then((value) {
      print('파일 저장 성공: $value'); // 파일 저장 성공 로그 추가
      return value;
    }).catchError((e) {
      print('파일 저장 중 오류 발생: $e'); // 오류 로그 추가
      throw e;
    });
  }

  static Future<String> readFileAsString(String path) async {
    final file = await _getLocalFile(path);
    return file.readAsString();
  }
}
