import 'package:solitaire/models/groups.dart';
import 'package:solitaire/models/playing_card.dart';
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
}
