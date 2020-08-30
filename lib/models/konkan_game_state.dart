import 'package:flutter/material.dart';
import 'package:solitaire/models/base_game_state.dart';
import 'package:solitaire/models/base_round_state.dart';
import 'package:solitaire/models/player.dart';
import 'package:solitaire/models/playing_card.dart';
import 'package:solitaire/pages/game_screen.dart';
import 'package:solitaire/widgets/discarded_deck.dart';
import 'package:solitaire/widgets/konkan_deck.dart';

import 'konkan_round_state.dart';

class KonkanGameState<Y> extends BaseGameState<Y> {
  List<PlayingCard> cardDeckClosed = [];
  double settingScore = 51;
  GlobalKey<KonkanDeckState> deckKey = GlobalKey();
  GlobalKey<DiscardedDeckState> discardedDeckKey = GlobalKey();
  static int playerIndex = 3;
  List<int> _playerIndexes = [0, 1, 2, 3];
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
  KonkanGameState.initializeGame(
      [int numOfPlayers,
      List<Player> playerList,
      List<Y> playerInfo,
      BaseRoundState roundState])
      : super(
            numberOfPlayers: numOfPlayers,
            players: playerList,
            playerGameInfo: playerInfo,
            round: roundState) {
    assert(numberOfPlayers > 0 || playerList.isNotEmpty,
        "Gamestate must have at least 1 player");
    assert(numberOfPlayers < 5 && playerList.length < 5,
        "Gamestate must have at most 4 players");
    if (playerList.isEmpty) {
      this.initializePlayers();
    }
    if (roundState == null) {
      print("keys synced");
      this.roundState =
          KonkanRoundState(deckKey, discardedDeckKey, settingScore);
    }
  }

  void initializePlayers() {
    for (int i = 0; i < super.numberOfPlayers - 1; i++) {
      super.players.add(new Player(GameScreen.playerCardLists[i], isAI: true));
    }
    super.players.add(new Player(
          GameScreen.playerCardLists[super.numberOfPlayers - 1],
          isAI: true,
        ));
  }

  @override
  Player initializeRound(List<Player> playerList) {
    this.redistributeCards();
    roundState.currentPlayer = playerList[3];
    roundState.playerGameInfo = playerGameInfo[3];
    roundState.initializeRound();
    return roundState.currentPlayer;
  }

  @override
  Player nextPlayer() {
    assert(roundState.currentPlayer.cards.length < 15);
    playerIndex += 1;
    playerIndex = playerIndex % this.players.length;
    roundState.nextTurnVariables(
        this.players[playerIndex], this.playerGameInfo[playerIndex]);
    while (roundState.handleAITurns()) {
      playerIndex += 1;
      playerIndex = playerIndex % this.players.length;
      roundState.nextTurnVariables(
          this.players[playerIndex], this.playerGameInfo[playerIndex]);
    }
    return roundState.currentPlayer;
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
      this.players[i].recordGame(roundState.currentPlayer.identifier);
    }
  }

  @override
  void nextRound() {
    redistributeCards();
    roundState = roundState.nextRound(roundState);
  }

  void setCards(Player player) {
    this.roundState.handleSetCards(player);
  }

  Player getMainPlayer() {
    return players[_playerIndexes[3]];
  }

  Player getRightPlayer() {
    return players[_playerIndexes[0]];
  }

  Player getTopPlayer() {
    return players[_playerIndexes[1]];
  }

  Player getLeftPlayer() {
    return players[_playerIndexes[2]];
  }

  void redistributeCards() {
    /// Discard all player cards to discarded deck
    for (int i = 0; i < this.players.length; i++) {
      var cardList = this.players[i].cards;
      var setCardList = this.players[i].openCards;
      cardList.forEach((e) => discardedDeckKey.currentState.throwToDeck(e));
      setCardList.forEach((e) => e.forEach((element) {
            discardedDeckKey.currentState.throwToDeck(element);
          }));
    }
    roundState.recycleDecks();

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
}
