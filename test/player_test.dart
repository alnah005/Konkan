import 'package:solitaire/models/player.dart';
import 'package:solitaire/models/playing_card.dart';
import 'package:test/test.dart';

void main() {
  group('recording game', () {
    test('recording losses and wins', () {
      final player = Player(PositionOnScreen.bottom);
      expect(player.personalInfo.wins, 0);
      expect(player.personalInfo.losses, 0);
      player.recordGame(PositionOnScreen.bottom);
      expect(player.personalInfo.wins, 1);
      expect(player.personalInfo.losses, 0);
      player.recordGame(PositionOnScreen.right);
      expect(player.personalInfo.wins, 1);
      expect(player.personalInfo.losses, 1);
    });
    test('avg score', () {
      final player = Player(PositionOnScreen.bottom);
      List<PlayingCard> cards = [
        PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.jack),
        PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.jack),
        PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.jack),
      ];
      player.cards = cards;
      player.recordGame(PositionOnScreen.bottom);
      expect(player.personalInfo.avgScore, 30.0);
      player.recordGame(PositionOnScreen.bottom);
      expect(player.personalInfo.avgScore, 30.0);
      player.cards.add(
          PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.five));
      player.cards.add(
          PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.five));
      player.cards.add(
          PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.five));
      player.cards.add(
          PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.five));
      player.cards.add(
          PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.five));
      player.cards.add(
          PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.five));
      player.recordGame(PositionOnScreen.bottom);
      expect(player.personalInfo.avgScore, 40.0);
    });
  });

  group("Setting cards", () {
    Player player = Player(PositionOnScreen.bottom);
    final cards = [
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.jack),
      PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.jack),
      PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.jack),
    ];
    final extraCard =
        PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.five);
    test("set cards for first time", () {
      player.cards = List.from(cards);
      double setScore = player.setCards(0, extraCard);
      expect(setScore, 30.0);
      expect(player.openCards, [
        cards,
      ]);
    });

    test("setting for second time", () {
      player.initialize("");
      player.cards = List.from(cards);
      player.openCards = [List.from(cards)];
      double setScore = player.setCards(0, extraCard);
      expect(player.openCards, [cards, cards]);
    });

    final cards2 = [
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.jack),
      PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.jack),
      PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.jack),
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.nine),
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.ten),
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.jack),
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.queen),
    ];

    test("setting multiple groups", () {
      player.initialize("");
      expect(player.cards, []);
      player.cards = List.from(cards2);
      expect(player.cards, cards2);
      double setScore = player.setCards(0, extraCard);
      expect(setScore, 69.0);
      expect(
          player.openCards, [cards2.take(3).toList(), cards2.skip(3).toList()]);
    });
    test("setting multiple groups after setting", () {
      player.initialize("");
      player.cards = List.from(cards2);
      player.openCards = [List.from(cards2)];
      double setScore = player.setCards(0, extraCard);
      expect(player.openCards,
          [cards2, cards2.take(3).toList(), cards2.skip(3).toList()]);
    });
    final extraCard2 =
        PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.king);
    test("setting multiple groups", () {
      player.initialize("");
      player.cards = List.from(cards2);
      double setScore = player.setCards(0, extraCard2);
      expect(setScore, 79.0);
      expect(player.openCards, [
        cards2.take(3).toList(),
        cards2.skip(3).toList() + [extraCard2]
      ]);
    });

    final cards3 = [
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.jack),
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.jack),
      PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.jack),
      PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.nine),
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.ten),
      PlayingCard(cardSuit: CardSuit.spades, cardType: CardType.jack),
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.queen),
    ];
    test("No groups are valid", () {
      player.initialize("");
      player.cards = List.from(cards3);
      double setScore = player.setCards(0, extraCard2);
      expect(setScore, 0);
      expect(player.openCards, [[]]);
    });
  });

  group("Optimality of setting cards", () {
    Player player = Player(PositionOnScreen.bottom);
    final cards = [
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.one),
      PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.one),
      PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker),
      PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.five),
    ];
    final extraCard =
        PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.five);
    test("Left is better than right", () {
      player.initialize("");
      expect(player.cards, []);
      player.cards = List.from(cards);
      expect(player.cards, cards);
      double setScore = player.setCards(0, extraCard);
      expect(setScore, 33.0);
      for (int i = 0; i < 3; i++) {
        expect(player.openCards[0][i], cards[i]);
      }
    });

    final cards2 = [
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.five),
      PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.five),
      PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker),
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.jack),
    ];
    final extraCard2 =
        PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.jack);
    test("Right is better than left", () {
      player.initialize("");
      expect(player.cards, []);
      player.cards = List.from(cards2);
      expect(player.cards, cards2);
      double setScore = player.setCards(0, extraCard2);
      expect(setScore, 30.0);

      expect(player.openCards[0][0], cards2[2]);
      expect(player.openCards[0][1], cards2[3]);
      expect(player.openCards[0][2], extraCard2);
    });

    final cards3 = [
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.jack),
      PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.jack),
      PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker),
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.five),
      PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.five),
      PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker),
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.jack),
    ];
    final extraCard3 =
        PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.jack);
    test("Right and Left both have high groups", () {
      player.initialize("");
      expect(player.cards, []);
      player.cards = List.from(cards3);
      expect(player.cards, cards3);
      double setScore = player.setCards(0, extraCard3);
      expect(setScore, 60.0);
      for (int i = 0; i < 3; i++) {
        expect(player.openCards[0][i], cards3[i]);
      }
      expect(player.openCards[1][0], cards3[5]);
      expect(player.openCards[1][1], cards3[6]);
      expect(player.openCards[1][2], extraCard3);
    });

    final cards4 = [
      PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.one),
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.one),
      PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker),
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.ten),
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.jack),
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.queen),
    ];
    test("Extreme case", () {
      player.initialize("");
      expect(player.cards, []);
      player.cards = List.from(cards4);
      expect(player.cards, cards4);
      double setScore = player.setCards(0, extraCard3);
      expect(setScore, 63.0);
      for (int i = 0; i < 3; i++) {
        expect(player.openCards[0][i], cards4[i]);
      }
      expect(player.openCards[1][0], cards4[3]);
      expect(player.openCards[1][1], cards4[4]);
      expect(player.openCards[1][2], cards4[5]);
    });
  });
}
