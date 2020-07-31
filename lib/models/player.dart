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
  bool discarded = true;

  void recordGame(PositionOnScreen winnerPosition) {
    personalInfo.avgScore =
        personalInfo.avgScore * (personalInfo.wins + personalInfo.losses);
    if (winnerPosition == this.position) {
      personalInfo.wins += 1;
    } else {
      personalInfo.wins += 1;
    }
    personalInfo.avgScore = (personalInfo.avgScore + _getScore()) /
        (personalInfo.wins + personalInfo.losses);
  }

  double _getScore() {
    double result = 0.0;
    for (int i = 0; i < cards.length; i++) {
      result = cards[i].penaltyVal;
    }
    return result;
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

  void setCards(double settingScore) {
    List<List<PlayingCard>> groups = _getGroups();
    for (int i = 0; i < groups.length; i++) {
      for (int j = 0; j < groups[i].length; j++) {
        openCards.add(groups[i][j]);
        cards.removeWhere((element) => element == groups[i][j]);
      }
    }
  }

  List<List<PlayingCard>> _getGroups() {
    if (cards.length < 2) {
      return [[]];
    }
    return [
      [cards.first, cards.last]
    ];
  }
}
