import 'package:flutter/material.dart';
import 'package:help_me/screens/give/give_submit.dart';

class GiveScreen extends StatelessWidget {
  const GiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return GiveSubmit();
        }));
      }),
    );
  }
}
