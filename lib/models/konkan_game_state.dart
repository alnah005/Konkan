import 'package:flutter/material.dart';
import 'package:solitaire/models/base_entity.dart';
import 'package:solitaire/models/base_game_state.dart';
import 'package:solitaire/models/base_round_state.dart';
import 'package:solitaire/models/player.dart';
import 'package:solitaire/models/playing_card.dart';
import 'package:solitaire/pages/game_screen.dart';
import 'package:solitaire/utils/enums.dart';
import 'package:solitaire/utils/groups.dart';
import 'package:solitaire/widgets/discarded_deck.dart';
import 'package:solitaire/widgets/konkan_deck.dart';

import 'konkan_round_state.dart';

class KonkanGameState<Y> extends BaseGameState<Y> {
  List<PlayingCard> cardDeckClosed = [];
  final double settingScore = 51;

  /// this is necessary because it saves the states of the deck and discarded
  /// deck widgets to be able to call the methods within them
  ///
  /// These can be removed by creating new separate models for both
  /// deck and discarded deck
  GlobalKey<KonkanDeckState> deckKey = GlobalKey();
  GlobalKey<DiscardedDeckState> discardedDeckKey = GlobalKey();

  /// playerIndex keeps track of the current player within _playerIndexes
  static int playerIndex = 3;

