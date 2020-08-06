import 'package:solitaire/models/playing_card.dart';

enum GroupType { Invalid, Multiple, Suit, Sequence }

class PossibleGroup {
  List<PlayingCard> cards;

  double get penalty {
    return this.cards.fold(
        0, (previousValue, element) => previousValue + element.penaltyVal);
  }

  PossibleGroup(this.cards);
}

class Group {
  List<PlayingCard> cards;
  GroupType type;
  List<Map<int, List<PlayingCard>>> subGroups; // map of penalty val and cards
  List<int> jokerPenalties;
  String message;
  double sequenceStep;
  List<PlayingCard> jokers;
  List<PlayingCard> nonJokers;

  double get penalty {
    double res = 0;

    for (PlayingCard card in this.cards) {
      res += card.penaltyVal;
    }
    res += this.jokerPenalties.reduce((value, element) => value += element);
    return res;
  }

  bool initCheck() {
    List<CardType> cardTypes;
    List<CardSuit> cardSuits;
    int uniqueSuits, uniqueTypes, numberOfCards, numberOfJokers;

    numberOfCards = this.nonJokers.length;
    numberOfJokers = this.jokers.length;

    /// the special case where we have a group that consists of a card and two
    /// jokers {three of hearts, joker, joker}
    /// we will have two possible groups. Either a sequence
    /// { three of hearts, four of hearts, five of hearts}
    /// or a suit group
    /// { three of hearts, three of clubs, three of spades}
    if (numberOfCards == 1 && numberOfJokers == 2) {
//      /// the special case where we have an ace in the middle
//      /// {joker ace joker}
//      if (this.nonJokers.first.cardType == CardType.one &&
//          this.cards.indexOf(this.nonJokers.first) == 1) {
//        this.type = GroupType.Suit;
//        return true;
//      }
      this.type = GroupType.Multiple;
      return true;
    }

    this.nonJokers.forEach((element) {
      cardTypes.add(element.cardType);
      cardSuits.add(element.cardSuit);
    });

    /// a Set() object removes duplicate items
    uniqueSuits = cardSuits.toSet().length;
    uniqueTypes = cardTypes.toSet().length;

    /// if the non-jokers have one unique suit and the max number of unique types
    /// {ace of hearts, two of hearts, three of hearts}
    /// uniqueSuits = hearts
    /// uniqueTypes = ace, two, three
    /// then it could be a sequence
    if (uniqueSuits == 1 && uniqueTypes == numberOfCards) {
      if (this.checkSequence()) {
        this.type = GroupType.Sequence;
        return true;
      }
    }

    /// if the non-jokers have one unique type and the max number of unique suits
    /// {ace of hearts, ace of clubs, ace of spades}
    /// uniqueSuits = hearts, clubs, spades
    /// uniqueTypes = ace
    else if (uniqueSuits == numberOfCards && uniqueTypes == 1) {
      if (checkSuit()) {
        this.type = GroupType.Suit;
        return true;
      }
    }

    /// if all before fails there are no valid groups
    this.type = GroupType.Invalid;
    return false;
  }

  bool checkSequence() {
    int index1, index2, value1, value2;
    double stepSize;
    Set<double> steps = new Set<double>();

    /// we take the values of the first card
    index1 = this.cards.indexOf(this.nonJokers[0]);
    value1 = this.nonJokers[0].position; // todo add position

    /// we compare the rest of the group (non joker cards only) with the first card
    this.nonJokers.skip(1).forEach((element) {
      index2 = this.cards.indexOf(element);
      value2 = element.position;
      steps.add(((index1 - index2) / (value1 - value2)));
    });

    /// if the amount of the set 'steps' is one, this means uniform stepping
    /// across the group
    if (steps.length == 1) {
      stepSize = steps.first;

      /// a positive step size means an ascending group {ace two three four}
      /// a negative step size means an descending group {four three two ace}
      if (stepSize == 1.0 || stepSize == -1.0) {
        if (this.jokers.length > 0) {
          this.jokers.forEach((element) {
            int pos = value1 -
                ((index1 - this.cards.indexOf(element)) / stepSize).round();

            /// the cases where {joker ace two three}  or {joker ace king queen}
            if (pos < 1 || pos > 14) {
              this.message = "Joker out of range";
              return false;
            }

            /// temporary setting the jokers type "position"
            this.cards[this.cards.indexOf(element)].position = pos;

            return true;
          });
        }
        return true;
      }
    }

    return false;
  }

  bool checkSuit() {
    return true;
  }

  bool get validate {
    this.jokers =
        this.cards.where((element) => element.cardType == CardType.joker);
    this.nonJokers =
        this.cards.where((element) => element.cardType != CardType.joker);

    if (this.cards.length < 3 || this.cards.length > 14) {
      this.type = GroupType.Invalid;
      this.message = "invalid number of cards";
      return false;
    } else if (this.cards.length == 3 &&
        this.nonJokers[0].cardType == CardType.one &&
        this.cards.indexOf(this.nonJokers[0]) == 1) {
      this.type = GroupType.Sequence;
    } else if (this.cards.length > 4 && !this.checkSequence()) {
      this.type = GroupType.Invalid;
      this.message = "invalid group";
      return false;
    } else if (!this.checkSequence() && !this.checkSuit()) {}
    return true;
  }

  Group(this.cards);
}
