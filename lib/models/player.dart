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
  List<List<PlayingCard>> openCards = [[]];
  PlayingCard extraCard;
  PositionOnScreen position;
  PlayerInfo personalInfo = new PlayerInfo();
  Player(this.position, {this.isAI = false}) {
    if (this.isAI) {}
  }
  bool discarded = true;
  bool eligibleToDraw = true;
  bool isAI = false;

  void recordGame(PositionOnScreen winnerPosition) {
    personalInfo.avgScore =
        personalInfo.avgScore * (personalInfo.wins + personalInfo.losses);
    if (winnerPosition == this.position) {
      personalInfo.wins += 1;
    } else {
      personalInfo.losses += 1;
    }
    personalInfo.avgScore = (personalInfo.avgScore + _getScore(cards)) /
        (personalInfo.wins + personalInfo.losses);
  }

  double _getScore(List<PlayingCard> cardsList) {
    double result = 0.0;
    for (int i = 0; i < cardsList.length; i++) {
      result += cardsList[i].penaltyVal;
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

  double setCards(double settingScore, [PlayingCard extraCard]) {
    if (openCards.expand((i) => i).toList().length == 0) {
      return _firstTime(settingScore, extraCard);
    }
    return _afterFirstTime(settingScore, extraCard);
  }

  double _afterFirstTime(double settingScore, PlayingCard extraCard) {
    List<List<PlayingCard>> groups;
    if (extraCard != null) {
      groups = _getGroups(cards + [extraCard]);
      if (groups.expand((i) => i).toList().length < 1) {
        print("You have nothing to awt");
        return settingScore;
      }
    } else {
      groups = _getGroups(cards);
    }
    this.eligibleToDraw = false;
    for (int i = 0; i < groups.length; i++) {
      if (groups.expand((i) => i).toList().length > 0) {
        openCards.add(groups[i]);
      }
    }
    this._delCardsFromMain(groups.expand((element) => element).toList());
    return settingScore;
  }

  double _firstTime(double settingScore, PlayingCard extraCard) {
    List<List<PlayingCard>> groups;
    if (extraCard != null) {
      groups = _getGroups(cards + [extraCard]);
    } else {
      groups = _getGroups(cards);
      if (groups.expand((i) => i).toList().length < 15) {
        print("You have not won");
        return settingScore;
      }
    }
    double settingRes = _getGroupScore(groups);
    if (settingRes >= settingScore) {
      openCards = groups;
      this._delCardsFromMain(groups.expand((element) => element).toList());
      print("new set score is " + settingRes.toString());
      this.eligibleToDraw = false;
    } else {
      settingRes = settingScore;
      print("your set score is not enough");
      this.eligibleToDraw = true;
    }
    return settingRes;
  }

  double _getGroupScore(List<List<PlayingCard>> groups) {
    double settingRes = 0;
    for (int i = 0; i < groups.length; i++) {
      settingRes += _getScore(groups[i]);
      print(settingRes.toString());
    }
    return settingRes;
  }

  List<List<PlayingCard>> _getGroups(List<PlayingCard> settingCards) {
    if (settingCards.length < 2) {
      return [[]];
    }
    return [
      [settingCards.first, settingCards.last]
    ];
  }

  void _delCardsFromMain(List<PlayingCard> movedCards) {
    for (int i = 0; i < movedCards.length; i++) {
      if (cards.contains(movedCards[i])) {
        cards.removeAt(cards.indexOf(movedCards[i]));
      }
    }
  }

  void initializeForNextTurn() {
    this.discarded = true;
    this.eligibleToDraw = true;
  }
}
