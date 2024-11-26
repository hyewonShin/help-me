import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:help_me/constant/colors.dart';
import 'package:help_me/util/load_data_from_document.dart';
import 'package:help_me/util/save_json_to_file.dart';

class AskSubmit extends StatefulWidget {
  const AskSubmit({super.key});

  @override
  State<AskSubmit> createState() => _AskSubmitState();
}

class _AskSubmitState extends State<AskSubmit> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final String? _title;
  late final String? _price;
  late final String? _desc;

  List<dynamic> askData = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      loadData();
    });
  }

  Future<void> loadData() async {
    try {
      final asks = await loadDataFromDocument("ask.json");
      setState(() {
        askData = asks;
      });
    } catch (e) {
      print('데이터 로드 에러: $e');
    }
  }

  void addData() async {
    final newAsk = {
      "ask_id": askData.length,
      "user_id": 0,
      "title": _title,
      "desc": _desc,
      "price": _price
    };

    writeDataToFile(newAsk, "ask.json");
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
            '재능 요청하기',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        '제목',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onSaved: (value) {
                          setState(() {
                            _title = value;
                          });
                        },
                        validator: (String? value) {
                          if (value?.isEmpty ?? true) return '제목을 입력해주세요';
                          return null;
                        },
                        style: TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          errorStyle:
                              TextStyle(color: AppColors.onError, fontSize: 14),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.lightGreen,
                            ),
                          ),
                          hintText: ('도움을 요청할 내용의 제목을 적어주세요.'),
                          hintStyle: TextStyle(
                              color: AppColors.lightGray,
                              fontWeight: FontWeight.bold),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide()), //color: Color borderColor//외곽선
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '사례금',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onSaved: (value) {
                          setState(() {
                            if (value != null) _price = value;
                          });
                        },
                        validator: (String? value) {
                          if (value?.isEmpty ?? true) return '사례금을 입력해주세요.';
                          return null;
                        },
                        style: TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          errorStyle:
                              TextStyle(color: AppColors.onError, fontSize: 14),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.lightGreen,
                            ),
                          ),
                          hintText: ('도움 받게되면 제공할 사례금을 적어주세요.'),
                          hintStyle: TextStyle(
                              color: AppColors.lightGray,
                              fontWeight: FontWeight.bold),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide()), //color: Color borderColor//외곽선
                        ),
                        inputFormatters: [
                          CurrencyTextInputFormatter.currency(
                            locale: 'ko',
                            decimalDigits: 0,
                            symbol: '',
                          ),
                        ],
                        keyboardType: TextInputType.numberWithOptions(),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '상세설명',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      SizedBox(height: 5),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onSaved: (value) {
                          setState(() {
                            _desc = value;
                          });
                        },
                        validator: (String? value) {
                          if (value?.isEmpty ?? true) return '상세설명을 입력해주세요.';
                          return null;
                        },
                        maxLines: 10,
                        style: TextStyle(fontSize: 16),
                        decoration: InputDecoration(
                          errorStyle:
                              TextStyle(color: AppColors.onError, fontSize: 14),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.lightGreen,
                            ),
                          ),
                          hintText: ('도움을 요청할 내용을 적어주세요.'),
                          hintStyle: TextStyle(
                              color: AppColors.lightGray,
                              fontWeight: FontWeight.bold),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide()), //color: Color borderColor//외곽선
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                    child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final formKeyState = _formKey.currentState!;

                      if (formKeyState.validate()) {
                        formKeyState.save();
                      }
                      formKeyState.validate()
                          ? await showCupertinoDialog(
                              context: context,
                              builder: (context) => CupertinoAlertDialog(
                                title: Text('재능 요청 등록하시겠습니까?\n'),
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
                                      addData();
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "작성하기",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 42, 54, 49)),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : null;
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.lightGreen,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Text(
                      '작성완료',
                      style: TextStyle(color: AppColors.white),
                    ),
                  ),
                )),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