  /// [_playerIndexes] keeps track of player indexes with respect to
  /// the players array in [BaseGameState]
  ///
  /// [getMainPlayer()] returns the player from the players
  ///   array using the index from the 4th value
  /// [getRightPlayer()] returns the player from the players
  ///   array using the index from the 1st value
  /// [getTopPlayer()] returns the player from the players
  ///   array using the index from the 2nd value
  /// [getLeftPlayer()] returns the player from the players
  ///   array using the index from the 3rd value
  List<int> _playerIndexes = [0, 1, 2, 3];
  KonkanRoundState<Y> roundState;

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
    if (roundState.currentPlayer.cards.length == 0 &&
        !roundState.currentPlayer.eligibleToDraw) {
      this.trackRoundStats();
      this.nextRound();
      return true;
    }
    return false;
  }

  /// Named constructor that creates the players and the roundstate
  /// Round needs to be initialized before a game starts
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
      this.roundState = KonkanRoundState(deckKey, discardedDeckKey,
          settingScore, BaseEntity(CardList.DROPPED));
    }
  }

  /// This is only called when an array of players wasn't passed
  /// into [KonkanGameState] during instantiation in [GameScreen]
  void initializePlayers() {
    for (int i = 0; i < super.numberOfPlayers - 1; i++) {
      super.players.add(new Player(GameScreen.playerCardLists[i], isAI: true));
    }
    super.players.add(new Player(
          GameScreen.playerCardLists[super.numberOfPlayers - 1],
//          isAI: true,
        ));
  }

  /// Round is initialized here separately from name constructor
  /// because this deals with widget keys.
  @override
  Player initializeRound(List<Player> playerList) {
    this.redistributeCards();
    roundState.currentPlayer = playerList[3];
    roundState.playerGameInfo = playerGameInfo[3];
    roundState.initializeRound();
    roundState.currentPlayer.initializeForNextTurn();
    return roundState.currentPlayer;
  }

  /// This cycles the [playerIndex] variable between 3,0,1,2 and
  /// sets the appropriate round variables accordingly
  /// if a [Player] is an AI this is dealt with in [KonkanRoundState]
  @override
  Player nextPlayer() {
    assert(roundState.currentPlayer.cards.length < 15);
    playerIndex += 1;
    playerIndex = playerIndex % this.players.length;
    roundState.nextTurnVariables(
        this.players[playerIndex], this.playerGameInfo[playerIndex]);
    handleAITurns();
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

  /// Called after a round is won
  @override
  void nextRound() {
    roundState.recycleDecks();
    redistributeCards();
    roundState = roundState.nextRound(roundState);
    roundState.settingScore = this.settingScore;
  }

  /// called when current human player wants to set cards
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

  /// Method throws all player cards to discarded deck then recycles
  /// discarded deck and main deck. Then distributes 14 cards to all
  /// players.
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

  bool dropCardToDiscardedDeck(
      PlayingCard sourceCard, BaseEntity player, PlayingCard destinationCard) {
    if (sourceCard == null) {
      return false;
    }
    bool result = false;
    if (player.identifier != roundState.currentPlayer.identifier) {
      roundState.returnDiscardedDeckCard();
      return result;
    }
    print("dope");
    if (!roundState.currentPlayer.discarded) {
      if (roundState.currentPlayer.extraCard == null) {
        roundState.throwToDeck(sourceCard
          ..isDraggable = true
          ..faceUp = true);
        result = true;
        print("dope2");
      } else {
        print("dope3");
        roundState.returnDiscardedDeckCard();
      }
    }
    return result;
  }

  /// if current player is an AI, finish a turn and return true
  /// otherwise do nothing and return false
  bool handleAITurns() {
    /// todo add extra card to deck then return it if AI did not set cards
    var currentAI = roundState.currentPlayer;
    if (!currentAI.isAI) {
      return false;
    }
    bool cardsSet = false;
    for (int k = 0; k < 500; k++) {
      roundState.receiveDiscardedDeckCard();
      currentAI.cards.shuffle();
      cardsSet = roundState.handleSetCards(currentAI);
      if (cardsSet) {
        break;
      }
      roundState.returnDiscardedDeckCard();
    }
    if (roundState.currentPlayer.hasSetCards()) {
      for (var p in players) {
        for (var g in p.openCards) {
          for (var c in roundState.currentPlayer.cards) {
            swapMeldingCards(c, roundState.currentPlayer, g);
          }
        }
      }
    }
    if (!cardsSet) {
      roundState.drawFromDeckToCurrentPlayer(getMainPlayer());
    }

    /// in the commented line below, I tried to add some time before
    /// the AI makes a decision but it needs to have an asynchronous
    /// environment. This needs a lot of refactoring to the code.
    //await new Future.delayed(const Duration(seconds: 5));

    /// We can use this code however this freezes everything for the
    /// set period of time, making the screen seem laggy or glitched.
    //sleep(const Duration(seconds:1));
    currentAI.cards.shuffle();
    if (dropCardToDiscardedDeck(
        currentAI.cards.isNotEmpty ? currentAI.cards.last : null,
        currentAI,
        roundState.discardedDeck.cards.isNotEmpty
            ? roundState.discardedDeck.cards.last
            : null)) {
      print('bot finished its turn');
    }
    return true;
  }

  /// This method drops cards from [fromPlayer] and puts them into [group]
  ///
  /// Since the current player is the one adding to the group, certain
  /// consequences occur depending on the situation. For example, If the
  /// dropped card is from discarded deck, current player doesn't get
  /// to draw a card from the main deck.
  /// This method returns true if a card was dropped into group.
  bool swapMeldingCards(
      PlayingCard sourceCard, BaseEntity fromPlayer, List<PlayingCard> group) {
    PlayingCard result = sourceCard;
    result = dropToGroup(group, sourceCard);
    if (result != sourceCard) {
      if (result != null) {
        if (fromPlayer.identifier == CardList.DROPPED) {
          roundState.currentPlayer.cards.add(result
            ..isDraggable = true
            ..faceUp = true);
        } else {
          fromPlayer.cards.add(result
            ..isDraggable = true
            ..faceUp = true);
        }
      }
      fromPlayer.cards.remove(sourceCard);
      if (fromPlayer.identifier == CardList.DROPPED) {
        roundState.currentPlayer.eligibleToDraw = false;
        roundState.currentPlayer.discarded = false;
        if (roundState.currentPlayer.extraCard != null) {
          if (roundState.currentPlayer.cards
              .contains(roundState.currentPlayer.extraCard)) {
            roundState.currentPlayer.cards
                .remove(roundState.currentPlayer.extraCard);
          }
          roundState.currentPlayer.extraCard = null;
        }
      }
      return true;
    }
    return false;
  }
}
