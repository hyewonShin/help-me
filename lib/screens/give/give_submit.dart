import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:help_me/constant/colors.dart';
import 'package:help_me/widget/textfield.dart';
import 'package:image_picker/image_picker.dart';
import 'package:help_me/util/load_data_from_document.dart';
import 'package:help_me/util/save_json_to_file.dart';

class GiveSubmit extends StatefulWidget {
  GiveSubmit({required this.submitGiveData, super.key});

  Function submitGiveData;
  @override
  State<GiveSubmit> createState() => _GiveSubmitState();
}

class _GiveSubmitState extends State<GiveSubmit> {
  String? _title;
  String? _price;
  String? _desc;
  XFile? file;
  List<dynamic> giveData = [];
  List<dynamic> newGive = [];
  final _formKey = GlobalKey<FormState>();
  void initState() {
    super.initState();
    setState(() {
      loadData();
    });
  }

  Future<void> loadData() async {
    try {
      final gives = await loadDataFromDocument("give.json");
      setState(() {
        giveData = gives;
      });
    } catch (e) {
      print('데이터 로드 에러: $e');
    }
  }

  void addData() {
    final newGive = {
      "ask_id": giveData.length,
      "user_id": 0,
      "image": file!.path,
      "title": _title,
      "desc": _desc,
      "price": int.parse(_price!.replaceAll(",", ""))
    };
    // 상태 변경 함수
    widget.submitGiveData(newGive);

    // Document 파일에 쓰기
    writeDataToFile(newGive, "give.json");
  }

  Future<void> getImagePickerData() async {
    final imagePicker = ImagePicker();

    final XFile? xFile =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (xFile != null) {
      setState(() {
        file = xFile;
      });
    }
    // url, assetPath,
  } //image picker

  void changeValue(value, title) {
    switch (title) {
      case "제목":
        setState(() {
          _title = value;
        });
      case "가격":
        setState(() {
          _price = value;
        });
      case "상세설명":
        setState(() {
          _desc = value;
        });
    }
  }

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
                //https://blog.everdu.com/83#3.%20%EB%B2%84%ED%8A%BC%EC%9D%84%20%ED%81%B4%EB%A6%AD%EC%8B%9C%20%EC%9C%A0%ED%9A%A8%EC%84%B1%20%EA%B2%80%EC%82%AC%ED%95%98%EA%B8%B0-1
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      const SizedBox(height: 20),
                      InputInfo(null, 1,
                          title: '제목',
                          hinttext: '도와줄 수 있는 내용을 입력해주세요.',
                          data: _title,
                          changeValue: changeValue),
                      const SizedBox(height: 20),
                      InputInfo('', 1,
                          title: '가격',
                          hinttext: '제공할 재능 이용원의 가격을 적어주세요.',
                          data: _price,
                          changeValue: changeValue),
                      const SizedBox(height: 20),
                      InputInfo(null, 10,
                          title: '상세설명',
                          hinttext: '제공할 재능의 상세 내용을 적어주세요',
                          data: _desc,
                          changeValue: changeValue),
                    ],
                  ),
                ),
              ),
              Center(
                  child: Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final formKeyState = _formKey.currentState!;
                    if (formKeyState.validate()) {
                      formKeyState.save();
                    }
                    if (file != null) {
                      formKeyState.validate()
                          ? await showCupertinoDialog(
                              context: context,
                              builder: (context) => CupertinoAlertDialog(
                                title: Container(
                                    width: 100,
                                    height: 100,
                                    child: Image.file(File(file!.path))),
                                content: Text(
                                    '재능기부 등록하시겠습니까?\n제목: ${_title}\n가격: ${_price}원'),
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
                                      addData();
                                    },
                                    child: const Text(
                                      "작성하기",
                                      style:
                                          TextStyle(color: AppColors.darkGreen),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : null;
                    } else {
                      showCupertinoDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                          content: Text('사진을 등록해주세요.'),
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
                          ],
                        ),
                      );
                    }
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
