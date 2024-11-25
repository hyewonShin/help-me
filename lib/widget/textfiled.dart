import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:help_me/constant/colors.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class InputInfo extends StatefulWidget {
  String? textInputType; // 입력 및 키보드 타입 null=문자, !null=숫자
  String title; //제목 ex. title: "제목을 입력해주세요."
  String hinttext; //힌트 택스트 문자 ex. hinttext: "힌트를 입력해주세요."
  var control; //TextEditingController ex. control: controllTitle(변수 정의!)

  InputInfo(this.textInputType,
      {required this.title, required this.hinttext, this.control});

  @override
  State<InputInfo> createState() => _InputInfoState();
}

class _InputInfoState extends State<InputInfo> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.title}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Container(
          // height: 100,
          ///ENUM으로 진행 혹은 EXTEND로 상속을 받아서 위젯으로
          child: TextField(
            controller: widget.control,
            keyboardType: widget.textInputType == null
                ? null
                : TextInputType.numberWithOptions(), //숫자용 키패드
            inputFormatters: widget.textInputType == null
                ? null
                : [
                    CurrencyTextInputFormatter.currency(
                      locale: 'ko',
                      decimalDigits: 0,
                      symbol: '',
                    ),
                  ],

            // expands: true,
            // maxLines: null,
            // minLines: null,
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
              hintText: ('${widget.hinttext}'),
              hintStyle: TextStyle(
                  color: AppColors.lightGray, fontWeight: FontWeight.bold),
              border: OutlineInputBorder(
                  borderSide: BorderSide()), //color: Color borderColor//외곽선
            ),
            onChanged: (value) {
              setState(() {
                Color borderColor =
                    value.isNotEmpty ? AppColors.black : Color(0xFFFD7563);
              });
            },
          ),
        ),
      ],
    );
    ;
  }
}

Widget inputNumInfo(String title, String details, var control) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        '$title',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      SizedBox(height: 5),
      Container(
        // height: 100,
        child: TextField(
          controller: control,
          keyboardType: TextInputType.numberWithOptions(), //숫자용 키패드
          inputFormatters: [FilteringTextInputFormatter.digitsOnly], // 숫자만 입력가능
          // expands: true,
          // maxLines: null,
          // minLines: null,
          style: TextStyle(fontSize: 16),
          decoration: InputDecoration(
            hintText: '$details',
            hintStyle: TextStyle(
                color: AppColors.lightGray, fontWeight: FontWeight.bold),
            border: OutlineInputBorder(), //외곽선
          ),
        ),
      ),
    ],
  );
}
