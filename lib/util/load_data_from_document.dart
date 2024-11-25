import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

Future<List<dynamic>> loadDataFromDocument(String fileName) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/$fileName");
    final jsonString = await file.readAsString();
    final data = jsonDecode(jsonString) as List<dynamic>;
    return data;
  } catch (e) {
    print("데이터 불러오는 데에 오류가 발생했습니다. : $e");
    return [];
  }
}
