import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> updateQuantity(int userId, int giveId, int newQuantity) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/users.json';

    // 파일 읽기
    final file = File(filePath);
    String jsonString = await file.readAsString();
    List<dynamic> existingData = jsonDecode(jsonString);

    // 해당 user_id와 give_id를 가진 데이터 찾기
    bool isUpdated = false;
    bool giveFound = false;
    for (var user in existingData) {
      if (user['user_id'] == userId) {
        for (var give in user['give']) {
          if (give['give_id'] == giveId) {
            give['quantity'] = newQuantity;
            isUpdated = true;
            giveFound = true;
            break;
          }
        }
        // 해당 give_id가 없는 경우, List에 추가
        if (!giveFound) {
          user['give'].add({"give_id": giveId, "quantity": newQuantity});
          isUpdated = true;
          break;
        }
      }
    }

    if (!isUpdated) {
      print("주어진 user_id 또는 give_id에 해당하는 항목을 찾을 수 없습니다.");
      return;
    }

    // 수정된 데이터를 다시 JSON 문자열로 변환
    jsonString = jsonEncode(existingData);

    // 파일에 덮어쓰기
    await file.writeAsString(jsonString);
    print("users.json의 데이터가 업데이트되었습니다.");
  } catch (e) {
    print("데이터 수정에 실패했습니다: $e");
  }
}
