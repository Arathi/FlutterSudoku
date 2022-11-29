import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sudoku/utils/sudoku.dart';

class GamePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => GamePageState();
}

enum InputMode {
  Value,
  Note,
}

class GamePageState extends State<GamePage> {
  // 边框颜色
  Color outterFrameColor = const Color(0xFF344861);
  Color innerFrameColor = const Color(0xFFCBD0DC);

  // 单元格背景颜色
  Color cellBGColorNormal = Colors.white;
  Color cellBGColorError = const Color(0xFFF7CFD6);
  Color cellBGColorSameValue = const Color(0xFFC3D7EA);

  // 选中单元格颜色
  Color cellSelectedColor = const Color(0xFFC3D7EA);
  Color cellSelectedCRColor = const Color(0xFFE2EBF3);

  // 单元格文本颜色
  Color cellTextColorNormal = const Color(0xFF344861);
  Color cellTextColorMutable = const Color(0xFF0072E3);
  Color cellTextColorError = const Color(0xFFE55C6C);
  Color cellTextColorNotes = Colors.grey;

  late Sudoku sudoku;

  int selectedX = 0;
  int selectedY = 0;
  int selectedValue = 0;
  InputMode inputMode = InputMode.Value;

  @override
  void initState() {
    print("正在初始化");
    sudoku = Sudoku.strings(
      "000370400080429000000001002006000075200700069050000248800000004031900600040250800",
      "962378451185429736374561982496832175218745369753196248827613594531984627649257813",
    );
  }

  void newGame() {
    print("新游戏");
    setState(() {
      sudoku.reset();
      sudoku.check();
    });
    changeSelectedCell(selectedX, selectedY);
  }

  void changeSelectedCell(int x, int y) {
    setState(() {
      SudokuCell cell = sudoku.getCell(x, y);
      selectedX = x;
      selectedY = y;
      selectedValue = cell.value;
    });
  }

  void setValue(int x, int y, int value) {
    setState(() {
      sudoku.setValue(x, y, value);
      if (selectedX == x && selectedY == y) {
        selectedValue = value;
      }

      if (sudoku.check() == Sudoku.size * Sudoku.size) {
        print("完成！");
      }
    });
  }

  void setNote(int x, int y, int note) {
    setState(() => sudoku.setNote(x, y, note));
  }

  void fillNotes() {
    print("开始填充备注");
    setState(() => sudoku.fillNotes());
    print("备注填充完成");
  }

  void fillSingleNoteCells() {
    print("检查单备注单元格");
    int fillCount = 0;
    setState(() {
      fillCount = sudoku.fillSingleNoteCells();
      if (sudoku.check() == Sudoku.size * Sudoku.size) {
        print("完成！");
      }
    });
    print("填充$fillCount个单元格");
  }

  Widget buildSudokuCell(double size, int x, int y) {
    // int value = Random().nextInt(20);
    SudokuCell cell = sudoku.getCell(x, y);
    String cellText = cell.text;

    Color? bgColor;
    Color? textColor;

    // 背景颜色
    if (selectedX == x && selectedY == y) {
      bgColor = cellSelectedColor;
    } else if (selectedX == x ||
        selectedY == y ||
        (selectedX ~/ 3 == x ~/ 3 && selectedY ~/ 3 == y ~/ 3)) {
      bgColor = cellSelectedCRColor;
    } else {
      bgColor = cellBGColorNormal;
    }
    if (cell.value != 0 && cell.value == selectedValue) {
      bgColor = cellBGColorSameValue;
    }
    if (!cell.mutable && cell.error) {
      bgColor = cellBGColorError;
    }

    // 文本颜色
    if (cell.mutable) {
      textColor = cell.error ? cellTextColorError : cellTextColorMutable;
    } else {
      textColor = cellTextColorNormal;
    }

    Widget? cellContent;
    if (cellText.length == 1) {
      cellContent = Text(
        cellText,
        style: TextStyle(color: textColor, fontSize: size * 0.75),
      );
    } else {
      List<Widget> children = <Widget>[];
      for (int i = 1; i <= 9; i++) {
        String noteText = " ";
        if (cell.notes.containsKey(i) && cell.notes[i]!) {
          noteText = "$i";
        }
        children.add(Center(
            child: Text(
          noteText,
          style: TextStyle(color: cellTextColorNotes, fontSize: size * 0.25),
        )));
      }
      cellContent = GridView.count(
        crossAxisCount: 3,
        children: children,
      );
    }

    return GestureDetector(
        onTap: () {
          print("当前选中单元格：($x, $y)");
          changeSelectedCell(x, y);
        },
        child: Container(
          color: bgColor,
          child: SizedBox(
            width: size,
            height: size,
            child: Center(child: cellContent),
          ),
        ));
  }

