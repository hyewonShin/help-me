import 'package:flutter/material.dart';
import 'package:help_me/constant/colors.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

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
      // print(data);
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
              ));
  }
}
