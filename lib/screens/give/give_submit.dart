import 'package:flutter/material.dart';
import 'package:help_me/constant/colors.dart';
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
      TextEditingController(); //상세내용 textfiled 데이터 받기 controllText.text
  XFile? file;
  Future<void> getImagePickerData() async {
    ImagePicker().pickImage(source: ImageSource.gallery).then((image) {
      if (image != null) {
        setState(() {
          file = image;
        });
      }
    });
  } //image picker

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '재능 기부하기',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  getImagePickerData(); //TODO image picker 이미지 선택하면 이미지 넣기
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
              Center(
                  child: Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text(
                    '작성완료',
                    style: TextStyle(color: AppColors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lightGreen,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                ),
              )),
              SizedBox(
                height: 20,
              )
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
        Text(
          '$title',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        Container(
          // height: 100,
          child: TextField(
            controller: control,
            // expands: true,
            // maxLines: null,
            // minLines: null,
            style: TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: ('$text'),
              hintStyle: TextStyle(
                  color: AppColors.lightGray, fontWeight: FontWeight.bold),
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
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly
            ], // 숫자만 입력가능
            // expands: true,
            // maxLines: null,
            // minLines: null,
            style: TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: '$text',
              hintStyle: TextStyle(
                  color: AppColors.lightGray, fontWeight: FontWeight.bold),
              border: OutlineInputBorder(), //외곽선
            ),
          ),
        ),
      ],
    );
  }
}

//shared_preferences -핸드폰내부로 저장 할 수 있도록
//json decode return map key dynamic rpg 게임에서 파일 저장하도록
//상태관리 data어떻게 불러 와서 어떻게&어디서(목록위치) 관리할지? 문의→ 신혜원님
// 등록하기에서 json 바로 수정하면 홈페이지 동기화 반영이 안됨.(새로고침, 데이터 동기화 되게 구조를 짜거나?)

//give screen 데이터 호출 및 상태 등록
// 그 상태를 add 하여 변경
//


 //TODO GESTUREDETECTOR JSON 파일에 등록