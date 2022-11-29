import 'package:flutter/foundation.dart';
import 'package:sudoku/utils/sudoku_com_client.dart';

void main() async {
  SudokuComClient client = SudokuComClient();
  Puzzle puzzle = await client.getPuzzle("easy");
  if (kDebugMode) {
    print("编号：${puzzle.id}");
    print("谜题：${puzzle.mission}");
    print("答案：${puzzle.solution}");
    print("完成率：${puzzle.winRate}%");
  }
}
