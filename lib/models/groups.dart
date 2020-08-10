import 'package:solitaire/models/playing_card.dart';

//abstract class CardSet extends CardGroup {
//  List<PlayingCard> cardList;
//
//  bool get hasAce;
//
//  bool get hasJokers;
//
//  int get length => this.cardList.length;
//
//  @override
//  String toString() {
//    // TODO: implement toString
//    return super.toString();
//  }
//}

Set getSequenceStepAndShift(Map<int, PlayingCard> cards) {
  cards.removeWhere((key, value) => value.cardType == CardType.joker);

  int index1, value1;
  Set<int> result = new Set<int>();
  index1 = cards.keys.toList()[0];
  value1 = cards[index1].position;
  cards.remove(index1);
  cards.forEach((key, value) {
    result.add(((value1 - value.position) / (index1 - key)).round());
  });
  return result;
}

class GroupBase {
  List<PlayingCard> groupCards = new List<PlayingCard>();
  Map<int, int> nonJokerMap = new Map<int, int>();
  Map<int, int> jokerMap = new Map<int, int>();
  List jokerIndexs = new List();
  Set uniqueTypes = new Set();
  Set uniqueSuits = new Set();
  int numberOfJokers = 0;
  int numberOfNonJokers = 0;
  int numberCards = 0;
  bool hasAce = false;
  int aceIndex;
  List<List<PlayingCard>> subGroups = new List<List<PlayingCard>>();

  GroupBase(this.groupCards) {
    if (this.groupCards.length < 14 && this.groupCards.length > 2) {
      this.groupCards.asMap().forEach((key, value) {
        if (value.cardType == CardType.joker) {
          this.jokerIndexs.add(key);
          this.numberOfJokers += 1;
          jokerMap[key] = value.position;
        } else {
          if (value.cardType == CardType.one) {
            this.hasAce = true;
            this.aceIndex = key;
          }
          nonJokerMap[key] = value.position;
          this.uniqueSuits.add(value.cardSuit);
          this.uniqueTypes.add(value.cardType);
          this.numberOfNonJokers += 1;
        }
        this.numberCards = this.numberOfJokers + this.numberOfNonJokers;
      });
    } else {
      throw ("invalid number of cards");
    }
    if (this.numberCards < 5) {
      this.checkSuits();
      this.checkSequence();
      if (this.hasAce) {
        this.nonJokerMap[this.aceIndex] = 14;
        this.checkSequence();
      }
    }
    if (this.numberCards == 3 && this.numberOfJokers != 0) {
      switch (this.jokerIndexs.length) {
        case 1:
          break;
        case 2:
          if (jokerIndexs.contains(1) == true) {
          } else {
            this.checkSequence();
            if (this.hasAce) {
              this.nonJokerMap[this.aceIndex] = 14;
              this.checkSequence();
            }
          }
          break;
      }
    } else {
      this.checkSequence();
      if (this.hasAce) {
        this.nonJokerMap[this.aceIndex] = 14;
        this.checkSequence();
      }
      //checkSequence()
    }
  }

