import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<void> deleteUsersAskData(askId) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/ask.json';

    // 파일 읽기
    final file = File(filePath);
    String jsonString = await file.readAsString();
    List<dynamic> existingData = jsonDecode(jsonString);

    // 해당 ask_id를 가진 데이터 삭제
    existingData.removeWhere((item) => item['ask_id'] == askId);

    // 수정된 데이터를 다시 JSON 문자열로 변환
    jsonString = jsonEncode(existingData);

    // 파일에 덮어쓰기
    await file.writeAsString(jsonString);
    print("ask.json의 데이터가 삭제되었습니다.");
  } catch (e) {
    print("데이터 삭제에 실패했습니다: $e");
  }
}
