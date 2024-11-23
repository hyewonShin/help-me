import 'package:flutter/material.dart';
import 'package:help_me/screens/mypage/mypage_ask_list.dart';
import 'package:help_me/screens/mypage/mypage_give_list.dart';
import 'dart:convert';

class MypageScreen extends StatelessWidget {
  const MypageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('마이페이지',
              style: TextStyle(
                color: Color(0xFF222222),
                fontSize: 20,
                fontWeight: FontWeight.w700,
              )),
          SizedBox(
            height: 20,
          ),
          Container(
            width: 366,
            height: 90,
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: Color(0xFFD9D9D9)),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('김대성',
                      style: TextStyle(
                        color: Color(0xFF222222),
                        fontSize: 16,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w700,
                      )),
                  Row(
                    children: [
                      Text('재능 담기',
                          style: TextStyle(
                            color: Color(0xFF9E9E9E),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                      Text(' 2회 ',
                          style: TextStyle(
                            color: Color(0xFF44D596),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                      Container(
                          width: 1,
                          height: 22,
                          decoration: BoxDecoration(color: Color(0xFFD9D9D9))),
                      Text(' 재능 요청',
                          style: TextStyle(
                            color: Color(0xFF9E9E9E),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                      Text(' 3회 ',
                          style: TextStyle(
                            color: Color(0xFF44D596),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            '나의 거래',
            style: TextStyle(
              color: Color(0xFF222222),
              fontSize: 16,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MypageGiveList();
              }));
            },
            child: Row(
              children: [
                Icon(Icons.list),
                SizedBox(
                  width: 12,
                ),
                Text('내가 담은 재능',
                    style: TextStyle(
                      color: Color(0xFF222222),
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                    ))
              ],
            ),
          ),
          SizedBox(
            height: 12,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return MypageAskList();
              }));
            },
            child: Row(
              children: [
                Icon(Icons.search),
                SizedBox(
                  width: 12,
                ),
                Text('내가 요청한 재능',
                    style: TextStyle(
                      color: Color(0xFF222222),
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                    ))
              ],
            ),
          )
        ],
      ),
    ));
  }
}
