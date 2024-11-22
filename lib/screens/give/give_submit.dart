import 'package:flutter/material.dart';

class GiveSubmit extends StatelessWidget {
  const GiveSubmit({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [Text('등록')],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Color(0xffCCCCCC))),
                height: 50,
                width: 50,
                child: Icon(Icons.photo_camera),
              ),
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(height: 20),
                    inputInfo('제목', '도와줄 수 있는 내용을 입력해주세요.'),
                    SizedBox(height: 20),
                    inputInfo('가격', '제공할 재능 이용원의 가격을 적어주세요.'),
                    SizedBox(height: 20),
                    inputInfo('상세설명', '제공할 재능의 상세 내용을 적어주세요.'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget inputInfo(String title, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$title'),
        Container(
          height: 50,
          child: TextField(
            expands: true,
            maxLines: null,
            minLines: null,
            style: TextStyle(fontSize: 10),
            decoration: InputDecoration(
              hintText: '$text',

              border: OutlineInputBorder(), //외곽선
            ),
          ),
        ),
      ],
    );
  }
}
