import 'package:solitaire/models/playing_card.dart';
import 'package:solitaire/utils/playing_card_util.dart';

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

  JokerPlaceHolder.fromCard(PlayingCard card, int index) {
    this.type = card.cardType;
    this.suit = card.cardSuit;
    this.index = index;
  }

  @override
  String toString() {
    return "Joker as ${type.data["BodyString"]}${suit.string} at $index";
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

  PlayingCard dropJoker(PlayingCard card);

  List<PlayingCard> get cardsList;

  Map<int, PlayingCard> get meldMap;

  List<JokerPlaceHolder> jokers;

  void insertCard(PlayingCard card, int index);

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

  void insertCard(PlayingCard card, int index) {
    if (index == 0) {
      this.cards.insert(0, card);
      this.jokers.forEach((element) {
        element.index += 1;
      });
    } else {
      this.cards.add(card);
    }
  }

  PlayingCard dropJoker(PlayingCard card) {
    var melds = this.meldMap.entries.toList();
    melds.sort((e, r) => e.value.position.compareTo(r.value.position));
    var swapIn = melds.last;
    int index;
    switch (swapIn.key) {
      case 0:
        index = 0;
        break;
      case 1:
        index = this.cards.length;
        break;
    }
    this.insertCard(card, index);
    this.jokers.add(JokerPlaceHolder.fromCard(swapIn.value, index));
    return null;
  }

  PlayingCard dropCard(PlayingCard card) {
    if (card == null) {
      return null;
    }
    print("\ndropping ${card.string} on ${this.cards.map((e) => e.string)}");
    var swap = this.swapCard(card);
    if (swap != null) {
      return swap;
    }
    var meld = this.meldCard(card);
    print(
        "${this.cards.map((e) => e.string)} return ${meld == null ? null : meld.string}");
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
//    print(this.meldMap);
    if (card.cardType == CardType.joker) {
      var result = this.dropJoker(card);
      return result;
    } else {
      var result = meldMap.entries.firstWhere(
          (element) =>
              element.value.cardType == card.cardType &&
              element.value.cardSuit == card.cardSuit,
          orElse: () => null);

      if (result != null) {
        this.insertCard(card, result.key);
        return null;
      }
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
    return this.cardsList.fold(
        0,
        (previousValue, element) =>
            previousValue + (element != null ? element.penaltyVal.round() : 0));
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

  /// checks if the suit meld has space to accept a joker
  /// if not returns the joker
  @override
  PlayingCard dropJoker(PlayingCard card) {
    return this.cards.length < 4 ? super.dropJoker(card) : card;
  }

  MeldSuit(List<PlayingCard> cards, List<JokerPlaceHolder> jokers)
      : super(cards, jokers);
}
