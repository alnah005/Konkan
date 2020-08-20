import 'package:solitaire/models/game_state.dart';
import 'package:solitaire/models/playing_card.dart';
import 'package:test/test.dart';

void main() {
  group("building decks", () {
    final deck = konkanDeck();

    test("number of cards", () {
      expect(deck.length, 106);
    });
    group("number of each type", () {
      var types = deck.map((e) => e.cardType);
      CardType.values.forEach((type) {
        test('number of ${type.toString()}', () {
          if (type == CardType.joker) {
            expect(types.where((testType) => type == testType).length, 2);
          } else {
            expect(types.where((testType) => type == testType).length, 8);
          }
        });
      });
    });
    group("number of each suit", () {
      var suits = deck.map((e) => e.cardSuit);
      CardSuit.values.forEach((suit) {
        test('number of ${suit.toString()}', () {
          if (suit == CardSuit.joker) {
            expect(suits.where((testType) => suit == testType).length, 2);
          } else {
            expect(suits.where((testType) => suit == testType).length, 26);
          }
        });
      });
    });
  });
  group("starting games", () {
    test("starting with 5 players", () {
      expect(() => GameStateBase(5, 5), throwsArgumentError);
    });
    test("starting with 1 player", () {
      expect(() => GameStateBase(5, 1), throwsArgumentError);
    });
  });
}
