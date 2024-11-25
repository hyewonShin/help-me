import 'package:flutter/material.dart';
import 'package:help_me/constant/colors.dart';
import 'package:help_me/main.dart';
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
      backgroundColor: AppColors.white,
      appBar: AppBar(),
      body: Column(
        children: [
          Container(
              width: double.infinity, height: 1, color: AppColors.lightGray),
          Container(
            width: 362,
            height: 86,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColors.lightGray, width: 1))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userData?['name'] ?? 'Unknown',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.black)),
                SizedBox(height: 2),
                Row(
                  children: [
                    //Text('재능 담기 ${userData?['give'].length ?? 'Unknown'}회')
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: '재능 담기 ',
                          style: TextStyle(
                              color: AppColors.darkGray, fontSize: 14)),
                      TextSpan(
                          text: '${userData?['give'].length ?? 'Unknown'}회',
                          style: TextStyle(
                              color: AppColors.lightGreen, fontSize: 14))
                    ])),
                    SizedBox(width: 8),
                    Container(
                      width: 1,
                      height: 22,
                      color: AppColors.lightGray,
                    ),
                    SizedBox(width: 8),
                    //Text('재능 요청 ${numberOfAsk}회')
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: '재능 요청 ',
                          style: TextStyle(
                              color: AppColors.darkGray, fontSize: 14)),
                      TextSpan(
                          text: '${numberOfAsk}회',
                          style: TextStyle(
                              color: AppColors.lightGreen, fontSize: 14))
                    ]))
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 362,
            height: 62,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: AppColors.lightGray, width: 1))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("사례금 ${wonCurrency(item['price'])}",
                    style: TextStyle(
                        fontSize: 16,
                        color: AppColors.darkGreen,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: 362,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['title'],
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          SizedBox(height: 20),
          SingleChildScrollView(
            child: Container(
              width: 362,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: (item['desc'] ?? '')
                    .toString()
                    .split('. ')
                    .map((sentence) => Text(
                          sentence.trim(),
                          style:
                              TextStyle(fontSize: 16, color: AppColors.black),
                        ))
                    .toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
