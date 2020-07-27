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
      result = _cardTypeToPenalty(cards[i].cardType);
    }
    return result;
  }

  double _cardTypeToPenalty(CardType cardType) {
    switch (cardType) {
      case CardType.one:
        return 11;
      case CardType.two:
        return 2;
      case CardType.three:
        return 3;
      case CardType.four:
        return 4;
      case CardType.five:
        return 5;
      case CardType.six:
        return 6;
      case CardType.seven:
        return 7;
      case CardType.eight:
        return 8;
      case CardType.nine:
        return 9;
      case CardType.ten:
        return 10;
      case CardType.jack:
        return 10;
      case CardType.queen:
        return 10;
      case CardType.king:
        return 10;
      default:
        return 0;
    }
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
