import 'package:solitaire/models/playing_card.dart';
import 'package:solitaire/utils/groups.dart';
import 'package:solitaire/utils/meld.dart';

class PlayerUtil {
  static double getScore(List<PlayingCard> cardsList) {
    var melds = validate(cardsList);
    if (melds.length > 0) {
      return melds[0].penalty.ceilToDouble();
    }
    return 0;
  }

  static double getGroupScore(List<List<PlayingCard>> groups) {
    double settingRes = 0;
    for (int i = 0; i < groups.length; i++) {
      settingRes += PlayerUtil.getScore(groups[i]);
    }
    return settingRes;
  }

  static double getPenalty(List<PlayingCard> cardsList) {
    double result = 0.0;
    for (int i = 0; i < cardsList.length; i++) {
      result += cardsList[i].penaltyVal;
    }
    return result;
  }

  static bool _checkIfValid(List<PlayingCard> list) {
    List<MeldClass> melds = validate(list);
    if (melds.length == 0) {
      return false;
    }
    return true;
  }

  /// This method gathers groups from left to right
  ///
  ///  Example: A A A A 2 3 K K K -> A A A A and K K K
  static List<List<PlayingCard>> _getGroups(List<PlayingCard> settingCards) {
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

  /// This method return the starting and ending
  ///   indices of groups and returns a list if those.
  ///
  /// Example:
  /// If you have A J J J 2 2 2 K
  ///   This method returns
  ///   [[1,4],[4,7]]
  ///   which are the range of
  ///   JJJ [1,4)
  ///   and 222 [4, 7)
  ///   respectively
  static List<List<int>> _getRangeFromGroups(
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

  /// This method checks if two range list values overlap
  ///
  /// Example:
  ///   A A JKR J J
  ///   for A A JKR your range is [0,3)
  ///   for JKR J J your range is [2,5)
  ///    which overlap
  static bool _rangeCollision(List<int> group1, List<int> group2) {
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

  /// This method identifies the best grouping of [player.cards]
  ///
  /// This method check groups from left to right
  /// Then it checks groups from right to left
  /// Then it calculates the overlap between the groups
  /// and picks groups that have a higher score.
  /// if combining left and right groups gives a higher
  /// score, the groups that gave that score are returned,
  /// otherwise the higher between the left and right groups
  /// is returned instead
  static List<List<PlayingCard>> getOptimalGroups(
      List<PlayingCard> settingCards) {
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
        if (_rangeCollision(leftRange[left[i]], rightRange[right[j]])) {
          if (getScore(leftGroups[left[i]]) > getScore(rightGroups[right[j]])) {
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
    double leftScore = getGroupScore(leftGroups);
    double rightScore = getGroupScore(rightGroups);
    double combined = getGroupScore(result);
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
}
