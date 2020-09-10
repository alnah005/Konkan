import 'package:flutter/material.dart';
import 'package:solitaire/models/base_round_state.dart';
import 'package:solitaire/models/konkan_game_state.dart';
import 'package:solitaire/models/player.dart';
import 'package:solitaire/models/playing_card.dart';
import 'package:solitaire/widgets/discarded_deck.dart';
import 'package:solitaire/widgets/konkan_deck.dart';

import 'base_entity.dart';

class KonkanRoundState<Y> extends BaseRoundState<Y> {
  /// Widget keys are saved here for the same reason as in
  /// [KonkanGameState]
  final GlobalKey<KonkanDeckState> deckKey;
  final GlobalKey<DiscardedDeckState> discardedDeckKey;
  BaseEntity discardedDeck;

  /// saves current rounds setting score
  double settingScore;
  KonkanRoundState(this.deckKey, this.discardedDeckKey, this.settingScore,
      this.discardedDeck,
      {Player currentPlayer, Y playerGameInfo})
      : super(currentPlayer: currentPlayer, playerGameInfo: playerGameInfo);
  @override
  void initializeRound() {}

  /// if round is done this is called to recycle decks and perhaps other
  /// things
  @override
  BaseRoundState nextRound(BaseRoundState previousRound) {
    // TODO: implement nextRound
    this.recycleDecks();
    return this;
  }

  @override
  void trackTurnStats() {
    // TODO: implement trackTurnStats
  }

  /// This calls the [DiscardedDeckState] and adds the [card] in the argument
  /// from the current [Player].
  ///
  /// THE PLAYING CARD IN THE ARGUMENT MUST BE OWNED BY THE CURRENT PLAYER
  void throwToDeck(PlayingCard card) {
    discardedDeckKey.currentState.throwToDeck(card..isDraggable = true);
    currentPlayer.cards.removeAt(currentPlayer.cards.indexOf(card));
    print("Done");
  }

  /// This calls the [KonkanDeckState] and returns the card.
  ///
  /// Could be directly added to the current player in the future
  PlayingCard drawFromDeck() {
    var result = deckKey.currentState.drawFromDeck();
    if (result != null) {
      return result;
    }
    this.recycleDecks();
    return deckKey.currentState.drawFromDeck();
  }

  /// This simply moves all discarded cards to main deck
  void recycleDecks() {
    deckKey.currentState
        .recycleDeck(discardedDeckKey.currentState.recycleDeck());
  }

  /// This method handles setting the cards of the current player
  /// This must be called either before a card is drawn, or after
  /// if the player will win
  bool handleSetCards(Player settingPlayer) {
    var result = false;
    if (settingPlayer != currentPlayer) {
      print("Its not your turn");
      return result;
    }
    var beforeSetCards = settingPlayer.numSetCards();
    settingScore = settingPlayer.setCards(settingScore);
    result = beforeSetCards != settingPlayer.numSetCards();
    if (!result) {
      returnDiscardedDeckCard();
    }
    return result;
  }

  /// This method is called when a player drew a card from the discarded deck
  /// but didn't use it to either meld or set cards
  void returnDiscardedDeckCard() {
    if (currentPlayer.extraCard != null) {
      discardedDeck.cards.add(currentPlayer.extraCard);
      currentPlayer.cards.remove(currentPlayer.extraCard);
      currentPlayer.extraCard = null;
      currentPlayer.discarded = true;
      currentPlayer.eligibleToDraw = true;
    }
  }

  /// This method is called when the current player wants to draw a card from
  /// the main deck
  void drawFromDeckToCurrentPlayer(Player mainPlayer) {
    if (currentPlayer.eligibleToDraw) {
      var newCard = this.drawFromDeck();
      if (currentPlayer == mainPlayer) {
        newCard.faceUp = true;
      }
      currentPlayer.cards.add(newCard);
      currentPlayer.discarded = false;
      currentPlayer.eligibleToDraw = false;
    } else {
      print("you need to throw a card");
    }
  }

  /// This method is called to return the card from [returnDiscardedDeckCard]
  /// into the discarded deck and setting the appropriate booleans in [Player]
  void receiveDiscardedDeckCard() {
    if (currentPlayer.extraCard == null && currentPlayer.eligibleToDraw) {
      currentPlayer.extraCard = discardedDeck.cards.isNotEmpty
          ? discardedDeck.cards.removeLast()
          : null;
      currentPlayer.cards.add(currentPlayer.extraCard);
      currentPlayer.discarded = false;
      currentPlayer.eligibleToDraw = false;
    }
  }
}
