import 'package:solitaire/models/groups.dart';
import 'package:solitaire/models/meld.dart';
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
    personalInfo.avgScore = (personalInfo.avgScore + _getPenalty(cards)) /
        (personalInfo.wins + personalInfo.losses);
  }

  double _getPenalty(List<PlayingCard> cardsList) {
    double result = 0.0;
    for (int i = 0; i < cardsList.length; i++) {
      result += cardsList[i].penaltyVal;
    }
    return result;
  }

  double _getScore(List<PlayingCard> cardsList) {
    var melds = validate(cardsList);
    if (melds.length > 0) {
      return melds[0].penalty.ceilToDouble();
    }
    return 0;
  }

  void initialize(String name) {
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
    if (openCards.expand((i) => i).toList().length == 0) {
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
      groups = _getOptimalGroups(cards + [extraCard]);
      if (groups.expand((i) => i).toList().length < 1) {
        print("You have nothing to set");
        return settingScore;
      }
    } else {
      groups = _getOptimalGroups(cards);
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
              ..isDraggable = true;
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
      groups = _getOptimalGroups(cards + [extraCard]);
      if (groups.expand((i) => i).toList().length == (cards.length)) {
        print("You have won");
        setSuccessful = true;
      }
    } else {
      groups = _getOptimalGroups(cards);
      if (groups.expand((i) => i).toList().length == (cards.length - 1)) {
        print("You have won");
        setSuccessful = true;
      }
    }
    double settingRes = _getGroupScore(groups);
    if (setSuccessful) {
      openCards = groups
        ..forEach((element) {
          element
            ..forEach((element2) {
              element2
                ..faceUp = true
                ..opened = true
                ..isDraggable = true;
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
                  ..isDraggable = true;
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

  double _getGroupScore(List<List<PlayingCard>> groups) {
    double settingRes = 0;
    for (int i = 0; i < groups.length; i++) {
      settingRes += _getScore(groups[i]);
    }
    return settingRes;
  }

  List<List<PlayingCard>> _getGroups(List<PlayingCard> settingCards) {
    List<List<PlayingCard>> result = [];
    if (settingCards.length < 2) {
      return [[]];
    }
    int beginIndex = 0;
    int lastElement = settingCards.length;
    while (beginIndex + 2 < lastElement) {
      int groupIndex = beginIndex + 3;
      bool groupIsValid =
          _checkIfValid(settingCards.getRange(beginIndex, groupIndex).toList());
      while (groupIsValid && groupIndex < lastElement) {
        groupIndex += 1;
        groupIsValid = _checkIfValid(
            settingCards.getRange(beginIndex, groupIndex).toList());
      }
      // last element in list
      if (groupIsValid) {
        result.add(settingCards.sublist(beginIndex, groupIndex));
      } else {
        groupIsValid = _checkIfValid(
            settingCards.getRange(beginIndex, groupIndex - 1).toList());
        if (groupIsValid) {
          result.add(settingCards.sublist(beginIndex, groupIndex - 1));
        }
      }
      // restart grouping from index of last group
      if (groupIsValid) {
        beginIndex = groupIndex - 1;
      } else {
        beginIndex += 1;
      }
    }
    if (result.length == 0) {
      return [[]];
    }
    return result;
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

  bool _checkIfValid(List<PlayingCard> list) {
    List<MeldClass> melds = validate(list);
    if (melds.length == 0) {
      return false;
    }
    return true;
  }

  /*
  This method check groups from left to right
  Then it checks groups from right to left
  Then it calculates the overlap between the groups
  and picks groups that have a higher score.
  if combining left and right groups gives a higher
  score, the groups that gave that score are returned,
  otherwise the higher between the left and right groups
  is returned instead
   */
  List<List<PlayingCard>> _getOptimalGroups(List<PlayingCard> settingCards) {
    if (settingCards.length < 3) {
      return [[]];
    }

    // begin generating groups from left to right and right to left
    List<List<PlayingCard>> result = [];
    List<List<PlayingCard>> leftGroups = _getGroups(settingCards);
    List<PlayingCard> reversedSettingCards =
        List.from(settingCards).reversed.toList().cast<PlayingCard>();
    List<List<PlayingCard>> rightGroups = _getGroups(reversedSettingCards);
    List<List<int>> leftRange = _getRangeFromGroups(leftGroups, settingCards);
    List<List<int>> rightRange =
        _getRangeFromGroups(rightGroups, reversedSettingCards);

    // fix the range because of reversing cards
    for (int i = 0; i < rightRange.length; i++) {
      rightRange[i] = rightRange[i].reversed.toList().cast<int>();
      rightRange[i] = [
        settingCards.length - rightRange[i][0],
        settingCards.length - rightRange[i][1]
      ];
    }
    // end generating groups from left to right and right to left

    // begin combining left and right groups
    var left = new List<int>.generate(leftRange.length, (i) => i);
    var right = new List<int>.generate(rightRange.length, (i) => i);
    int i = 0;
    int j = 0;
    while (true) {
      bool finishedGroup = true;
      if (i >= left.length) {
        break;
      }
      while (finishedGroup) {
        if (j >= right.length) {
          finishedGroup = false;
          j = 0;
          continue;
        }
        if (rangeCollision(leftRange[left[i]], rightRange[right[j]])) {
          if (_getScore(leftGroups[left[i]]) >
              _getScore(rightGroups[right[j]])) {
            right.removeAt(j);
          } else {
            left.removeAt(i);
            j = 0;
            if (i >= left.length) {
              break;
            }
          }
        } else {
          j += 1;
        }
      }
      i += 1;
    }
    // end combining left and right groups
    left.forEach((element) {
      result.add(leftGroups[element]);
    });
    right.forEach((element) {
      // fix the cards because of reversing cards
      result.add(rightGroups[element].reversed.toList().cast<PlayingCard>());
    });
    double leftScore = _getGroupScore(leftGroups);
    double rightScore = _getGroupScore(rightGroups);
    double combined = _getGroupScore(result);
    if (leftScore > combined) {
      if (leftScore > rightScore) {
        return leftGroups;
      }
    }
    {
      if (rightScore > combined) {
        return rightGroups;
      }
    }
    if (result.length < 1) {
      return [[]];
    }
    return result;
  }

  /*
  Example:
      If you have A J J J 2 2 2 K
      This method returns
      [[1,4],[4,7]]
      which are the range of
      JJJ [1,4)
      and 222 [4, 7)
      respectively
   */
  List<List<int>> _getRangeFromGroups(
      List<List<PlayingCard>> groups, List<PlayingCard> cards) {
    List<List<int>> result = [];
    int iterator = 0;
    int i = 0;
    int j = 0;
    while (iterator < cards.length) {
      if (i < groups.length && j >= groups[i].length) {
        j = 0;
        i += 1;
      }
      if (i >= groups.length) {
        break;
      }
      if (cards[iterator] == groups[i][j]) {
        result.add([iterator, iterator + groups[i].length]);
        iterator += groups[i].length;
        i += 1;
        j = 0;
      } else {
        iterator += 1;
      }
    }
    return result;
  }

  /*
  This method checks if two range list values overlap
  Example:
      A A JKR J J
      for A A JKR your range is [0,3)
      for JKR J J your range is [2,5)
      which overlap
   */
  bool rangeCollision(List<int> group1, List<int> group2) {
    if (group1[0] == group2[0]) {
      return true;
    }
    if (group1[0] < group2[0]) {
      if (group1[1] >= group2[0]) {
        return true;
      }
    } else {
      if (group2[1] >= group1[0]) {
        return true;
      }
    }
    return false;
  }
}
