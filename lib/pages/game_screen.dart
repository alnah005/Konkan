import 'dart:math';

import 'package:flutter/material.dart';
import 'package:solitaire/models/player.dart';
import 'package:solitaire/models/playing_card.dart';
import 'package:solitaire/widgets/card_column.dart';
import 'package:solitaire/widgets/empty_card.dart';
import 'package:solitaire/widgets/transformed_card.dart';

enum CardList {
  P1,
  P2,
  P3,
  P4,
  P1SET,
  P2SET,
  P3SET,
  P4SET,
  DROPPED,
  REMAINING,
  BURNT
}

class GameScreen extends StatefulWidget {
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
  // Stores the cards on the seven columns
  List<Player> playersList = [
    new Player(PositionOnScreen.bottom),
    new Player(PositionOnScreen.right),
    new Player(PositionOnScreen.top),
    new Player(PositionOnScreen.left)
  ];
  Player currentTurn;

  // Stores the card deck
  List<PlayingCard> cardDeckClosed = [];
  List<PlayingCard> cardDeckOpened = [];

  // Stores the card in the upper boxes
  List<PlayingCard> droppedCards = [];

  @override
  void initState() {
    super.initState();
    _initialiseGame();
    currentTurn = playersList[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        title: Text("Flutter Konkan"),
        elevation: 0.0,
        backgroundColor: Colors.green,
        actions: <Widget>[
          InkWell(
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
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _buildCardDeck(),
              _buildFinalDecks(),
            ],
          ),
          SizedBox(
            height: 16.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: CardColumn(
                  cards: playersList[0].cards,
                  onCardsAdded: (cards, index) {
                    setState(() {
                      playersList[0].cards.addAll(cards);
                      int length = _getListFromIndex(index).length;
                      _getListFromIndex(index)
                          .removeRange(length - cards.length, length);
                      _refreshList(index);
                    });
                  },
                  columnIndex: CardList.P1,
                ),
              ),
              Expanded(
                child: CardColumn(
                  cards: playersList[1].cards,
                  onCardsAdded: (cards, index) {
                    setState(() {
                      playersList[1].cards.addAll(cards);
                      int length = _getListFromIndex(index).length;
                      _getListFromIndex(index)
                          .removeRange(length - cards.length, length);
                      _refreshList(index);
                    });
                  },
                  columnIndex: CardList.P2,
                ),
              ),
              Expanded(
                child: CardColumn(
                  cards: playersList[2].cards,
                  onCardsAdded: (cards, index) {
                    setState(() {
                      playersList[2].cards.addAll(cards);
                      int length = _getListFromIndex(index).length;
                      _getListFromIndex(index)
                          .removeRange(length - cards.length, length);
                      _refreshList(index);
                    });
                  },
                  columnIndex: CardList.P3,
                ),
              ),
              Expanded(
                child: CardColumn(
                  cards: playersList[3].cards,
                  onCardsAdded: (cards, index) {
                    setState(() {
                      playersList[3].cards.addAll(cards);
                      int length = _getListFromIndex(index).length;
                      _getListFromIndex(index)
                          .removeRange(length - cards.length, length);
                      _refreshList(index);
                    });
                  },
                  columnIndex: CardList.P4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // This is where the deck and the burnt card deck are drawn.
  // Build the deck of cards left after building card columns
  Widget _buildCardDeck() {
    return Container(
      child: Row(
        children: <Widget>[
          InkWell(
            child: cardDeckClosed.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: TransformedCard(
                      playingCard: cardDeckClosed.last,
                    ),
                  )
                : Opacity(
                    opacity: 0.4,
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TransformedCard(
                        playingCard: PlayingCard(
                          cardSuit: CardSuit.diamonds,
                          cardType: CardType.five,
                        ),
                      ),
                    ),
                  ),
            onTap: () {
              setState(() {
                if (cardDeckClosed.isEmpty) {
                  cardDeckClosed.addAll(droppedCards.map((card) {
                    return card
                      ..opened = false
                      ..faceUp = false;
                  }));
                  droppedCards.clear();
                } else {
                  if (currentTurn.discarded) {
                    currentTurn.cards.add(
                      cardDeckClosed.removeLast()
                        ..faceUp = true
                        ..opened = true,
                    );
                    currentTurn.discarded = false;
                  }
                }
              });
            },
          ),
          cardDeckOpened.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: TransformedCard(
                    playingCard: cardDeckOpened.last,
                    attachedCards: [
                      cardDeckOpened.last,
                    ],
                    columnIndex: CardList.BURNT,
                  ),
                )
              : Container(
                  width: 40.0,
                ),
        ],
      ),
    );
  }

  // Build the final decks of cards
  Widget _buildFinalDecks() {
    return Container(
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: EmptyCardDeck(
              cardSuit: CardSuit.hearts,
              cardsAdded: droppedCards,
              onCardAdded: (cards, index) {
                if (_getPositionFromIndex(index) == currentTurn.position &&
                    !currentTurn.discarded) {
                  droppedCards.add(cards.first);
                  _getListFromIndex(index).removeAt(0);
                  _refreshList(index);
                  currentTurn = _getNextPlayer(currentTurn);
                  currentTurn.discarded = true;
                }
              },
              columnIndex: CardList.DROPPED,
            ),
          ),
        ],
      ),
    );
  }

  // Initialise a new game
  void _initialiseGame() {
    for (int i = 0; i < playersList.length; i++) {
      playersList[i].initialize("Player " + i.toString());
    }
    // Stores the card deck
    cardDeckClosed = [];
    cardDeckOpened = [];

    // Stores the card in the upper boxes
    droppedCards = [];

    List<PlayingCard> allCards = [];

    // Add all cards to deck
    for (var i = 0; i < 2; i++) {
      CardSuit.values.forEach((suit) {
        CardType.values.forEach((type) {
          allCards.add(PlayingCard(
            cardType: type,
            cardSuit: suit,
            faceUp: false,
          ));
        });
      });
    }

    Random random = Random();
    for (int cards = 0; cards < 14; cards++) {
      for (int players = 0;
          players < GameScreen.playerCardLists.length;
          players++) {
        int randomNumber = random.nextInt(allCards.length);
        var cardList = _getListFromIndex(GameScreen.playerCardLists[players]);
        PlayingCard card = allCards[randomNumber];
        cardList.add(
          card
            ..opened = true
            ..faceUp = true,
        );
        allCards.removeAt(randomNumber);
      }
    }
    cardDeckClosed = allCards;

    // add card in the bottom to the "burnt" cards
    cardDeckOpened.add(
      cardDeckClosed.removeAt(0)
        ..opened = true
        ..faceUp = true,
    );

    setState(() {});
  }

  // todo remove turning the card in the bottom of the column face-up
  void _refreshList(CardList index) {
    for (int players = 0;
        players < GameScreen.playerCardLists.length;
        players++) {
      if (_getListFromIndex(GameScreen.playerCardLists[players]).length == 0) {
        _handleWin(GameScreen.playerCardLists[players]);
      }
    }
    setState(() {
      if (_getListFromIndex(index).length != 0) {
        _getListFromIndex(index)[_getListFromIndex(index).length - 1]
          ..opened = true
          ..faceUp = true;
      }
    });
  }

  // Handle a win condition
  void _handleWin(CardList whichPlayer) {
    PositionOnScreen winnerPosition = _getPositionFromIndex(whichPlayer);
    for (int i = 0; i < playersList.length; i++) {
      playersList[i].recordGame(winnerPosition);
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Game Over"),
          content: Text(_getNameFromIndex(whichPlayer) + " won!"),
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

  String _getNameFromIndex(CardList index) {
    switch (index) {
      case CardList.P1:
        return playersList[0].name;
      case CardList.P2:
        return playersList[1].name;
      case CardList.P3:
        return playersList[2].name;
      case CardList.P4:
        return playersList[3].name;
      default:
        return "Null";
    }
  }

  PositionOnScreen _getPositionFromIndex(CardList index) {
    switch (index) {
      case CardList.P1:
        return PositionOnScreen.bottom;
      case CardList.P2:
        return PositionOnScreen.right;
      case CardList.P3:
        return PositionOnScreen.top;
      case CardList.P4:
        return PositionOnScreen.left;
      default:
        return null;
    }
  }

  Player _getNextPlayer(Player currentPlayer) {
    switch (currentPlayer.position) {
      case PositionOnScreen.bottom:
        return playersList[1];
      case PositionOnScreen.right:
        return playersList[2];
      case PositionOnScreen.top:
        return playersList[3];
      case PositionOnScreen.left:
        return playersList[0];
      default:
        return playersList[0];
    }
  }

  List<PlayingCard> _getListFromIndex(CardList index) {
    switch (index) {
      case CardList.BURNT:
        return cardDeckOpened;
      case CardList.REMAINING:
        return cardDeckClosed;
      case CardList.P1:
        return playersList[0].cards;
      case CardList.P2:
        return playersList[1].cards;
      case CardList.P3:
        return playersList[2].cards;
      case CardList.P4:
        return playersList[3].cards;
      case CardList.P1SET:
        return playersList[0].openCards;
      case CardList.P2SET:
        return playersList[1].openCards;
      case CardList.P3SET:
        return playersList[2].openCards;
      case CardList.P4SET:
        return playersList[3].openCards;
      case CardList.DROPPED:
        return droppedCards;
      default:
        return null;
    }
  }
}
