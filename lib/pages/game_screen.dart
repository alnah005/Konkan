import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solitaire/models/base_entity.dart';
import 'package:solitaire/models/konkan_game_state.dart';
import 'package:solitaire/models/player.dart';
import 'package:solitaire/models/playing_card.dart';
import 'package:solitaire/utils/enums.dart';
import 'package:solitaire/widgets/discarded_deck.dart';
import 'package:solitaire/widgets/konkan_deck.dart';
import 'package:solitaire/widgets/player_widget.dart';

class GameScreen extends StatefulWidget {
  /// to differentiate players from other entities
  static final List<CardList> playerCardLists = [
    CardList.P1,
    CardList.P2,
    CardList.P3,
    CardList.P4
  ];

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  KonkanGameState gameState;

  @override
  void initState() {
    super.initState();
    gameState = KonkanGameState.initializeGame(
      4,
      [],
      [null, null, null, null],
    );

    /// Build must be called at least once for widget keys to work
    Future.delayed(const Duration(milliseconds: 30), () {
      /// Anything that uses a widget key will go here.
      _initialiseGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(4, 92, 20, 1),
      appBar: AppBar(
        title: Text("Flutter Konkan"),
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(4, 92, 20, 1),
        actions: <Widget>[
          Flexible(
            flex: 3,
            fit: FlexFit.loose,
            child: InkWell(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
              ),
              splashColor: Colors.white,
              onTap: () {
                _initialiseGame();
              },
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Flexible(
            flex: 7,
            fit: FlexFit.loose,
            child: PlayerWidget(
              player: gameState.getTopPlayer(),
              horizontal: true,
              onWillAcceptAdded: (PlayingCard sourceCard, BaseEntity fromPlayer,
                  PlayingCard destinationCard) {
                return false;
              },
              onCardAdded: (PlayingCard sourceCard, BaseEntity fromPlayer,
                  PlayingCard destinationCard) {},
            ),
          ),
          Expanded(child: Container()),
          Flexible(
            flex: 30,
            fit: FlexFit.loose,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Flexible(
                    flex: 7,
                    fit: FlexFit.loose,
                    child: PlayerWidget(
                      player: gameState.getLeftPlayer(),
                      onWillAcceptAdded: (PlayingCard sourceCard,
                          BaseEntity fromPlayer, PlayingCard destinationCard) {
                        return false;
                      },
                      onCardAdded: (PlayingCard sourceCard,
                          BaseEntity fromPlayer,
                          PlayingCard destinationCard) {},
                    ),
                  ),
                  Expanded(child: Container()),
                  Flexible(
                      flex: 10, fit: FlexFit.loose, child: _buildFinalDecks()),
                  Flexible(
                    flex: 7,
                    fit: FlexFit.loose,
                    child: PlayerWidget(
                      player: gameState.getRightPlayer(),
                      onWillAcceptAdded: (PlayingCard sourceCard,
                          BaseEntity fromPlayer, PlayingCard destinationCard) {
                        return false;
                      },
                      onCardAdded: (PlayingCard sourceCard,
                          BaseEntity fromPlayer,
                          PlayingCard destinationCard) {},
                      reverseOrder: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(flex: 7, fit: FlexFit.tight, child: _buildCardDeck()),
          Expanded(child: Container()),
          Flexible(
            flex: 3,
            fit: FlexFit.loose,
            child: IconButton(
              icon: Icon(Icons.add_circle),
              tooltip: 'Set cards',
              onPressed: () {
                setState(() {
                  gameState.setCards(gameState.getMainPlayer());
                });
              },
            ),
          ),
          Flexible(
              flex: 7,
              fit: FlexFit.loose,
              child: PlayerWidget(
                player: gameState.getMainPlayer(),
                onWillAcceptAdded: (PlayingCard sourceCard,
                    BaseEntity fromPlayer, PlayingCard destinationCard) {
                  return _handlePlayerOnDrag(
                      sourceCard, fromPlayer, destinationCard);
                },
                onCardAdded: (PlayingCard sourceCard, BaseEntity fromPlayer,
                    PlayingCard destinationCard) {
                  _handlePlayerDragged(sourceCard, fromPlayer, destinationCard);
                },
                horizontal: true,
                reverseOrder: true,
              )),
          Expanded(child: Container()),
        ],
      ),
    );
  }

  // Build the deck of cards left after building card columns
  Widget _buildCardDeck() {
    return Container(
      child: Row(
        children: <Widget>[
          InkWell(
            child: KonkanDeck(
              key: gameState.deckKey,
              numberOfDecks: 2,
              numberOfJokers: 2,
            ),
            onTap: () {
              setState(() {
                /// Todo make a method in konkan gamestate to take care of this
                if (gameState.roundState.currentPlayer.eligibleToDraw) {
                  var newCard = gameState.roundState.drawFromDeck()..faceUp;
                  newCard.faceUp = true;
                  gameState.roundState.currentPlayer.cards.add(newCard);
                  gameState.roundState.currentPlayer.discarded = false;
                  gameState.roundState.currentPlayer.eligibleToDraw = false;
                } else {
                  print("you need to throw a card");
                }
              });
            },
          ),
        ],
      ),
    );
  }

  // Build the final decks of cards
  Widget _buildFinalDecks() {
    return Container(
      decoration: ShapeDecoration(
        shape: StadiumBorder(),
        color: Color.fromRGBO(135, 0, 0, 1),
        shadows: [
          BoxShadow(
            offset: const Offset(0, 0),
            blurRadius: 5.0,
            spreadRadius: 3.0,
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: DiscardedDeck(
          key: gameState.discardedDeckKey,
          onWillAcceptAdded: (sourceCard, player, destinationCard) {
            print(player.identifier);
            if (GameScreen.playerCardLists.contains(player.identifier)) {
              return true;
            }
            return false;
          },
          onCardAdded: (sourceCard, player, destinationCard) {
            if (player.identifier ==
                    gameState.roundState.currentPlayer.identifier &&
                !gameState.roundState.currentPlayer.discarded) {
              setState(() {
                gameState.roundState
                    .throwToDeck(sourceCard..isDraggable = true);
              });
              if (gameState.checkRoundWin()) {
                _handleWin(gameState.roundState.currentPlayer);
              } else {
                gameState.nextPlayer();
              }
            }
          },
          discardEntity: gameState.getDiscardedDeck(),
        ),
      ),
    );
  }

  /// Initialise a new game in a new round
  void _initialiseGame() {
    setState(() {
      gameState.initializeRound(gameState.players);
    });
  }

  /// Handle a win condition
  void _handleWin(Player whichPlayer) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Game Over"),
          content: Text(whichPlayer.name + " won!"),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                _initialiseGame();
                Navigator.pop(context);
              },
              child: Text("Play again"),
            ),
          ],
        );
      },
    );
  }

