import 'package:solitaire/models/playing_card.dart';

enum GroupType { Invalid, Multiple, Suit, Sequence }

class PossibleGroup {
  List<PlayingCard> cards;
  GroupType type;

  double get penalty {
    return this.cards.fold(
        0, (previousValue, element) => previousValue + element.penaltyVal);
  }

  PossibleGroup(this.cards, this.type);
}

class Group {
  List<PlayingCard> cards;
  List<String> messages;

  List<PlayingCard> jokers;
  List<PlayingCard> nonJokers;

  List<CardType> allTypes = new List<CardType>();
  List<CardSuit> allSuits = new List<CardSuit>();

  List<PossibleGroup> possibleGroups;
  List<int> jokerPenalties;

  GroupType get type {
    if (this.possibleGroups.length == 1) {
      return this.possibleGroups[0].type;
    } else if (this.possibleGroups.length > 1) {
      return GroupType.Multiple;
    }
    return GroupType.Invalid;
  }

  double get penalty {
    double res = 0;

    for (PlayingCard card in this.cards) {
      res += card.penaltyVal;
    }
    res += this.jokerPenalties.reduce((value, element) => value += element);
    return res;
  }

  void checkSequence() {
    int index1, index2, value1, value2;
    double stepSize;

    index1 = this.cards.indexOf(this.nonJokers[0]);
    value1 = this.nonJokers[0].position; // todo add position

    if (this.nonJokers.length == 1) {
      this.checkJokerSequence(index1, value1, 1.0);
      this.checkJokerSequence(index1, value1, -1.0);
    } else {
      Set<double> steps = new Set<double>();

      /// we take the values of the first card
      this.nonJokers.skip(1).forEach((element) {
        index2 = this.cards.indexOf(element);
        value2 = element.position;
        steps.add(((index1 - index2) / (value1 - value2)));
      });

      /// a positive step size means an ascending group {ace two three four}
      /// a negative step size means an descending group {four three two ace}
      if (steps.length == 1 && steps.first == 1.0 || steps.first == -1.0) {
        stepSize = steps.first;
        if (this.jokers.length > 0) {
          this.checkJokerSequence(index1, value1, stepSize);
        } else {
          List<PlayingCard> possibleCards = this.cards;
          this
              .possibleGroups
              .add(PossibleGroup(possibleCards, GroupType.Sequence));
        }
      }
    }
  }

  void checkJokerSequence(int index1, int value1, double stepSize) {
    List<PlayingCard> possibleCards = this.cards;
    bool valid = true;

    this.jokers.forEach((element) {
      int value, index;
      index = possibleCards.indexOf(element);
      value = value - ((index1 - index) / stepSize).round();
      if (value > 14 || value < 1) {
        valid = false;
      } else {
        possibleCards[index].cardSuit = nonJokers[0].cardSuit;
        possibleCards[index].cardType = getType(value);
        possibleCards[index].penaltyVal = getType(value).data["Penalty"];
      }
    });

    if (valid) {
      this.possibleGroups.add(PossibleGroup(possibleCards, GroupType.Sequence));
    }
  }

  void checkSuit() {
    switch (this.jokers.length) {
      case 0:
        List<PlayingCard> possibleCards = this.cards;
        this.possibleGroups.add(PossibleGroup(possibleCards, GroupType.Suit));
        break;
      case 1:
        List<PlayingCard> possibleCards = this.cards;
        possibleCards[possibleCards.indexOf(this.jokers[0])].cardSuit =
            this.nonJokers[0].cardSuit;
        possibleCards[possibleCards.indexOf(this.jokers[0])].cardType =
            this.nonJokers[0].cardType;

        this.possibleGroups.add(PossibleGroup(possibleCards, GroupType.Suit));
        break;
      case 2:
        List<PlayingCard> possibleCards = this.cards;
        possibleCards[possibleCards.indexOf(this.jokers[0])].cardSuit =
            this.nonJokers[0].cardSuit;
        possibleCards[possibleCards.indexOf(this.jokers[0])].cardType =
            this.nonJokers[0].cardType;
        possibleCards[possibleCards.indexOf(this.jokers[1])].cardSuit =
            this.nonJokers[0].cardSuit;
        possibleCards[possibleCards.indexOf(this.jokers[1])].cardType =
            this.nonJokers[0].cardType;

        this.possibleGroups.add(PossibleGroup(possibleCards, GroupType.Suit));
        break;
    }
  }

  void setup() {
    this.jokers =
        this.cards.where((element) => element.cardType == CardType.joker);
    this.nonJokers =
        this.cards.where((element) => element.cardType != CardType.joker);

    this.nonJokers.forEach((element) {
      this.allTypes.add(element.cardType);
      this.allSuits.add(element.cardSuit);
    });
    this.validate();
  }

  void checkAceSequence() {
    PlayingCard ace = this
        .nonJokers
        .where((element) => element.cardType == CardType.one)
        .first;
    switch (this.cards[this.cards.indexOf(ace)].position) {
      case 1:
        this.cards[this.cards.indexOf(ace)].position = 14;
        break;
      case 14:
        this.cards[this.cards.indexOf(ace)].position = 1;
        break;
    }
    this.checkSequence();
  }

  void validate() {
    int uniqueSuits, uniqueTypes, numberOfNonJokers;
    numberOfNonJokers = this.nonJokers.length;
    uniqueSuits = this.allSuits.toSet().length;
    uniqueTypes = this.allTypes.toSet().length;

    if (uniqueSuits == numberOfNonJokers &&
        uniqueTypes == 1 &&
        this.cards.length < 5) {
      this.checkSuit();
    }
  }

  Group(this.cards) {
    if (this.cards.length < 3 || this.cards.length > 13) {
      this.messages.add("invalid number of cards");
    } else {
      this.setup();
    }
  }
}
