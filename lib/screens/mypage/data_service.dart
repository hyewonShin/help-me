import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:help_me/util/udate_quantity_to_document.dart';
import 'models.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart'; // path_provider 임포트
import 'package:help_me/util/load_data_from_document.dart';

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
    print('userId$userId');
    print(usersList);
    print(usersList.length);
    return user.isNotEmpty ? user.first.name : 'User not found';
  }

  /// `GiveCartList`를 생성하는 함수
  List<GiveCartList> createGiveCartList(
      List<dynamic> giveList, List<Users> usersList, int userId) {
    // Give 객체 리스트로 변환
    final parsedGiveList = giveList.map((json) => Give.fromJson(json)).toList();

    // 결과 리스트 초기화
    List<GiveCartList> giveCartList = [];

    // 특정 사용자 찾기
    final user = usersList.firstWhere(
      (u) => u.userId == userId,
      orElse: () =>
          Users(userId: -1, name: 'Unknown', giveCart: [], askCart: []),
    );

    // 사용자 giveCart 순회
    for (var giveCartItem in user.giveCart) {
      // giveCartItem에서 give_id와 quantity 추출
      final giveId = giveCartItem['give_id'] ?? -1;
      final quantity = giveCartItem['quantity'] ?? 0;

      // giveId에 해당하는 Give 객체 찾기
      final give = parsedGiveList.firstWhere(
        (g) => g.giveId == giveId,
        orElse: () => Give(
          giveId: -1,
          userId: -1,
          title: 'Unknown',
          desc: 'No description',
          price: 0,
          image: 'default_image.png',
        ),
      );

      // Give 객체의 userId로 사용자 이름 찾기
      final username = usersList
          .firstWhere(
            (u) => u.userId == give.userId,
            orElse: () =>
                Users(userId: -1, name: 'Unknown', giveCart: [], askCart: []),
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

  int getGiveQuantity(List<dynamic> users, int userId, int giveId) {
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
    // try {
    // 사용자 찾기
    final user = usersList.firstWhere((u) => u.userId == userLoginId);

    // giveCart에서 giveId 항목 찾기
    final giveItem = user.giveCart.firstWhere(
      (g) => g['give_id'] == giveId,
      orElse: () => {'give_id': giveId, 'quantity': 0}, // 기본값 반환
    );

    // int result = giveItem['quantity'];
    // 수량 조정
    if (plus) {
      giveItem['quantity'] += 1;
    } else if (giveItem['quantity'] > 0) {
      giveItem['quantity'] -= 1;
    }
    updateQuantity(userLoginId, giveId, giveItem['quantity']);

    //   // 수정된 usersList를 JSON으로 변환
    //   final updatedJsonString =
    //       jsonEncode(usersList.map((u) => u.toJson()).toList());

    //   // 파일에 저장
    //   await FileIO.writeFileAsString(
    //     data: updatedJsonString,
    //     path: 'users.json',
    //   );

    //   print('수량이 성공적으로 업데이트되었습니다.');
    // } catch (e) {
    //   print('수량 업데이트 중 오류 발생: $e');
    // }
  }

  List<Users> convertDynamicListToUsersList(List<dynamic> dynamicList) {
    return dynamicList
        .map((item) => Users.fromJson(item as Map<String, dynamic>))
        .toList();
  }

// 특정 사용자의 give_id를 가져오는 함수
  List<int> findGiveIdsByUserId(List<dynamic> users, int targetUserId) {
    // 특정 사용자의 give_id를 담을 리스트
    List<int> giveIds = [];

    // 사용자 리스트를 순회
    for (var user in users) {
      // 사용자의 user_id가 targetUserId와 일치하는지 확인
      if (user['user_id'] == targetUserId) {
        // 사용자의 give 항목이 있다면, 그 항목을 순회하며 give_id를 담는다
        for (var give in user['give']) {
          giveIds.add(give['give_id']);
        }
      }
    }

    return giveIds; // 해당 사용자의 give_id 목록 반환
  }

  int findGiveQuantity(
      List<dynamic> users, int targetUserId, int targetGiveId) {
    // 주어진 사용자 ID 찾기
    var user = users.firstWhere((user) => user['user_id'] == targetUserId,
        orElse: () => null);

    if (user == null) {
      print("사용자를 찾을 수 없습니다.");
      return 0; // 사용자가 없으면 기본값 0 반환
    }

    // 해당 사용자가 주는 give 목록 찾기
    var gives = user['give'];

    // give 목록에서 특정 give_id의 quantity 찾기
    var give = gives.firstWhere((give) => give['give_id'] == targetGiveId,
        orElse: () => null);

    if (give == null) {
      print("해당 give_id를 찾을 수 없습니다.");
      return 0; // give_id가 없으면 기본값 0 반환
    }

    return give['quantity']; // give_id와 일치하는 quantity 반환
  }

  // give_id를 받아서 해당하는 title을 반환하는 함수
  String findTitleByGiveId(List<dynamic> gives, int giveId) {
    // gives 리스트에서 give_id가 주어진 giveId와 일치하는 항목을 찾음
    var giveItem = gives.firstWhere((give) => give['give_id'] == giveId,
        orElse: () => null // give_id가 없으면 null을 반환
        );

    // give_id가 존재하면 title을 반환, 그렇지 않으면 '항목 없음' 반환
    return giveItem != null ? giveItem['title'] : '항목 없음';
  }

  // give_id를 받아서 해당하는 userId을 반환하는 함수
  int findNameByGiveId(List<dynamic> gives, int giveId) {
    // gives 리스트에서 give_id가 주어진 giveId와 일치하는 항목을 찾음
    var giveItem = gives.firstWhere((give) => give['give_id'] == giveId,
        orElse: () => null // give_id가 없으면 null을 반환
        );

    // give_id가 존재하면 title을 반환, 그렇지 않으면 '항목 없음' 반환
    return giveItem != null ? giveItem['user_id'] : '항목 없음';
  }

  // give_id를 받아서 해당하는 price을 반환하는 함수
  int findPriceByGiveId(List<dynamic> gives, int giveId) {
    // gives 리스트에서 give_id가 주어진 giveId와 일치하는 항목을 찾음
    var giveItem = gives.firstWhere((give) => give['give_id'] == giveId,
        orElse: () => null // give_id가 없으면 null을 반환
        );

    // give_id가 존재하면 title을 반환, 그렇지 않으면 '항목 없음' 반환
    return giveItem != null ? giveItem['price'] : '항목 없음';
  }

  // give_id를 받아서 해당하는 imgurl을 반환하는 함수
  String findImgUrlByGiveId(List<dynamic> gives, int giveId) {
    // gives 리스트에서 give_id가 주어진 giveId와 일치하는 항목을 찾음
    var giveItem = gives.firstWhere((give) => give['give_id'] == giveId,
        orElse: () => null // give_id가 없으면 null을 반환
        );

    // give_id가 존재하면 title을 반환, 그렇지 않으면 '항목 없음' 반환
    return giveItem != null ? giveItem['image'] : '항목 없음';
  }

  // 특정 user_id와 give_id에 해당하는 quantity를 찾는 함수
  int findQuantityByUserIdAndGiveId(
      List<dynamic> users, int userId, int giveId) {
    // 주어진 user_id에 해당하는 사용자 찾기
    var user = users.firstWhere((user) => user['user_id'] == userId,
        orElse: () => null // user_id가 없으면 null 반환
        );

    // user_id가 존재하면 그 사용자의 give 목록을 확인
    if (user != null) {
      // 해당 사용자의 give 배열에서 give_id가 주어진 giveId와 일치하는 항목 찾기
      var giveItem = user['give'].firstWhere(
          (give) => give['give_id'] == giveId,
          orElse: () => null // give_id가 없으면 null 반환
          );

      // give_id가 존재하면 quantity를 반환, 그렇지 않으면 0 반환
      return giveItem != null ? giveItem['quantity'] : 0;
    }

    // user_id가 없으면 0 반환
    return 0;
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
