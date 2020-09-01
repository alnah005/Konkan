import 'package:solitaire/models/playing_card.dart';
import 'package:test/test.dart';

import 'file:///D:/app/solitaire/solitaire/lib/utils/groups.dart';

void main() {
  group("basic melds", () {
    test("basic sequence meld (3 cards)", () {
      var cards = [
        PlayingCard(cardType: CardType.two, cardSuit: CardSuit.diamonds),
        PlayingCard(cardType: CardType.three, cardSuit: CardSuit.diamonds),
        PlayingCard(cardType: CardType.four, cardSuit: CardSuit.diamonds),
      ];
      var result = validate(cards);
      assert(result.length == 1);
      assert(result[0].penalty == 9);
    });
    test("basic sequence meld (9 cards)", () {
      var cards = [
        PlayingCard(cardType: CardType.five, cardSuit: CardSuit.spades),
        PlayingCard(cardType: CardType.six, cardSuit: CardSuit.spades),
        PlayingCard(cardType: CardType.seven, cardSuit: CardSuit.spades),
        PlayingCard(cardType: CardType.eight, cardSuit: CardSuit.spades),
        PlayingCard(cardType: CardType.nine, cardSuit: CardSuit.spades),
        PlayingCard(cardType: CardType.ten, cardSuit: CardSuit.spades),
        PlayingCard(cardType: CardType.jack, cardSuit: CardSuit.spades),
        PlayingCard(cardType: CardType.queen, cardSuit: CardSuit.spades),
        PlayingCard(cardType: CardType.king, cardSuit: CardSuit.spades),
      ];
      var result = validate(cards);
      assert(result.length == 1);
      assert(result[0].penalty == 75);
    });

    test("basic suit meld", () {
      var cards = [
        PlayingCard(cardType: CardType.king, cardSuit: CardSuit.spades),
        PlayingCard(cardType: CardType.king, cardSuit: CardSuit.diamonds),
        PlayingCard(cardType: CardType.king, cardSuit: CardSuit.hearts),
      ];
      var result = validate(cards);
      assert(result.length == 1);
      assert(result[0].penalty == 30);
    });
  });
  group("test drop", () {
    var cards = [
      PlayingCard(cardType: CardType.ten, cardSuit: CardSuit.diamonds),
      PlayingCard(cardType: CardType.jack, cardSuit: CardSuit.diamonds),
      PlayingCard(cardType: CardType.queen, cardSuit: CardSuit.diamonds),
    ];
    var meld = validate(cards)[0];
    var joker = PlayingCard(cardType: CardType.joker, cardSuit: CardSuit.joker);
    var card =
        PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.king);
    print(meld);
    test("dropping joker on meld", () {
      meld.dropCard(joker);
      print(meld.cards[3].cardType);
      assert(meld.cards[3].cardType == CardType.joker);
      assert(meld.cards[3].cardSuit == CardSuit.joker);
    });
    test("retrieving the joker from meld", () {
      var r = meld.dropCard(card);
      assert(r.cardType == CardType.joker);
      assert(r.cardSuit == CardSuit.joker);
      assert(meld.cards[3].cardType == CardType.king);
      assert(meld.cards[3].cardSuit == CardSuit.diamonds);
    });
  });
}
