import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:help_me/constant/colors.dart';
import 'package:help_me/screens/ask/ask_screen.dart';
import 'package:help_me/screens/give/give_screen.dart';

import 'package:help_me/screens/mypage/mypage_screen.dart';
import 'package:help_me/util/save_json_to_file.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await saveJsonToFile("give.json", "lib/mock_data/give.json");
  await saveJsonToFile("ask.json", "lib/mock_data/ask.json");
  await saveJsonToFile("users.json", "lib/mock_data/users.json");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Help_me',
      theme: ThemeData(
          fontFamily: "Pretendard",
          scaffoldBackgroundColor: AppColors.white,
          appBarTheme: AppBarTheme(color: AppColors.white),
          bottomNavigationBarTheme:
              BottomNavigationBarThemeData(backgroundColor: AppColors.white)),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> title = ["재능기부", "재능요청", "마이페이지"];

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              SvgPicture.asset(
                "assets/images/logo.svg",
                fit: BoxFit.cover,
              )
            ],
          ),
        ),
        body: IndexedStack(index: _selectedIndex, children: [
          GiveScreen(),
          AskScreen(),
          MypageScreen(),
        ]),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: AppColors.lightGreen,
          unselectedItemColor: AppColors.darkGray,
          currentIndex: _selectedIndex,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.list), label: '재능기부'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: '재능요청'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_2_outlined), label: '마이페이지'),
          ],
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ));
  }
}
