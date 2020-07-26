import 'dart:math';

import 'package:flutter/material.dart';
import 'package:solitaire/models/player.dart';
import 'package:solitaire/models/playing_card.dart';
import 'package:solitaire/widgets/card_column.dart';
import 'package:solitaire/widgets/empty_card.dart';
import 'package:solitaire/widgets/transformed_card.dart';

enum CardList { P1, P2, P3, P4, P1SET, P2SET, P3SET, P4SET, DROPPED, REMAINING }

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  // Stores the cards on the seven columns
  Player player1 = new Player(PositionOnScreen.bottom);
  Player player2 = new Player(PositionOnScreen.right);
  Player player3 = new Player(PositionOnScreen.top);
  Player player4 = new Player(PositionOnScreen.left);
  Player currentTurn;
  List<CardList> playerCardLists = [
    CardList.P1,
    CardList.P2,
    CardList.P3,
    CardList.P4
  ];
  // Stores the card deck
  List<PlayingCard> cardDeckClosed = [];
  List<PlayingCard> cardDeckOpened = [];

  // Stores the card in the upper boxes
  List<PlayingCard> droppedCards = [];

  @override
  void initState() {
    super.initState();
    _initialiseGame();
    currentTurn = player1;
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
                  cards: player1.cards,
                  onCardsAdded: (cards, index) {
                    setState(() {
                      player1.cards.addAll(cards);
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
                  cards: player2.cards,
                  onCardsAdded: (cards, index) {
                    setState(() {
                      player2.cards.addAll(cards);
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
                  cards: player3.cards,
                  onCardsAdded: (cards, index) {
                    setState(() {
                      player3.cards.addAll(cards);
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
                  cards: player4.cards,
                  onCardsAdded: (cards, index) {
                    setState(() {
                      player4.cards.addAll(cards);
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
                    columnIndex: CardList.REMAINING,
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
                droppedCards.addAll(cards);
                int length = _getListFromIndex(index).length;
                _getListFromIndex(index)
                    .removeRange(length - cards.length, length);
                _refreshList(index);
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
    player1.initialize('P1');
    player2.initialize('P2');
    player3.initialize('P3');
    player4.initialize('P4');

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
      for (int players = 0; players < playerCardLists.length; players++) {
        int randomNumber = random.nextInt(allCards.length);
        var cardList = _getListFromIndex(playerCardLists[players]);
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

  void _refreshList(CardList index) {
    for (int players = 0; players < playerCardLists.length; players++) {
      if (_getListFromIndex(playerCardLists[players]).length == 0) {
        _handleWin(playerCardLists[players]);
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
    switch (whichPlayer) {
      case CardList.P1:
        player1.recordGame(0, true);
        player2.recordGame(100, false);
        player3.recordGame(100, false);
        player4.recordGame(100, false);
        break;
      case CardList.P2:
        player2.recordGame(0, true);
        player1.recordGame(100, false);
        player3.recordGame(100, false);
        player4.recordGame(100, false);
        break;
      case CardList.P3:
        player3.recordGame(0, true);
        player2.recordGame(100, false);
        player1.recordGame(100, false);
        player4.recordGame(100, false);
        break;
      case CardList.P4:
        player4.recordGame(0, true);
        player2.recordGame(100, false);
        player3.recordGame(100, false);
        player1.recordGame(100, false);
        break;
      default:
        print('No player found');
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Game Over"),
          content: Text(_nameFromIndex(whichPlayer) + " won!"),
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

  String _nameFromIndex(CardList index) {
    switch (index) {
      case CardList.P1:
        return player1.name;
      case CardList.P2:
        return player2.name;
      case CardList.P3:
        return player3.name;
      case CardList.P4:
        return player4.name;
      default:
        return "Null";
    }
  }

  Player _getNextPlayer(Player currentPlayer) {
    switch (currentPlayer.position) {
      case PositionOnScreen.bottom:
        return player2;
      case PositionOnScreen.right:
        return player3;
      case PositionOnScreen.top:
        return player4;
      case PositionOnScreen.left:
        return player1;
    }
  }

  List<PlayingCard> _getListFromIndex(CardList index) {
    switch (index) {
      case CardList.REMAINING:
        return cardDeckOpened;
      case CardList.REMAINING:
        return cardDeckClosed;
      case CardList.P1:
        return player1.cards;
      case CardList.P2:
        return player2.cards;
      case CardList.P3:
        return player3.cards;
      case CardList.P4:
        return player4.cards;
      case CardList.P1SET:
        return player1.openCards;
      case CardList.P2SET:
        return player2.openCards;
      case CardList.P3SET:
        return player3.openCards;
      case CardList.P4SET:
        return player4.openCards;
      case CardList.DROPPED:
        return droppedCards;
      default:
        return null;
    }
  }
}
