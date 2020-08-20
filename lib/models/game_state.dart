import 'dart:math';

import 'package:solitaire/models/player.dart';
import 'package:solitaire/models/playing_card.dart';

List<PlayingCard> konkanDeck() {
  List<PlayingCard> res = new List<PlayingCard>();
  CardType.values
      .skipWhile((typeValue) => typeValue == CardType.joker)
      .forEach((type) {
    CardSuit.values.forEach((suit) {
      if (suit != CardSuit.joker) {
        res.add(PlayingCard(cardType: type, cardSuit: suit, faceUp: false));
      }
    });
  });
  res.add(PlayingCard(
      cardSuit: CardSuit.joker, cardType: CardType.joker, faceUp: false));
  res.addAll(List.from(res));
  res.shuffle();
  return res;
}

class GameStateBase extends Object {
  final int minSetScore;
  final int numberOfPlayers;
  final int numberOfRounds;
  int currentSetScore;
  int currentRoundNumber = 0;
  List<PlayingCard> allCards;
  List<PlayingCard> droppedCards;
  List<PlayingCard> closedCards;
  List<Player> players;
  Player currentPlayer;

  void startGame() {
    if (this.players.contains(null)) {
      throw Exception("Error, players missing.");
    }
    this.startRound();
  }

  void startRound() {
    this.currentRoundNumber += 1;
    this.allCards = new List<PlayingCard>.from(konkanDeck());
    Random random = Random();
    players.forEach((player) {
      /// removes any cards a player might have from a previous round
      player.cards = new List<PlayingCard>();
      for (int i = 0; i < 15; i++) {
        var card =
            this.allCards.removeAt(random.nextInt(this.allCards.length) - 1);
        player.cards.add(card);
      }

      this.closedCards = List<PlayingCard>.from(this.allCards);
      allCards.clear();

      /// depending on the sorting of the list 'players', each round will start with
      /// a different player
      int startingPlayerIndex = (this.currentRoundNumber % numberOfPlayers) - 1;
      Player startingPlayer = players[startingPlayerIndex];

      /// the starting player on each round will have 15 cards...
      startingPlayer.cards.add(allCards.removeLast());

      /// ...and wont be eligible to draw from the deck...
      startingPlayer.eligibleToDraw = false;

      /// ...but needs to throw a card
      startingPlayer.discarded = true;
      this.currentPlayer = startingPlayer;
    });
    allCards.shuffle();
    this.closedCards.addAll(allCards);
    allCards.clear();
  }

  void joinGame(Player player) {}

  GameStateBase(this.minSetScore, this.numberOfPlayers,
      {this.numberOfRounds = 3}) {
    if (this.numberOfPlayers > 4 || this.numberOfPlayers < 2) {
      throw ArgumentError.value("Wrong number of players");
    }
    if (this.minSetScore > 130) {
      throw ArgumentError.value("Error, min set score is too big.");
    }
    if (this.minSetScore < 0) {
      throw ArgumentError.value("Error, min set score can't be negative.");
    }
    this.currentSetScore = this.minSetScore;
    this.players = new List<Player>(this.numberOfPlayers);
  }
}
