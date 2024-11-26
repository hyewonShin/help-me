import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:help_me/constant/colors.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class InputInfo extends StatefulWidget {
  String? textInputType; // 입력 및 키보드 타입 null=문자, !null=숫자
  String title; //제목 ex. title: "제목을 입력해주세요."
  String hinttext; //힌트 택스트 문자 ex. hinttext: "힌트를 입력해주세요."
  String? data; //데이터 담는곳
  int? maxLines; // maxline수(줄 개수)
  Function changeValue;

  InputInfo(
    this.textInputType,
    this.maxLines, {
    required this.title,
    required this.hinttext,
    this.data,
    required this.changeValue,
  });

  @override
  State<InputInfo> createState() => _InputInfoState();
}

class _InputInfoState extends State<InputInfo> {
  String? data; //데이터 담는곳
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${widget.title}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        SizedBox(height: 5),
        Container(
          // height: 100,

          child: TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onSaved: (value) {
              widget.changeValue(value, widget.title);
            },
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
                    ), //https://pub.dev/packages/currency_text_input_formatter
                  ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "필수사항을 입력해주세요.";
              }
              return null;
            },
            // expands: true,
            maxLines: widget.maxLines,
            // minLines: null,
            style: TextStyle(fontSize: 16),
            decoration: InputDecoration(
              errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFD7563))),
              hintText: ('${widget.hinttext}'),
              hintStyle: TextStyle(
                  color: AppColors.lightGray, fontWeight: FontWeight.bold),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.lightGray),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: AppColors.lightGreen,
                ),
                borderRadius: BorderRadius.circular(10),
              ), //color: Color borderColor//외곽선
            ),
          ),
        ),
      ],
    );
    ;
  }
}
