import 'package:solitaire/models/playing_card.dart';

enum PositionOnScreen { bottom, right, left, top }

class PlayerInfo {
  String avatarPath;
  int age;
  int wins;
  int losses;
  double avgScore;
  int id;
  String name = "";
  PlayerInfo({
    this.avatarPath = "",
    this.age = 18,
    this.wins = 0,
    this.losses = 0,
    this.avgScore = 0.0,
  });
}

class Player {
  List<PlayingCard> cards = [];
  List<PlayingCard> openCards = [];
  PlayingCard extraCard;
  PositionOnScreen position;
  PlayerInfo personalInfo;
  Player(this.position, {this.personalInfo});

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

  void initialize() {
    cards = [];
    openCards = [];
  }

  String get name {
    return this.personalInfo.name;
  }
}
