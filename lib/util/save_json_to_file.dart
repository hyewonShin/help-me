import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<void> saveJsonToFile(String fileName, String url) async {
  try {
    final String response = await rootBundle.loadString(url);
    final jsonData = json.decode(response);

    final jsonString = jsonEncode(jsonData);

    final directory = await getApplicationDocumentsDirectory();

    final file = File('${directory.path}/$fileName');
    await file.writeAsString(jsonString);

    print("$fileName 데이터를 파일로 저장했습니다.");
  } catch (e) {
    print("파일 저장에 실패했습니다 : $e");
  }
}

Future<void> writeDataToFile(
    Map<String, dynamic> newData, String fileName) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$fileName';

    final file = File(filePath);
    String jsonString = await file.readAsString();
    List<dynamic> existingData = jsonDecode(jsonString);

    existingData.add(newData);

    jsonString = jsonEncode(existingData);

    await file.writeAsString(jsonString);
    print("$fileName에 새로운 데이터가 추가되었습니다.");
  } catch (e) {
    print("데이터 추가에 실패했습니다.: $e");
  }
}
