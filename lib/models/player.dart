import 'package:konkan/models/base_entity.dart';
import 'package:konkan/models/playing_card.dart';
import 'package:konkan/utils/enums.dart';
import 'package:konkan/utils/player_util.dart';

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

  double setCards(double settingScore) {
    if (!hasSetCards()) {
      if (extraCard != null) {
        return _firstTime(settingScore);
      }
    } else {
      _afterFirstTime(settingScore);
    }
    return settingScore;
  }

  double _firstTime(double settingScore) {
    if (extraCard == null) {
      print("you need to draw a card from discarded deck to set");
      return settingScore;
    }
    List<List<PlayingCard>> groups;
    groups = PlayerUtil.getOptimalGroups(cards);
    double settingRes = PlayerUtil.getGroupScore(groups);
    if (settingRes < settingScore) {
      print("Your score is not enough");
      return settingScore;
    }
    if (groups.expand((i) => i).toList().length == cards.length) {
      print("you need to have at least a card left");
      return settingScore;
    }
    if (groups.expand((i) => i).toList().contains(extraCard)) {
      this.eligibleToDraw = false;
      this.extraCard = null;
      this.discarded = false;
    } else {
      print("You didn't use the card from discarded deck");
      return settingScore;
    }
    openCards = groups
      ..forEach((element) {
        element
          ..forEach((element2) {
            if (element2 != null) {
              element2
                ..faceUp = true
                ..opened = true
                ..isDraggable = false;
            }
          });
      });
    this._delCardsFromMain(groups.expand((element) => element).toList());
    return settingRes;
  }

  // todo make a function that transfers cards from cards to openCards
  // todo test not only grouping but also melding to identify winning
  void _afterFirstTime(double settingScore) {
    List<List<PlayingCard>> groups;
    groups = PlayerUtil.getOptimalGroups(cards);
    if (extraCard != null) {
      if (groups.expand((i) => i).toList().length < 1) {
        print("You have nothing to set");
        return;
      }
      if (groups.expand((i) => i).toList().length == cards.length) {
        print("you need to have at least a card left");
        return;
      }
      if (groups.expand((i) => i).toList().contains(extraCard)) {
        this.eligibleToDraw = false;
        this.extraCard = null;
        this.discarded = false;
      }
    } else {
      if (!this.eligibleToDraw) {
        if (groups.expand((i) => i).toList().length == cards.length) {
          print("you need to have at least a card left");
          return;
        }
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

  bool endTurn() {
    if (this.extraCard != null) {
      return false;
    }
    this.discarded = true;
    this.eligibleToDraw = false;
    return true;
  }

  bool hasSetCards() {
    return openCards.expand((i) => i).toList().length > 0;
  }

  int numSetCards() {
    return openCards.expand((i) => i).toList().length;
  }
}
