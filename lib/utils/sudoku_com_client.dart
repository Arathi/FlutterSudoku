import 'package:dio/dio.dart';

class Puzzle {
  late int id;
  late String mission;
  late String solution;
  late double winRate;

  Puzzle(this.id, this.mission, this.solution, {this.winRate = 0});

  Puzzle.fromJson(Map<String, dynamic> json) {
    id = json["id"] as int;
    mission = json["mission"] as String;
    solution = json["solution"] as String;
    winRate = json["win_rate"] as double;
  }
}

class SudokuComClient {
  static const String BASE_URL = "https://sudoku.com";

  static const String LEVEL_EASY = "easy";

  Dio dio = Dio();

  Future<Puzzle> getPuzzle(String level) async {
    var url = "$BASE_URL/api/level/$level";
    var resp = await dio.get(url,
        options: Options(headers: <String, dynamic>{
          "x-requested-with": "XMLHttpRequest",
        }));
    var json = resp.data as Map<String, dynamic>;
    return Puzzle.fromJson(json);
  }
}
