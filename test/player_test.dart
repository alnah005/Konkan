import 'package:solitaire/models/player.dart';
import 'package:solitaire/models/playing_card.dart';
import 'package:solitaire/utils/enums.dart';
import 'package:solitaire/utils/playing_card_util.dart';
import 'package:test/test.dart';

void main() {
  group('recording game', () {
    test('recording losses and wins', () {
      final player = Player(CardList.P1);
      expect(player.personalInfo.wins, 0);
      expect(player.personalInfo.losses, 0);
      player.recordGame(CardList.P1);
      expect(player.personalInfo.wins, 1);
      expect(player.personalInfo.losses, 0);
      player.recordGame(CardList.P2);
      expect(player.personalInfo.wins, 1);
      expect(player.personalInfo.losses, 1);
    });
    test('avg score', () {
      final player = Player(CardList.P1);
      List<PlayingCard> cards = [
        PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.jack),
        PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.jack),
        PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.jack),
      ];
      player.cards = cards;
      player.recordGame(CardList.P1);
      expect(player.personalInfo.avgScore, 30.0);
      player.recordGame(CardList.P1);
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
      player.recordGame(CardList.P1);
      expect(player.personalInfo.avgScore, 40.0);
    });
  });

  group("Setting cards", () {
    Player player = Player(CardList.P1);
    final cards = [
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.five),
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.jack),
      PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.jack),
    ];
    final extraCard =
        PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.jack);
    test("set cards for first time", () {
      player.cards = List.from(cards);
      double setScore = player.setCards(0, extraCard);
      expect(setScore, 30.0);
      expect(player.openCards, [
        [cards[1], cards[2], extraCard]
      ]);
    });

    test("setting for second time", () {
      player.initialize("");
      player.cards = List.from(cards);
      player.openCards = [List.from(cards)];
      double setScore = player.setCards(0, extraCard);
      expect(player.openCards, [
        cards,
        [cards[1], cards[2], extraCard]
      ]);
    });

    final cards2 = [
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.five),
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.nine),
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.ten),
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.jack),
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.queen),
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.jack),
      PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.jack),
    ];

    test("setting multiple groups", () {
      player.initialize("");
      expect(player.cards, []);
      player.cards = List.from(cards2);
      expect(player.cards, cards2);
      double setScore = player.setCards(0, extraCard);
      expect(setScore, 69.0);
      expect(player.openCards, [
        (cards2.skip(5).toList() + [extraCard])
            .reversed
            .toList()
            .cast<PlayingCard>(),
        cards2.skip(1).take(4).toList().reversed.toList().cast<PlayingCard>(),
      ]);
    });
    test("setting multiple groups after setting", () {
      player.initialize("");
      player.cards = List.from(cards2);
      player.openCards = [List.from(cards2)];
      double setScore = player.setCards(0, extraCard);
      expect(player.openCards, [
        cards2,
        (cards2.skip(5).toList() + [extraCard])
            .reversed
            .toList()
            .cast<PlayingCard>(),
        cards2.skip(1).take(4).toList().reversed.toList().cast<PlayingCard>(),
      ]);
    });
    final extraCard2 =
        PlayingCard(cardSuit: CardSuit.spades, cardType: CardType.jack);

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
    Player player = Player(CardList.P1);
    final cards = [
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.queen),
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.one),
      PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.one),
      PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker),
      PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.five),
      PlayingCard(cardSuit: CardSuit.spades, cardType: CardType.five)
    ];
    final extraCard =
        PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.five);
    test("Left is better than right", () {
      player.initialize("");
      expect(player.cards, []);
      player.cards = List.from(cards);
      expect(player.cards, cards);
      double setScore = player.setCards(0, extraCard);
      expect(setScore, 48.0);
      for (int i = 0; i < 3; i++) {
        expect(player.openCards[0][i], cards[i + 1]);
      }
      expect(player.openCards[1], [cards[4], cards[5], extraCard]);
    });

    final cards2 = [
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.queen),
      PlayingCard(cardSuit: CardSuit.spades, cardType: CardType.five),
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
      expect(setScore, 45.0);

      expect(player.openCards[0][0], cards2[4]);
      expect(player.openCards[0][1], cards2[5]);
      expect(player.openCards[0][2], extraCard2);
      expect(player.openCards[1][0], cards2[1]);
      expect(player.openCards[1][1], cards2[2]);
      expect(player.openCards[1][2], cards2[3]);
    });

    final cards3 = [
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.jack),
      PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.jack),
      PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker),
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.five),
      PlayingCard(cardSuit: CardSuit.spades, cardType: CardType.five),
      PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker),
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.king),
      PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.king),
      PlayingCard(cardSuit: CardSuit.spades, cardType: CardType.jack),
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
      expect(setScore, 90);
      for (int i = 0; i < 3; i++) {
        expect(player.openCards[0][i], cards3[i]);
      }
      expect(player.openCards[1][0], cards3[8]);
      expect(player.openCards[1][1], cards3[9]);
      expect(player.openCards[1][2], extraCard3);
      expect(player.openCards[2][0], cards3[5]);
      expect(player.openCards[2][1], cards3[6]);
      expect(player.openCards[2][2], cards3[7]);
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

    final cards5 = [
      PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.one),
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.one),
      PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker),
      PlayingCard(cardSuit: CardSuit.spades, cardType: CardType.one),
      PlayingCard(cardSuit: CardSuit.spades, cardType: CardType.three),
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.ten),
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.jack),
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.queen),
      PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.jack),
      PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker),
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.jack),
      PlayingCard(cardSuit: CardSuit.spades, cardType: CardType.jack),
      PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.ten),
      PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.jack),
      PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.queen),
    ];

    test("Extreme real case 1", () {
      player.initialize("");
      expect(player.cards, []);
      player.cards = List.from(cards5);
      expect(player.cards, cards5);
      double setScore = player.setCards(0);
      expect(setScore, 144);
      expect(player.openCards, [
        [
          cards5[14],
          cards5[13],
          cards5[12],
        ],
        [cards5[11], cards5[10], cards5[9], cards5[8]],
        [
          cards5[7],
          cards5[6],
          cards5[5],
        ],
        [
          cards5[3],
          cards5[2],
          cards5[1],
          cards5[0],
        ],
      ]);
    });

    final cards6 = [
      PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.one),
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.one),
      PlayingCard(cardSuit: CardSuit.spades, cardType: CardType.one),
      PlayingCard(cardSuit: CardSuit.spades, cardType: CardType.three),
      PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker),
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.ten),
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.jack),
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.queen),
      PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.jack),
      PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.jack),
      PlayingCard(cardSuit: CardSuit.spades, cardType: CardType.jack),
      PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.ten),
      PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.jack),
      PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.queen),
      PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker),
    ];
    test("Extreme real case 2", () {
      player.initialize("");
      expect(player.cards, []);
      player.cards = List.from(cards6);
      expect(player.cards, cards6);
      double setScore = player.setCards(0);
      expect(setScore, 142);
      expect(player.openCards, [
        [
          cards6[14],
          cards6[13],
          cards6[12],
          cards6[11],
        ],
        [cards6[10], cards6[9], cards6[8]],
        [
          cards6[7],
          cards6[6],
          cards6[5],
          cards6[4],
        ],
        [
          cards6[2],
          cards6[1],
          cards6[0],
        ],
      ]);
    });
  });
}