  void checkSuits() {
    if (this.uniqueSuits.length == this.nonJokerMap.length &&
        this.uniqueTypes.length == 1) {
      //no repeated cards
      if (this.numberOfJokers > 0) {
        List remainingSuits = new List();
        remainingSuits.add(CardSuit.clubs);
        remainingSuits.add(CardSuit.diamonds);
        remainingSuits.add(CardSuit.spades);
        remainingSuits.add(CardSuit.hearts);
        this.uniqueSuits.forEach((element) {
          remainingSuits.remove(element);
        });
        if (this.numberOfJokers == remainingSuits.length) {
          // {joker, joker, card, card} or {joker, card, card, card}
//          case 1:
          switch (numberOfJokers) {
            case 1:
              PlayingCard newCard = new PlayingCard(
                  cardSuit: remainingSuits.first,
                  cardType: this.uniqueTypes.first);
              List<PlayingCard> map1 = List.from(this.groupCards);
              map1[this.jokerIndexs.first] = newCard;
              this.subGroups.add(map1);
              break;
            case 2:
              PlayingCard newCard = new PlayingCard(
                  cardSuit: remainingSuits.first,
                  cardType: this.uniqueTypes.first);
              List<PlayingCard> map1 = List.from(this.groupCards);
              map1[this.jokerIndexs.first] = newCard;
              PlayingCard newCard2 = new PlayingCard(
                  cardSuit: remainingSuits.last,
                  cardType: this.uniqueTypes.first);
              map1[this.jokerIndexs.last] = newCard2;
              this.subGroups.add(map1);
              break;
          }
        } else if (this.numberOfJokers <= remainingSuits.length)
          switch (numberOfJokers) {
            case 1:
              PlayingCard newCard = new PlayingCard(
                  cardSuit: remainingSuits.first,
                  cardType: this.uniqueTypes.first);
              PlayingCard newCard2 = new PlayingCard(
                  cardSuit: remainingSuits.last,
                  cardType: this.uniqueTypes.first);
              List<PlayingCard> map1 = List.from(this.groupCards);
              List<PlayingCard> map2 = List.from(this.groupCards);
              map1[this.jokerIndexs.first] = newCard;
              map2[this.jokerIndexs.first] = newCard2;
              this.subGroups.add(map1);
              this.subGroups.add(map2);
              break;
            case 2:
              PlayingCard newCard = new PlayingCard(
                  cardSuit: remainingSuits.first,
                  cardType: this.uniqueTypes.first);
              PlayingCard newCard2 = new PlayingCard(
                  cardSuit: remainingSuits.last,
                  cardType: this.uniqueTypes.first);
              PlayingCard newCard3 = new PlayingCard(
                  cardSuit: remainingSuits.toList()[1],
                  cardType: this.uniqueTypes.first);
              List<PlayingCard> map1 = List.from(this.groupCards);
              List<PlayingCard> map2 = List.from(this.groupCards);
              List<PlayingCard> map3 = List.from(this.groupCards);
              map1[this.jokerIndexs.first] = newCard;
              map2[this.jokerIndexs.first] = newCard2;
              map3[this.jokerIndexs.first] = newCard3;
              map1[this.jokerIndexs.last] = newCard2;
              map2[this.jokerIndexs.last] = newCard3;
              map3[this.jokerIndexs.last] = newCard;
              this.subGroups.add(map1);
              this.subGroups.add(map2);
              this.subGroups.add(map3);
              break;
          }
      } else {
        this.subGroups.add(new List<PlayingCard>.from(this.groupCards));
      }
    }
  }

  void checkSequence() {
    int index1, d, value1;

    index1 = this.nonJokerMap.keys.first;
    value1 = this.nonJokerMap[index1];

    Set<double> steps = new Set<double>();

    /// we take the values of the first card
    if (this.numberOfNonJokers == 1) {
      this.getSeqJokers(-1, value1, index1);
      this.getSeqJokers(1, value1, index1);
    } else {
      this.nonJokerMap.remove(index1);
      this.nonJokerMap.forEach((key, value) {
        steps.add(((index1 - key) / (value1 - value)));
      });
//      print('steps');
//      print(steps);
      if (steps.length == 1) {
        if (steps.first == 1.0 || steps.first == -1.0) {
          d = steps.first.round();
          this.getSeqJokers(d, value1, index1);
//          print(d);
        }
      }
    }
  }

  void getSeqJokers(int d, value1, index1) {
    if (d == 1 || d == -1) {
      if (this.numberOfJokers > 0) {
        List<PlayingCard> map1 = List.from(this.groupCards);
        bool val = true;
        this.jokerMap.forEach((index, value) {
          int pos = value1 - (index1 - index) * d;
          if (pos > 0 && pos < 14) {
            PlayingCard newCard = new PlayingCard(
                cardSuit: this.uniqueSuits.first, cardType: getType(pos));
            map1[index] = newCard;
          } else {
            val = false;
          }
//              print(value1 - (index1 - index) * d);
//              print(newCard.string);
        });
        if (val) {
          this.subGroups.add(map1);
        }
      } else {
        List<PlayingCard> map1 = List.from(this.groupCards);
        this.subGroups.add(map1);
      }
    }
  }
}
