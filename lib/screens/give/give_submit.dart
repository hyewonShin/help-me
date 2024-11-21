import 'package:flutter/material.dart';

class GiveSubmit extends StatelessWidget {
  const GiveSubmit({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Scaffold(
        appBar: AppBar(
          actions: [Text('등록')],
        ),
        body: Column(
          children: [
            Container(
              decoration:
                  BoxDecoration(border: Border.all(color: Color(0xffCCCCCC))),
              height: 50,
              width: 50,
              child: Icon(Icons.photo_camera),
            ),
            Column(
              children: [Text('제목'), TextField()],
            )
          ],
        ),
      ),
    );
  }
}
