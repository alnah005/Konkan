import 'package:konkan/models/playing_card.dart';
import 'package:konkan/utils/groups.dart';
import 'package:konkan/utils/playing_card_util.dart';
import 'package:test/test.dart';

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
      var r = meld.dropCard(joker);
      assert(meld.cards[3].cardType == CardType.joker);
      assert(meld.cards[3].cardSuit == CardSuit.joker);
      assert(meld.cardsList[3].cardType == CardType.king);
      assert(meld.cardsList[3].cardSuit == CardSuit.diamonds);
    });
    test("retrieving the joker from meld", () {
      var r = meld.dropCard(card);
      assert(r.cardType == CardType.joker);
      assert(r.cardSuit == CardSuit.joker);
      assert(meld.cards[3].cardType == CardType.king);
      assert(meld.cards[3].cardSuit == CardSuit.diamonds);
    });
    test("Dropping joker on a full suit meld", () {
      var cards = [
        PlayingCard(cardType: CardType.queen, cardSuit: CardSuit.diamonds),
        PlayingCard(cardType: CardType.queen, cardSuit: CardSuit.hearts),
        PlayingCard(cardType: CardType.queen, cardSuit: CardSuit.clubs),
        PlayingCard(cardType: CardType.queen, cardSuit: CardSuit.spades),
      ];
      var joker =
          PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker);
      var meld = validate(cards);
      var result = meld[0].dropCard(joker);
      assert(result == joker);
    });
    test("Dropping two jokers on a suit meld of three cards ", () {
      var cards = [
        PlayingCard(cardType: CardType.queen, cardSuit: CardSuit.diamonds),
        PlayingCard(cardType: CardType.queen, cardSuit: CardSuit.hearts),
        PlayingCard(cardType: CardType.queen, cardSuit: CardSuit.clubs),
      ];
      var joker =
          PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker);
      var meld = validate(cards);
      var result = meld[0].dropCard(joker);
      print(meld);

      /// returns nothing when the meld is not full.
      assert(result == null);
      var result2 = meld[0].dropCard(joker);

      /// returns the joker when the meld is full.
      assert(result2 == joker);
    });
    test("Joker place holders", () {
      var t = [
        PlayingCard(cardType: CardType.five, cardSuit: CardSuit.diamonds),
        PlayingCard(cardType: CardType.five, cardSuit: CardSuit.clubs),
        PlayingCard(cardType: CardType.joker, cardSuit: CardSuit.joker),
        PlayingCard(cardType: CardType.joker, cardSuit: CardSuit.joker),
      ];
      var tr = validate(t);
//      print(
//          "${tr.length} Penalty = ${tr[0].penalty}, ${tr[0].cardsList.map((e) =>
//          e.string + " ")}, ${tr[0].jokers.map((e) => e.toString() + " ")}");
//
      assert(tr[0].penalty == 20);
    });
  });
}
