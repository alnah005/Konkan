import 'package:flutter/material.dart';
import 'package:solitaire/models/base_game_state.dart';
import 'package:solitaire/models/base_round_state.dart';
import 'package:solitaire/models/player.dart';
import 'package:solitaire/models/playing_card.dart';
import 'package:solitaire/pages/game_screen.dart';
import 'package:solitaire/utils/enums.dart';
import 'package:solitaire/widgets/discarded_deck.dart';
import 'package:solitaire/widgets/konkan_deck.dart';

import 'konkan_round_state.dart';

class KonkanGameState<Y> extends BaseGameState<Y> {
  List<PlayingCard> cardDeckClosed = [];
  double settingScore = 51;
  GlobalKey<KonkanDeckState> deckKey = GlobalKey();
  GlobalKey<DiscardedDeckState> discardedDeckKey = GlobalKey();
  var deck;
  var discardedDeck;
  static int playerIndex = 3;
  KonkanRoundState<Y> roundState;
  // Stores the card in the upper boxes
  List<PlayingCard> droppedCards = [];

  KonkanGameState(
      {int numOfPlayers,
      List<Player> playerList,
      List<Y> playerInfo,
      this.roundState})
      : super(
            numberOfPlayers: numOfPlayers,
            players: playerList,
            playerGameInfo: playerInfo,
            round: roundState);

  @override
  void addPlayer(Player player, Y playerInfo) {
    // TODO: implement addPlayer
  }

  @override
  bool checkGameWin() {
    // TODO: implement checkGameWin
    throw UnimplementedError();
  }

  @override
  bool checkRoundWin() {
    if (roundState.currentPlayer.cards.length == 0) {
      this.nextRound();
      return true;
    }
    return false;
  }

  @override
  void initializeGame(
      [int numOfPlayers,
      List<Player> playerList,
      List<Y> playerInfo,
      BaseRoundState roundState]) {
    // TODO: implement initializeGame
    KonkanGameState(
        numOfPlayers: numOfPlayers,
        playerList: playerList,
        playerInfo: playerInfo,
        roundState: roundState);
    assert(super.numberOfPlayers <= 0 && playerList.isEmpty,
        "Gamestate must have at least 1 player");
    assert(super.numberOfPlayers > 4 || playerList.length > 4,
        "Gamestate must have at most 4 players");
    if (playerList.isEmpty) {
      this.initializePlayers();
    }
    if (roundState != null) {
      this.initializeRound(this.players);
    } else {
      roundState = KonkanRoundState(deckKey, discardedDeckKey);
    }
    settingScore = 51;
  }

  void initializePlayers() {
    for (int i = 0; i < super.numberOfPlayers - 1; i++) {
      super.players.add(new Player(GameScreen.playerCardLists[i], isAI: true));
    }
    super.players.add(new Player(
          GameScreen.playerCardLists[super.numberOfPlayers - 1],
        ));
  }

  @override
  Player initializeRound(List<Player> playerList) {
    round.currentPlayer = playerList[playerIndex];
    round.initializeRound();
    return round.currentPlayer;
  }

  @override
  Player nextPlayer() {
    round.nextTurnVariables(
        this.players[playerIndex], this.playerGameInfo[playerIndex]);
    playerIndex += 1;
    playerIndex = playerIndex % this.players.length;
    return round.currentPlayer;
  }

  @override
  void removePlayer(Player player) {
    // TODO: implement removePlayer
  }

  @override
  void trackGameStats() {
    // TODO: implement trackGameStats
  }

  @override
  void trackRoundStats() {
    for (int i = 0; i < this.players.length; i++) {
      this.players[i].recordGame(round.currentPlayer.identifier);
    }
  }

  @override
  void nextRound() {
    /// Discard all player cards to discarded deck
    for (int i = 0; i < this.players.length; i++) {
      var cardList = this.players[i].cards;
      var setCardList = this.players[i].openCards;
      cardList.forEach((e) => discardedDeckKey.currentState.throwToDeck(e));
      setCardList.forEach((e) => e.forEach((element) {
            discardedDeckKey.currentState.throwToDeck(element);
          }));
    }
    round = round.nextRound(round);
    this.nextPlayer();

    /// clear all player decks
    for (int i = 0; i < this.players.length; i++) {
      this.players[i].initialize(this.players[i].name);
    }

    /// redistribute cards to players
    for (int i = 0; i < this.players.length; i++) {
      var cardList = this.players[i].cards;
      for (var card in deckKey.currentState.distributeCards(14)) {
        this.players[i].isAI
            ? cardList.add(
                card
                  ..opened = true
                  ..faceUp = false,
              )
            : cardList.add(
                card
                  ..opened = true
                  ..faceUp = true
                  ..isDraggable = true,
              );
      }
    }
  }

  void setCards(Player player) {
    this.roundState.handleSetCards(player);
  }

  String _getNameFromIndex(CardList index) {
    switch (index) {
      case CardList.P1:
        return this.players[0].name;
      case CardList.P2:
        return this.players[1].name;
      case CardList.P3:
        return this.players[2].name;
      case CardList.P4:
        return this.players[3].name;
      default:
        return "Null";
    }
  }

  Player _getNextPlayer() {
    switch (roundState.currentPlayer.identifier) {
      case CardList.P1:
        return this.players[1];
      case CardList.P2:
        return this.players[2];
      case CardList.P3:
        return this.players[3];
      case CardList.P4:
        return this.players[0];
      default:
        return null;
    }
  }
}
