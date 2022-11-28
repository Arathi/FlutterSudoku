import 'dart:math';

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  Widget buildBody() {
    return Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            print("点击开始");
          },
          child: Text("开始")
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            print("点击设置");
          },
          child: Text("设置")
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            print("点击退出");
          },
          child: Text("退出")
        ),
      ]
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildBody()
    );
  }
}

class GamePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
  // 边框颜色
  Color outterFrameColor = Colors.black;
  Color innerFrameColor = Colors.grey;

  // 单元格背景颜色
  Color cellBGColorNormal = Colors.white;
  Color cellBGColorError = Color.fromARGB(255, 255, 118, 164);
  Color cellSelectedColor = Colors.blue;
  Color cellSelectedCRColor = Color.fromARGB(255, 136, 201, 255);
  
  // 单元格文本颜色
  Color cellTextColorNormal = Colors.black;
  Color cellTextColorError = Colors.red;

  int? selectedX = 4;
  int? selectedY = 6;

  Widget buildSudokuCell(double size, int x, int y) {
    int value = Random().nextInt(20);
    String cellText = "";
    if (value >= 1 && value <= 9) {
      cellText = value.toString();
    }

    Color? bgColor;
    if (selectedX == x && selectedY == y) {
      bgColor = cellSelectedColor;
    }
    else if (selectedX == x || selectedY == y) {
      bgColor = cellSelectedCRColor;
    }
    else {
      bgColor = cellBGColorNormal;
    }

    return Container(
      color: bgColor,
      child: SizedBox(width: size, height: size, child: Center(child: Text(
        cellText,
        style: TextStyle(
          fontSize: size * 0.75
        ),
      ))),
    );
  }

  Widget buildSudokuRow(double cellSize, int row) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.start,
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(color: outterFrameColor, child: SizedBox(width: 2, height: cellSize)),
        buildSudokuCell(cellSize, 0, row),
        Container(color: innerFrameColor, child: SizedBox(width: 1, height: cellSize)),
        buildSudokuCell(cellSize, 1, row),
        Container(color: innerFrameColor, child: SizedBox(width: 1, height: cellSize)),
        buildSudokuCell(cellSize, 2, row),
        Container(color: outterFrameColor, child: SizedBox(width: 2, height: cellSize)),
        buildSudokuCell(cellSize, 3, row),
        Container(color: innerFrameColor, child: SizedBox(width: 1, height: cellSize)),
        buildSudokuCell(cellSize, 4, row),
        Container(color: innerFrameColor, child: SizedBox(width: 1, height: cellSize)),
        buildSudokuCell(cellSize, 5, row),
        Container(color: outterFrameColor, child: SizedBox(width: 2, height: cellSize)),
        buildSudokuCell(cellSize, 6, row),
        Container(color: innerFrameColor, child: SizedBox(width: 1, height: cellSize)),
        buildSudokuCell(cellSize, 7, row),
        Container(color: innerFrameColor, child: SizedBox(width: 1, height: cellSize)),
        buildSudokuCell(cellSize, 8, row),
        Container(color: outterFrameColor, child: SizedBox(width: 2, height: cellSize)),
      ]
    );
  }

  Widget buildSudokuGrid({
      double cellSize = 64
    }) {
    double gridSize = 9 * cellSize + 4 * 2 + 6.0;

    Widget hFrame = Container(color: outterFrameColor, child: SizedBox(width: gridSize, height: 2));
    Widget hDivider = Row(children: [
      Container(color: outterFrameColor, child: const SizedBox(width: 2, height: 1)),
      Container(color: innerFrameColor, child: SizedBox(width: 3*cellSize + 2.0, height: 1)),
      Container(color: outterFrameColor, child: const SizedBox(width: 2, height: 1)),
      Container(color: innerFrameColor, child: SizedBox(width: 3*cellSize + 2.0, height: 1)),
      Container(color: outterFrameColor, child: const SizedBox(width: 2, height: 1)),
      Container(color: innerFrameColor, child: SizedBox(width: 3*cellSize + 2.0, height: 1)),
      Container(color: outterFrameColor, child: const SizedBox(width: 2, height: 1)),
    ]);
    
    return Column(
      children: [
        hFrame,
        buildSudokuRow(cellSize, 0),
        hDivider,
        buildSudokuRow(cellSize, 1),
        hDivider,
        buildSudokuRow(cellSize, 2),
        hFrame,
        buildSudokuRow(cellSize, 3),
        hDivider,
        buildSudokuRow(cellSize, 4),
        hDivider,
        buildSudokuRow(cellSize, 5),
        hFrame,
        buildSudokuRow(cellSize, 6),
        hDivider,
        buildSudokuRow(cellSize, 7),
        hDivider,
        buildSudokuRow(cellSize, 8),
        hFrame,
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    // Size? contextSize = context.size;
    bool landscape = true;
    // if (contextSize != null) {
    //   print("窗口尺寸：${contextSize.width}x${contextSize.height}");
    //   if (contextSize.width < contextSize.height) {
    //     landscape = false;
    //   }
    // }
    
    Widget? body = null;
    if (landscape) {
      // 横屏模式
      body = Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3), 
            child: buildSudokuGrid()
          )
        ],
      );
    }
    else {
      // 竖屏模式
      body = Column();
    }

    return Scaffold(
      body: body
    );
  }
}

class SettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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
      theme: ThemeData(primarySwatch: Colors.blue),
      home: page
    );
  }
}

void main() {
  runApp(SudokuApp());
}
