import 'package:flutter/material.dart';

class GiveSubmit extends StatelessWidget {
  const GiveSubmit({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [Text('등록')],
        ),
        body: Column(
          children: [
            Container(
              height: 30,
              width: 30,
              child: Icon(Icons.camera),
            ),
          ],
        ));
  }
}
