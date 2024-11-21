import 'package:flutter/material.dart';
import 'package:help_me/screens/helpme/help_me_screen.dart';
import 'package:help_me/screens/helpyou/help_you_screen.dart';
import 'package:help_me/screens/mypage/mypage_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Help-me',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> title = [Text("도와줄게"), Text("도와줘"), Text("마이페이지")];

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: IndexedStack(index: _selectedIndex, children: title),
        centerTitle: true,
      ),
      body: IndexedStack(index: _selectedIndex, children: [
        HelpYouScreen(),
        HelpMeScreen(),
        MypageScreen(),
      ]),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.list), label: '도와줄게'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '도와줘'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_2_outlined), label: '마이페이지'),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
