import 'package:solitaire/models/playing_card.dart';

enum PositionOnScreen { bottom, right, left, top }

class PlayerInfo {
  String avatarPath;
  int age;
  int wins;
  int losses;
  double avgScore;
  int id;
  String name;
  PlayerInfo(
      {this.avatarPath = "",
      this.age = 18,
      this.wins = 0,
      this.losses = 0,
      this.avgScore = 0.0,
      this.id = 999999,
      this.name = 'P'});

  set playerName(String newName) {
    this.name = newName;
  }

  String get playerName {
    return this.name;
  }
}

class Player {
  List<PlayingCard> cards = [];
  List<PlayingCard> openCards = [];
  PlayingCard extraCard;
  PositionOnScreen position;
  PlayerInfo personalInfo = new PlayerInfo();
  Player(this.position);

  void recordGame(int score, bool won) {
    personalInfo.avgScore =
        personalInfo.avgScore * (personalInfo.wins + personalInfo.losses);
    if (won) {
      personalInfo.wins += 1;
    } else {
      personalInfo.wins += 1;
    }
    personalInfo.avgScore = (personalInfo.avgScore + score) /
        (personalInfo.wins + personalInfo.losses);
  }

  void initialize(String name) {
    cards = [];
    openCards = [];
    this.name = name;
  }

  set name(var newName) {
    this.personalInfo.playerName = newName;
  }

  String get name {
    return this.personalInfo.playerName;
  }
}
