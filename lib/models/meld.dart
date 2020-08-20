import 'playing_card.dart';

class JokerPlaceHolder {
  int index;
  CardSuit suit;
  CardType type;

  PlayingCard asCard() {
    return new PlayingCard(cardSuit: this.suit, cardType: this.type);
  }

  JokerPlaceHolder(this.type, this.suit, this.index);

  bool isSame(PlayingCard other) {
    if (other.cardType == this.type && other.cardSuit == this.suit) {
      return true;
    }
    return false;
  }
}

enum MeldType { sequence, suit }

abstract class MeldClass extends Object {
  List<PlayingCard> cards;

  int get penalty;

  MeldType meldType;

  PlayingCard dropCard(PlayingCard card);

  PlayingCard swapCard(PlayingCard card);

  PlayingCard meldCard(PlayingCard card);

  List<PlayingCard> get cardsList;

  Map<int, PlayingCard> get meldMap;

  List<JokerPlaceHolder> jokers;

  String get shortInfo {
    String mType;
    switch (this.meldType) {
      case MeldType.sequence:
        mType = 'sequence meld';
        break;
      case MeldType.suit:
        mType = "suit meld ";
    }
    return "${penalty.toString()}\t${mType}\t "
        "jkr ${jokers.map((e) => e.asCard()).map((e) => e.string)}\t"
        "acpt ${meldMap.values.map((e) => e.string)}";
  }

  @override
  String toString() {
    var mType;
    switch (this.meldType) {
      case MeldType.sequence:
        mType = 'sequence';
        break;
      case MeldType.suit:
        mType = "suit";
    }
    return "\nA ${mType} meld worth ${penalty.toString()} with cards: "
        "${cards.fold("", (previousValue, element) => previousValue + " " + element.string)} "
        "\nSwapping jokers for ${jokers.map((e) => e.asCard()).fold("", (previousValue, element) => previousValue + " " + element.string)}"
        "\nCurrently accepting ${meldMap.values.fold("", (previousValue, element) => previousValue + " " + element.string)}";
  }
}

class Meld extends MeldClass {
  List<PlayingCard> cards;

  Map<int, PlayingCard> get meldMap {
    return null;
  }

  List<JokerPlaceHolder> jokers = new List<JokerPlaceHolder>();

  PlayingCard dropCard(PlayingCard card) {
    print("\ndropping ${card.string} on ${this.cards.map((e) => e.string)}");
    var swap = this.swapCard(card);
    if (swap != null) {
      return swap;
    }
    var meld = this.meldCard(card);
    print("${this.cards.map((e) => e.string)} return ${meld}");
    return meld;
  }

  PlayingCard swapCard(PlayingCard card) {
    var jok = this.jokers.firstWhere(
        (element) =>
            element.type == card.cardType && element.suit == card.cardSuit,
        orElse: () => null);
    if (jok != null) {
      var result = this.cards.removeAt(jok.index);
      this.cards.insert(jok.index, card);
      this.jokers.remove(jok);

      print(
          'swap result: ${this.cards.map((e) => e.string)} returning ${result.string}\n');
      return result;
    }
    return null;
  }

  PlayingCard meldCard(PlayingCard card) {
    print(this.meldMap);
    var result = meldMap.entries.firstWhere(
        (element) =>
            element.value.cardType == card.cardType &&
            element.value.cardSuit == card.cardSuit,
        orElse: () => null);

    if (result != null) {
      if (result.key == 0) {
        this.cards.insert(result.key, card);
        this.jokers.forEach((element) {
          element.index += 1;
        });
      } else {
        this.cards.add(card);
      }
      return null;
    }

    return card;
  }

  List<PlayingCard> get cardsList {
    List<PlayingCard> result = new List<PlayingCard>.from(this.cards);
    this.jokers.forEach((element) {
      result[element.index] = element.asCard();
    });
    return result;
  }

  int get penalty {
    return this.cardsList.fold(0,
        (previousValue, element) => previousValue + element.penaltyVal.round());
  }

  Meld(this.cards, this.jokers) {
    this.cards.forEach((element) {});
  }
}

class MeldSeqBase extends Meld {
  int direction;
  MeldType meldType = MeldType.sequence;

  MeldSeqBase(
      List<PlayingCard> cards, List<JokerPlaceHolder> jokers, this.direction)
      : super(cards, jokers);
}

class MeldSeq extends MeldSeqBase with SeqMixin {
  MeldSeq(List<PlayingCard> cards, List<JokerPlaceHolder> jokers, int direction)
      : super(cards, jokers, direction);
}

mixin SeqMixin on MeldSeqBase {
  @override
  Map<int, PlayingCard> get meldMap {
    Map<int, PlayingCard> result = new Map<int, PlayingCard>();
    var first = this.cardsList.first;
    var last = this.cardsList.last;
    if (first.cardType != CardType.one) {
      result[0] = new PlayingCard(
          cardSuit: first.cardSuit,
          cardType: getType(first.position - direction));
    }
    if (last.cardType != CardType.one) {
      result[1] = new PlayingCard(
          cardSuit: last.cardSuit,
          cardType: getType(last.position + direction));
    }

    return result;
  }
}

mixin SuitMixin on Meld {
  MeldType meldType = MeldType.suit;

  @override
  Map<int, PlayingCard> get meldMap {
    Map<int, PlayingCard> result = new Map<int, PlayingCard>();
    var remaining = CardSuit.values
        .where((element) =>
            element != CardSuit.joker &&
            !cardsList.map((e) => e.cardSuit).contains(element))
        .toList();
    result.addAll(remaining.asMap().map((key, value) => MapEntry(
        key, PlayingCard(cardType: cardsList[0].cardType, cardSuit: value))));
    return result;
  }
}

class MeldSuit extends Meld with SuitMixin {
  @override
  Map<int, PlayingCard> get meldMap {
    Map<int, PlayingCard> result = new Map<int, PlayingCard>();
    var remaining = CardSuit.values
        .where((element) =>
            element != CardSuit.joker &&
            !cardsList.map((e) => e.cardSuit).contains(element))
        .toList();
    result.addAll(remaining.asMap().map((key, value) => MapEntry(
        key, PlayingCard(cardType: cardsList[0].cardType, cardSuit: value))));
    return result;
  }

  MeldSuit(List<PlayingCard> cards, List<JokerPlaceHolder> jokers)
      : super(cards, jokers);
}
