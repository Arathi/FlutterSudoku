import 'sudoku_com_client.dart';

class SudokuUnit {
  static const int size = 3;
  int x;
  int y;
  List<SudokuCell> cells;
  SudokuUnit(this.x, this.y, this.cells);

  Set<int> get errors {
    Set<int> errors = <int>{};
    Map<int, int> firsts = <int, int>{};
    for (SudokuCell cell in cells) {
      if (cell.value >= 1 && cell.value <= 9) {
        if (firsts.containsKey(cell.value)) {
          // 已经出现过
          errors.add(firsts[cell.value]!);
          errors.add(cell.index);
        } else {
          // 未出现过
          firsts[cell.value] = cell.index;
        }
      }
    }
    return errors;
  }

  @override
  String toString() {
    StringBuffer buffer = StringBuffer();
    buffer.writeln("+-------+");
    for (int y = 0; y < size; y++) {
      buffer.write("| ");
      for (int x = 0; x < size; x++) {
        int index = x + y * size;
        SudokuCell cell = cells[index];
        buffer.write("${cell.text} ");
      }
      buffer.writeln("|");
    }
    buffer.writeln("+-------+");
    return buffer.toString();
  }
}

class SudokuCell {
  int value;
  int answer;
  bool mutable;
  int x;
  int y;
  bool error = false;
  Map<int, bool> notes = <int, bool>{};

  String get text {
    // 输出值
    if (value >= 1 && value <= 9) {
      return value.toString();
    }

    // 输出备注
    if (notes.isNotEmpty) {
      StringBuffer buffer = StringBuffer();
      for (int i = 1; i <= 9; i++) {
        if (notes.containsKey(i) && notes[i]!) {
          buffer.write(" $i ");
        } else {
          buffer.write("   ");
        }
        if (i % 3 == 0 && i < 9) {
          buffer.writeln();
        }
      }
      return buffer.toString();
    }

    // 输出空格
    return " ";
  }

  int get index {
    return x + y * Sudoku.size;
  }

  SudokuCell(
    this.value, {
    this.answer = 0,
    this.mutable = true,
    this.x = 0,
    this.y = 0,
  });

  void setNote(int note) {
    if (notes.containsKey(note)) {
      notes[note] = !notes[note]!;
    } else {
      notes[note] = true;
    }
  }

  @override
  String toString() {
    return "cells($x,$y)=$value";
  }
}

class Sudoku {
  static const int size = 9;
  List<SudokuCell> cells = <SudokuCell>[];
  List<SudokuUnit> get units {
    List<SudokuUnit> list = <SudokuUnit>[];
    for (int uy = 0; uy < size / SudokuUnit.size; uy++) {
      for (int ux = 0; ux < size / SudokuUnit.size; ux++) {
        list.add(getUnit(ux, uy));
      }
    }
    return list;
  }

  Set<int> get errors {
    print("开始检查错误");
    var errors = <int>{};
    // 行
    for (int y = 0; y < size; y++) {
      var firsts = <int, int>{};
      for (int x = 0; x < size; x++) {
        var cell = getCell(x, y);
        if (cell.value >= 1 && cell.value <= 9) {
          if (firsts.containsKey(cell.value)) {
            errors.add(firsts[cell.value]!);
            errors.add(cell.index);
          } else {
            firsts[cell.value] = cell.index;
          }
        }
      }
    }
    // 列
    for (int x = 0; x < size; x++) {
      var firsts = <int, int>{};
      for (int y = 0; y < size; y++) {
        var cell = getCell(x, y);
        if (cell.value >= 1 && cell.value <= 9) {
          if (firsts.containsKey(cell.value)) {
            errors.add(firsts[cell.value]!);
            errors.add(cell.index);
          } else {
            firsts[cell.value] = cell.index;
          }
        }
      }
    }
    // 宫
    for (SudokuUnit unit in units) {
      errors.addAll(unit.errors);
    }
    print("发现${errors.length}个单元格错误");
    return errors;
  }

  Sudoku() {
    for (int index = 0; index < size * size; index++) {
      int x = index % 9;
      int y = index ~/ 9;
      cells.add(SudokuCell(0, x: x, y: y));
    }
  }

