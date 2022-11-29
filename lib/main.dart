import 'package:flutter/material.dart';
import 'pages/game_page.dart';

class HomePage extends StatelessWidget {
  Widget buildBody() {
    return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      ElevatedButton(
          onPressed: () {
            print("点击开始");
          },
          child: Text("开始")),
      const SizedBox(height: 20),
      ElevatedButton(
          onPressed: () {
            print("点击设置");
          },
          child: Text("设置")),
      const SizedBox(height: 20),
      ElevatedButton(
          onPressed: () {
            print("点击退出");
          },
          child: Text("退出")),
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: buildBody());
  }
}

class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class SudokuApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SudokuAppState();
}

class SudokuAppState extends State<SudokuApp> {
  static const int PAGE_HOME = 0;
  static const int PAGE_GAME = 1;
  static const int PAGE_SETTING = 2;

  int pageId = PAGE_GAME;

  @override
  void initState() {
    print("正在初始化");
    pageId = PAGE_GAME;
  }

  void changePage(int pageId) {
    setState(() {
      this.pageId = pageId;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget? page = null;
    switch (pageId) {
      case 0:
        page = HomePage();
        break;
      case 1:
        page = GamePage();
        break;
      case 2:
        page = SettingPage();
        break;
    }

    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue), home: page);
  }
}

void main() {
  runApp(SudokuApp());
}
