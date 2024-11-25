import 'package:flutter/material.dart';
import 'package:help_me/constant/colors.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:help_me/screens/ask/ask_submit.dart';

class AskScreen extends StatefulWidget {
  AskScreen({super.key});

  @override
  State<AskScreen> createState() => _AskScreenState();
}

class _AskScreenState extends State<AskScreen> {
  String askJsonUrl = "lib/mock_data/ask.json";
  List<dynamic> _data = [];

  @override
  void initState() {
    super.initState();
    _loadData(askJsonUrl);
  }

  Future<void> _loadData(url) async {
    try {
      final String response = await rootBundle.loadString(url);
      final data = json.decode(response);
      print(data);
      setState(() {
        _data = data;
      });
    } catch (e) {
      print('error: $e');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("HELPME")),
      body: _data.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                final item = _data[index];
                return ListTile(
                  title: Text(
                    item['title'],
                    style: TextStyle(color: AppColors.black),
                  ),
                  subtitle: Column(children: [
                    Text(item['desc']),
                    // Text(item['user_id'].toString()),
                    // Text(item['ask_id'].toString()),
                  ]),
                );
              },
            ),
      floatingActionButton: SizedBox(
        width: 99,
        height: 47,
        child: FloatingActionButton(
          heroTag: "2",
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AskSubmit();
              // return GiveSubmit(submitGiveData: submitGiveData);  // 진용님 => give_submit에서 submitGiveData() 테스트시 사용하시면 됩니다
            }));
          },
          foregroundColor: AppColors.white,
          backgroundColor: AppColors.lightGreen,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Text(
            '+ 글쓰기',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