  Sudoku.strings(String mission, String solution) {
    for (int index = 0; index < size * size; index++) {
      int value = int.parse(mission[index]);
      int answer = int.parse(solution[index]);
      int x = index % 9;
      int y = index ~/ 9;
      cells.add(SudokuCell(
        value,
        answer: answer,
        mutable: value != answer,
        x: x,
        y: y,
      ));
    }
  }

  Sudoku.puzzle(Puzzle puzzle)
      : this.strings(
          puzzle.mission,
          puzzle.solution,
        );

  void reset() {
    for (var cell in cells) {
      if (cell.mutable) {
        cell.value = 0;
        cell.notes.clear();
      }
    }
  }

  SudokuCell operator [](int index) {
    return cells[index];
  }

  SudokuCell getCell(int x, int y) {
    int index = x + y * size;
    return this[index];
  }

  SudokuUnit getUnit(int ux, int uy) {
    List<SudokuCell> unitCells = <SudokuCell>[];
    for (int uiy = 0; uiy < Sudoku.size / SudokuUnit.size; uiy++) {
      for (int uix = 0; uix < Sudoku.size / SudokuUnit.size; uix++) {
        int x = ux * SudokuUnit.size + uix;
        int y = uy * SudokuUnit.size + uiy;
        SudokuCell cell = getCell(x, y);
        unitCells.add(cell);
      }
    }
    return SudokuUnit(ux, uy, unitCells);
  }

  bool setValue(int x, int y, int value) {
    SudokuCell cell = getCell(x, y);
    if (cell.mutable) {
      cell.value = value;
    }
    return false;
  }

  bool setNote(int x, int y, int note) {
    SudokuCell cell = getCell(x, y);
    if (cell.mutable) {
      cell.setNote(note);
    }
    return false;
  }

  void fillNotes() {
    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        SudokuCell cell = getCell(x, y);
        if (cell.value == 0) {
          fillNote(cell);
        }
      }
    }
  }

  void fillNote(SudokuCell cell) {
    Map<int, bool> notes = <int, bool>{};
    for (int note = 1; note <= 9; note++) {
      notes[note] = true;
    }

    // 行
    for (int x = 0; x < size; x++) {
      var ref = getCell(x, cell.y);
      if (ref.value >= 1 && ref.value <= 9) {
        notes[ref.value] = false;
      }
    }

    // 列
    for (int y = 0; y < size; y++) {
      var ref = getCell(cell.x, y);
      if (ref.value >= 1 && ref.value <= 9) {
        notes[ref.value] = false;
      }
    }

    // 宫
    var unit = getUnit(cell.x ~/ 3, cell.y ~/ 3);
    for (var ref in unit.cells) {
      if (ref.value >= 1 && ref.value <= 9) {
        notes[ref.value] = false;
      }
    }

    cell.notes = notes;
  }

  int fillSingleNoteCells() {
    int fillCount = 0;
    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        var cell = getCell(x, y);
        int noteCount = 0;
        int note = 0;
        if (cell.value == 0) {
          for (var entry in cell.notes.entries) {
            if (entry.value) {
              note = entry.key;
              noteCount++;
            }
          }
          if (noteCount == 1) {
            cell.value = note;
            fillCount++;
          }
        }
      }
    }
    return fillCount;
  }

  int check() {
    int counter = 0;
    for (int index = 0; index < size * size; index++) {
      SudokuCell cell = cells[index];
      cell.error = false;
      if (cell.value >= 1 && cell.value <= 9) {
        counter++;
      }
    }
    for (var index in errors) {
      cells[index].error = true;
      counter--;
    }
    return counter;
  }

  @override
  String toString() {
    StringBuffer buffer = StringBuffer();
    for (int y = 0; y < size; y++) {
      if (y % SudokuUnit.size == 0) {
        buffer.writeln("+-------+-------+-------+");
      }
      for (int x = 0; x < size; x++) {
        SudokuCell cell = getCell(x, y);
        if (x % SudokuUnit.size == 0) {
          buffer.write("| ");
        }
        buffer.write("${cell.text} ");
      }
      buffer.writeln("|");
    }
    buffer.writeln("+-------+-------+-------+");
    return buffer.toString();
  }
}
