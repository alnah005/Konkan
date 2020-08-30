import 'package:flutter/material.dart';
import 'package:solitaire/models/base_round_state.dart';
import 'package:solitaire/models/player.dart';
import 'package:solitaire/models/playing_card.dart';
import 'package:solitaire/widgets/discarded_deck.dart';
import 'package:solitaire/widgets/konkan_deck.dart';

class KonkanRoundState<Y> extends BaseRoundState<Y> {
  final GlobalKey<KonkanDeckState> deckKey;
  final GlobalKey<DiscardedDeckState> discardedDeckKey;
  double settingScore;

  KonkanRoundState(this.deckKey, this.discardedDeckKey,
      {Player currentPlayer, Y playerGameInfo})
      : super(currentPlayer: currentPlayer, playerGameInfo: playerGameInfo);
  @override
  void initializeRound() {}

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

  PlayingCard drawFromDeck() {
    var result = deckKey.currentState.drawFromDeck();
    if (result != null) {
      return result;
    }
    this.recycleDecks();
    return deckKey.currentState.drawFromDeck();
  }

  void recycleDecks() {
    deckKey.currentState
        .recycleDeck(discardedDeckKey.currentState.recycleDeck());
  }

  void handleSetCards(Player settingPlayer) {
    if (settingPlayer != currentPlayer) {
      print("Its not your turn");
      return;
    }
    if (settingPlayer.discarded) {
      var lastCard = discardedDeckKey.currentState.getLastCard();
      settingScore = settingPlayer.setCards(settingScore, lastCard);

      if (!settingPlayer.eligibleToDraw) {
        settingPlayer.discarded = false;
      } else {
        discardedDeckKey.currentState.throwToDeck(lastCard);
      }
    } else {
      settingScore = settingPlayer.setCards(settingScore);
    }
  }
}
