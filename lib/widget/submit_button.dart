import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:help_me/constant/colors.dart';
import 'package:help_me/widget/textfiled.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({
    super.key,
    required this.file,
    required this.controllTitle,
    required this.controllPrice,
  });

  final XFile? file;
  final TextEditingController controllTitle;
  final TextEditingController controllPrice;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      width: double.infinity,

      ///TODO WIDGET으로 모듈화
      child: ElevatedButton(
        onPressed: () async {
          // if(controllTitle==null){
          //   await
          // }
          showCupertinoDialog(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: Container(
                  width: 100, height: 100, child: Image.file(File(file!.path))),
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
    ));
  }
}