  Widget buildSudokuRow(double cellSize, int row) {
    return Row(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              color: outterFrameColor,
              child: SizedBox(width: 2, height: cellSize)),
          buildSudokuCell(cellSize, 0, row),
          Container(
              color: innerFrameColor,
              child: SizedBox(width: 1, height: cellSize)),
          buildSudokuCell(cellSize, 1, row),
          Container(
              color: innerFrameColor,
              child: SizedBox(width: 1, height: cellSize)),
          buildSudokuCell(cellSize, 2, row),
          Container(
              color: outterFrameColor,
              child: SizedBox(width: 2, height: cellSize)),
          buildSudokuCell(cellSize, 3, row),
          Container(
              color: innerFrameColor,
              child: SizedBox(width: 1, height: cellSize)),
          buildSudokuCell(cellSize, 4, row),
          Container(
              color: innerFrameColor,
              child: SizedBox(width: 1, height: cellSize)),
          buildSudokuCell(cellSize, 5, row),
          Container(
              color: outterFrameColor,
              child: SizedBox(width: 2, height: cellSize)),
          buildSudokuCell(cellSize, 6, row),
          Container(
              color: innerFrameColor,
              child: SizedBox(width: 1, height: cellSize)),
          buildSudokuCell(cellSize, 7, row),
          Container(
              color: innerFrameColor,
              child: SizedBox(width: 1, height: cellSize)),
          buildSudokuCell(cellSize, 8, row),
          Container(
              color: outterFrameColor,
              child: SizedBox(width: 2, height: cellSize)),
        ]);
  }

  Widget buildSudokuGrid({double cellSize = 64}) {
    double gridSize = 9 * cellSize + 4 * 2 + 6.0;

    Widget hFrame = Container(
        color: outterFrameColor, child: SizedBox(width: gridSize, height: 2));
    Widget hDivider = Row(children: [
      Container(
          color: outterFrameColor, child: const SizedBox(width: 2, height: 1)),
      Container(
          color: innerFrameColor,
          child: SizedBox(width: 3 * cellSize + 2.0, height: 1)),
      Container(
          color: outterFrameColor, child: const SizedBox(width: 2, height: 1)),
      Container(
          color: innerFrameColor,
          child: SizedBox(width: 3 * cellSize + 2.0, height: 1)),
      Container(
          color: outterFrameColor, child: const SizedBox(width: 2, height: 1)),
      Container(
          color: innerFrameColor,
          child: SizedBox(width: 3 * cellSize + 2.0, height: 1)),
      Container(
          color: outterFrameColor, child: const SizedBox(width: 2, height: 1)),
    ]);

    return Column(children: [
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
    ]);
  }

  Widget buildButtons() {
    return Column(
      children: [
        Container(
          child: ElevatedButton(
            onPressed: () {
              print("点击新游戏按钮");
              newGame();
            },
            child: Text("New Game"),
          ),
        )
      ],
    );
  }

  void onKeyDownEvent(String key) {
    print("按下：$key");
    int? value = int.tryParse(key);
    if (value != null) {
      if (inputMode == InputMode.Value) {
        print("设置单元格值($selectedX,$selectedY)=$value");
        setValue(selectedX, selectedY, value);
      } else if (inputMode == InputMode.Note) {
        print("设置单元格注释($selectedX,$selectedY)=$value");
        setNote(selectedX, selectedY, value);
      } else {
        print("无效的输入模式");
      }
    } else {
      switch (key) {
        case "a":
          fillSingleNoteCells();
          break;
        case "f":
          fillNotes();
          break;
        case 'v':
          print("输入模式");
          setState(() => inputMode = InputMode.Value);
          break;
        case "n":
          print("备注模式");
          setState(() => inputMode = InputMode.Note);
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool landscape = true;
    double padding = 3;

    Size? contextSize = MediaQuery.of(context).size;
    if (contextSize != null) {
      print("容器大小：${contextSize.width}x${contextSize.height}");
      if (contextSize.width < contextSize.height) {
        print("竖屏模式，短边（width）长度：${contextSize.width}");
        landscape = false;
      } else {
        print("横屏模式，短边（height）长度：${contextSize.height}");
        landscape = true;
      }
    } else {
      print("无法确认容器大小");
    }

    Widget? body = null;
    if (landscape) {
      // 横屏模式
      body = Row(
        children: [
          Container(padding: EdgeInsets.all(padding), child: buildSudokuGrid()),
          Container(
            padding: EdgeInsets.all(padding),
            child: buildButtons(), // Expanded(child:),
          ),
        ],
      );
    } else {
      // 竖屏模式
      body = Column();
    }

    return RawKeyboardListener(
      focusNode: FocusNode(),
      autofocus: true,
      onKey: (event) {
        if (event.runtimeType == RawKeyDownEvent) {
          if (event.data is RawKeyEventDataWindows) {
            onKeyDownEvent(event.data.keyLabel);
          }
        }
      },
      child: Scaffold(body: body),
    );
  }
}
