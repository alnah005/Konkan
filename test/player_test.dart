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
}
