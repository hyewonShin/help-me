import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:help_me/constant/colors.dart';
import 'package:help_me/widget/textfield.dart';
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
  final _formKey = GlobalKey<FormState>();
  Future<void> getImagePickerData() async {
    final imagePicker = ImagePicker();
    // Future<XFile?>
    final XFile? xFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      setState(() {
        file = xFile;
      });
    }
    // url, assetPath,
  } //image picker

  // String? isEmpty;
  // void onSelected(String isEmpty) {
  //   setState(() {
  //     isEmpty = "공란";
  //   });
  // }

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
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  getImagePickerData();
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffCCCCCC))),
                  height: 60,
                  width: 60,
                  child: file != null
                      ? Image.file(File(file!.path))
                      : Icon(Icons.photo_camera),
                  // final fileObject = File(xFile!.path);
                  // Image.file(fileObject);
                ),
              ),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      const SizedBox(height: 20),
                      InputInfo(null, 1,
                          title: '제목',
                          hinttext: '도와줄 수 있는 내용을 입력해주세요.',
                          control: controllTitle),
                      const SizedBox(height: 20),
                      InputInfo('', 1,
                          title: '가격',
                          hinttext: '제공할 재능 이용원의 가격을 적어주세요.',
                          control: controllPrice),
                      const SizedBox(height: 20),
                      InputInfo(null, 3,
                          title: '상세설명',
                          hinttext: '제공할 재능의 상세 내용을 적어주세요',
                          control: controllText),
                    ],
                  ),
                ),
              ),
              //TODO GESTUREDETECTOR JSON 파일에 등록
              //give screen 데이터 호출 및 상태 등록
              // 그 상태를 add 하여 변경
              Center(
                  child: Container(
                width: double.infinity,

                ///TODO WIDGET으로 모듈화
                child: ElevatedButton(
                  onPressed: () async {
                    // final formKeyState = _formKey.currentState!;
                    // if (formKeyState.validate()) {
                    //   formKeyState.save();
                    // }
                    if (_formKey.currentState!.validate()) {}

                    if (file != null)
                      await showCupertinoDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          title: Container(
                              width: 100,
                              height: 100,
                              child: Image.file(File(file!.path))),
                          content: Text(
                              '재능기부 등록하시겠습니까?\n제목: ${controllTitle.text}\n가격: ${controllPrice.text}원'),
                          actions: [
                            CupertinoDialogAction(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "뒤로가기",
                                style: TextStyle(color: AppColors.black),
                              ),
                            ),
                            CupertinoDialogAction(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "작성하기",
                                style: TextStyle(color: AppColors.darkGreen),
                              ),
                            ),
                          ],
                        ),
                      );
                  },
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
}

//shared_preferences -핸드폰내부로 저장 할 수 있도록
//json decode return map key dynamic rpg 게임에서 파일 저장하도록
//상태관리 data어떻게 불러 와서 어떻게&어디서(목록위치) 관리할지? 문의→ 신혜원님
// 등록하기에서 json 바로 수정하면 홈페이지 동기화 반영이 안됨.(새로고침, 데이터 동기화 되게 구조를 짜거나?)

//json place holder json 형식들 정리되어있음.
