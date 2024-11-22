import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class GiveSubmit extends StatefulWidget {
  const GiveSubmit({super.key});

  @override
  State<GiveSubmit> createState() => _GiveSubmitState();
}

class _GiveSubmitState extends State<GiveSubmit> {
  TextEditingController controllTitle =
      TextEditingController(); //제목 textfield 데이터 받기
  TextEditingController controllPrice =
      TextEditingController(); //가격 textfield 데이터 받기
  TextEditingController controllText =
      TextEditingController(); //상세내용 textfiled 데이터 받기
  Future<void> getImagePickerData() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();
    print(images.length);
  } //image picker

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [Text('등록')], //TODO GESTUREDETECTOR JSON 파일에 등록
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  getImagePickerData(); //image picker
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffCCCCCC))),
                  height: 50,
                  width: 50,
                  child: Icon(Icons.photo_camera),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(height: 20),
                    inputInfo('제목', '도와줄 수 있는 내용을 입력해주세요.', controllTitle),
                    SizedBox(height: 20),
                    inputNumInfo('가격', '제공할 재능 이용원의 가격을 적어주세요.', controllPrice),
                    SizedBox(height: 20),
                    inputInfo('상세설명', '제공할 재능의 상세 내용을 적어주세요.', controllText),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///제목, 상세설명 textfield
  Widget inputInfo(String title, String text, var control) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$title'),
        SizedBox(height: 5),
        Container(
          // height: 100,
          child: TextField(
            controller: control,
            // expands: true,
            // maxLines: null,
            // minLines: null,
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

  ///가격 textfield
  Widget inputNumInfo(String title, String text, var control) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$title'),
        SizedBox(height: 5),
        Container(
          // height: 100,
          child: TextField(
            controller: control,
            keyboardType: TextInputType.numberWithOptions(), //숫자용 키패드
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly
            ], // 숫자만 입력가능
            // expands: true,
            // maxLines: null,
            // minLines: null,
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

//shared_preferences -핸드폰내부로 저장 할 수 있도록