  /// method that controls what happens when a card is dragged towards
  /// players deck
  ///
  /// return true when a card can be accepted by a player
  /// return false when a player is not eligible to move a card onto deck
  bool _handlePlayerOnDrag(PlayingCard sourceCard, BaseEntity fromPlayer,
      PlayingCard destinationCard) {
    var player = gameState.getMainPlayer();
    if (fromPlayer.identifier == player.identifier) {
      if (sourceCard != destinationCard) {
        setState(() {
          List<PlayingCard> currentCards = player.cards;
          int cardIndex = currentCards.indexOf(sourceCard);
          int newIndex = currentCards.indexOf(destinationCard);
          currentCards.insert(
              cardIndex >= newIndex ? newIndex : newIndex + 1, sourceCard);
          currentCards.removeAt(
              cardIndex >= (newIndex + 1) ? cardIndex + 1 : cardIndex);
        });
        return true;
      }
    }
    if (gameState.roundState.currentPlayer != player) {
      return false;
    }
    if (fromPlayer.identifier == CardList.DROPPED) {
      if (player.eligibleToDraw && player.isCurrentPlayer) {
        return true;
      }
    }
    return false;
  }

  /// method that controls what happens when a card is dropped on
  /// players deck
  void _handlePlayerDragged(PlayingCard sourceCard, BaseEntity fromPlayer,
      PlayingCard destinationCard) {
    var player = gameState.getMainPlayer();
    if (fromPlayer.identifier == CardList.DROPPED) {
      setState(() {
        List<PlayingCard> currentCards = player.cards;
        int cardIndex = currentCards.indexOf(sourceCard);
        int newIndex = currentCards.indexOf(destinationCard);
        currentCards.insert(
            cardIndex >= newIndex ? newIndex : newIndex + 1, sourceCard);
        player.extraCard = sourceCard;
        player.discarded = false;
        player.eligibleToDraw = false;
        player.mustSetCards = true;
        gameState.discardedDeck.cards.remove(sourceCard);
      });
    }
  }
}
