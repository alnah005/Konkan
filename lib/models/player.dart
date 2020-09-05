import 'package:solitaire/models/base_entity.dart';
import 'package:solitaire/models/playing_card.dart';
import 'package:solitaire/utils/enums.dart';
import 'package:solitaire/utils/player_util.dart';

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

class Player extends BaseEntity {
  List<List<PlayingCard>> openCards = [[]];
  PlayingCard extraCard;
  PlayerInfo personalInfo = new PlayerInfo();
  Player(CardList identifier, {this.isAI = false})
      : super(
          identifier,
        ) {
    if (this.isAI) {}
  }
  bool discarded = true;
  bool eligibleToDraw = true;
  bool isAI = false;
  bool isCurrentPlayer = false;
  bool mustSetCards = false;

  void recordGame(CardList winnerPosition) {
    personalInfo.avgScore =
        personalInfo.avgScore * (personalInfo.wins + personalInfo.losses);
    if (winnerPosition == this.identifier) {
      personalInfo.wins += 1;
    } else {
      personalInfo.losses += 1;
    }
    personalInfo.avgScore =
        (personalInfo.avgScore + PlayerUtil.getPenalty(cards)) /
            (personalInfo.wins + personalInfo.losses);
  }

  void initialize(String name) {
    this.cards.clear();
    this.openCards.clear();
    this.cards = [];
    this.openCards = [[]];
    this.name = name;
  }

  set name(var newName) {
    this.personalInfo.playerName = newName;
  }

  String get name {
    return this.personalInfo.playerName;
  }

  double setCards(double settingScore, [PlayingCard extraCard]) {
    if (hasSetCards()) {
      return _firstTime(settingScore, extraCard);
    }
    return _afterFirstTime(settingScore, extraCard);
  }

  // todo make a function that transfers cards from cards to openCards
  // todo test not only grouping but also melding to identify winning
  // todo draw card from discarded deck into places other than end of cards
  double _afterFirstTime(double settingScore, PlayingCard extraCard) {
    List<List<PlayingCard>> groups;
    if (extraCard != null) {
      groups = PlayerUtil.getOptimalGroups(cards + [extraCard]);
      if (groups.expand((i) => i).toList().length < 1) {
        print("You have nothing to set");
        return settingScore;
      }
    } else {
      groups = PlayerUtil.getOptimalGroups(cards);
    }
    if (extraCard != null) {
      if (groups.expand((i) => i).toList().contains(extraCard)) {
        this.eligibleToDraw = false;
      }
    }
    for (int i = 0; i < groups.length; i++) {
      if (groups.expand((i) => i).toList().length > 0) {
        openCards.add(groups[i]
          ..forEach((element) {
            element
              ..faceUp = true
              ..opened = true
              ..isDraggable = false;
          }));
      }
    }
    this._delCardsFromMain(groups.expand((element) => element).toList());
    return settingScore;
  }

  double _firstTime(double settingScore, PlayingCard extraCard) {
    List<List<PlayingCard>> groups;
    bool setSuccessful = false;
    if (extraCard != null) {
      groups = PlayerUtil.getOptimalGroups(cards + [extraCard]);
      if (groups.expand((i) => i).toList().length == (cards.length)) {
        print("You have won");
        setSuccessful = true;
      }
    } else {
      groups = PlayerUtil.getOptimalGroups(cards);
      if (groups.expand((i) => i).toList().length == (cards.length - 1)) {
        print("You have won");
        setSuccessful = true;
      }
    }
    double settingRes = PlayerUtil.getGroupScore(groups);
    if (setSuccessful) {
      openCards = groups
        ..forEach((element) {
          element
            ..forEach((element2) {
              element2
                ..faceUp = true
                ..opened = true
                ..isDraggable = false;
            });
        });
      this._delCardsFromMain(groups.expand((element) => element).toList());
      return settingRes;
    }
    if (!setSuccessful && !(extraCard != null)) {
      print("draw a card you have not won");
      return settingScore;
    }
    if (settingRes >= settingScore) {
      if (groups.expand((i) => i).toList().contains(extraCard)) {
        this.eligibleToDraw = false;
        openCards = groups
          ..forEach((element) {
            element
              ..forEach((element2) {
                element2
                  ..faceUp = true
                  ..opened = true
                  ..isDraggable = false;
              });
          });
        this._delCardsFromMain(groups.expand((element) => element).toList());
        print("new set score is " + settingRes.toString());
        setSuccessful = true;
      } else {
        print("you didn't use the discarded drawn card");
        this.eligibleToDraw = true;
        setSuccessful = false;
      }
    } else {
      print("your set score is not enough");
      this.eligibleToDraw = true;
      setSuccessful = false;
    }
    if (setSuccessful) {
      return settingRes;
    }
    return settingScore;
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
    this.isCurrentPlayer = true;
  }

  bool endTurn() {
    if (this.mustSetCards) {
      return false;
    }
    this.discarded = true;
    this.eligibleToDraw = false;
    this.isCurrentPlayer = false;
    return true;
  }

  bool hasSetCards() {
    return openCards.expand((i) => i).toList().length == 0;
  }
}
