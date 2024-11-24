import 'package:flutter/material.dart';
import 'package:help_me/screens/give/give_submit.dart';

class GiveScreen extends StatelessWidget {
  const GiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final number = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13];

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              child: Text(
                '재능기부',
                style: TextStyle(fontSize: 30),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 560,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.white),
                child: ListView(
                    children: number.map((int num) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Colors.grey[300]!))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.yard),
                        Column(
                          children: [Text('베이킹 가르쳐 드립니다'), Text('${num}0,000')],
                        ),
                      ],
                    ),
                  );
                }).toList()),
              ),
            ),
            SizedBox(
              height: 70,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return GiveSubmit();
        }));
      }),
    );
  }
}
