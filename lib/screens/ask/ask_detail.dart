import 'package:flutter/material.dart';
import 'package:help_me/constant/colors.dart';
import 'package:help_me/screens/ask/ask_screen.dart' show wonCurrency;

class AskDetail extends StatelessWidget {
  final dynamic item;
  final dynamic userData;
  final int numberOfAsk;

  const AskDetail(
      {Key? key,
      required this.item,
      required this.userData,
      required this.numberOfAsk})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text(userData?['name'] ?? 'Unknown'),
          Row(
            children: [
              Text('재능 담기: ${userData?['give'].length ?? 'Unknown'}'),
              SizedBox(width: 8),
              Container(
                width: 1,
                height: 22,
                color: AppColors.lightGray,
              ),
              SizedBox(width: 8),
              Text('재능 요청: $numberOfAsk')
            ], // user give length, ask join user_id
          ),
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
