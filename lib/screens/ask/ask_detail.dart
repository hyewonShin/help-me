import 'package:flutter/material.dart';
import 'package:help_me/constant/colors.dart';
import 'package:help_me/screens/ask/ask_screen.dart' show wonCurrency;

class AskDetail extends StatelessWidget {
  final dynamic item;

  const AskDetail({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text("사례금 ${wonCurrency(item['price'])}",
              style: TextStyle(
                  fontSize: 16,
                  color: AppColors.darkGreen,
                  fontWeight: FontWeight.bold)),
          Text(item['title']),
          Text(item['desc'])
        ],
      ),
    );
  }
}
