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
    new Player(PositionOnScreen.left),
    new Player(PositionOnScreen.top),
    new Player(PositionOnScreen.right),
    new Player(PositionOnScreen.bottom)
  ];
  Player currentTurn;

  // Stores the card deck
  List<PlayingCard> cardDeckClosed = [];
  List<PlayingCard> cardDeckOpened = [];
  double settingScore = 10;
  // Stores the card in the upper boxes
  List<PlayingCard> droppedCards = [];

  @override
  void initState() {
    super.initState();
    _initialiseGame();
    currentTurn = playersList[0];
  }

// todo card_columns don't do anything when dragged to.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(4, 92, 20, 1),
      appBar: AppBar(
        title: Text("Flutter Konkan"),
        elevation: 0.0,
        backgroundColor: Color.fromRGBO(4, 92, 20, 1),
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          CardColumn(
            cards: playersList[1].cards,
            onCardsAdded: (cards, index) {
              setState(() {
                playersList[1].cards.addAll(cards);
                _getListFromIndex(index)
                    .removeAt(_getListFromIndex(index).indexOf(cards.first));
                _refreshList(index);
              });
            },
            columnIndex: CardList.P2,
          ),
          Flexible(
            child: IconButton(
              icon: Icon(Icons.add_circle),
              tooltip: 'Set cards',
              onPressed: () {
                _handleSetCards(playersList[1]);
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CardColumn(
                cards: playersList[0].cards,
                onCardsAdded: (cards, index) {
                  setState(() {
                    playersList[0].cards.addAll(cards);
                    _getListFromIndex(index).removeAt(
                        _getListFromIndex(index).indexOf(cards.first));
                    _refreshList(index);
                  });
                },
                columnIndex: CardList.P1,
              ),
              IconButton(
                icon: Icon(Icons.add_circle),
                tooltip: 'Set cards',
                onPressed: () {
                  _handleSetCards(playersList[0]);
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _buildFinalDecks(),
                ],
              ),
              IconButton(
                icon: Icon(Icons.add_circle),
                tooltip: 'Set cards',
                onPressed: () {
                  _handleSetCards(playersList[2]);
                },
              ),
              CardColumn(
                cards: playersList[2].cards,
                onCardsAdded: (cards, index) {
                  setState(() {
                    playersList[2].cards.addAll(cards);
                    _getListFromIndex(index).removeAt(
                        _getListFromIndex(index).indexOf(cards.first));
                    _refreshList(index);
                  });
                },
                columnIndex: CardList.P3,
              ),
            ],
          ),
          _buildCardDeck(),
          IconButton(
            icon: Icon(Icons.add_circle),
            tooltip: 'Set cards',
            onPressed: () {
              _handleSetCards(playersList[3]);
            },
          ),
          CardColumn(
            cards: playersList[3].cards,
            onCardsAdded: (cards, index) {
              setState(() {
                playersList[3].cards.addAll(cards);
                _getListFromIndex(index)
                    .removeAt(_getListFromIndex(index).indexOf(cards.first));
                _refreshList(index);
              });
            },
            columnIndex: CardList.P4,
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
                  if (currentTurn.eligibleToDraw) {
                    currentTurn.cards.add(
                      cardDeckClosed.removeLast()
                        ..faceUp = true
                        ..opened = true,
                    );
                    currentTurn.discarded = false;
                    currentTurn.eligibleToDraw = false;
                  } else {
                    print("you need to throw a card");
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
//                    attachedCards: [
//                      cardDeckOpened.last,
//                    ],
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
      child: Stack(
        children: <Widget>[
          Container(
            decoration: ShapeDecoration(
              shape: StadiumBorder(),
              color: Color.fromRGBO(135, 0, 0, 1),
            ),
            height: 88,
            width: 68,
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: EmptyCardDeck(
              cardSuit: CardSuit.hearts,
              cardsAdded: droppedCards,
              onCardAdded: (cards, index) {
                if (_getPositionFromIndex(index) == currentTurn.position &&
                    !currentTurn.discarded) {
                  droppedCards.add(cards.first);
                  _getListFromIndex(index)
                      .removeAt(_getListFromIndex(index).indexOf(cards.first));
                  _refreshList(index);
                  currentTurn = _getNextPlayer(currentTurn);
                  currentTurn.initializeForNextTurn();
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
      playersList[i].initialize("Player " + (i + 1).toString());
    }
    // Stores the card deck
    cardDeckClosed = [];
    cardDeckOpened = [];

    // Stores the card in the upper boxes
    droppedCards = [];

    List<PlayingCard> allCards = [];

    // Add all cards to deck
    for (var i = 0; i < 2; i++) {
      /// This adds one joker per loop (per deck.)
      allCards.add(PlayingCard(
        cardType: CardType.joker,
        cardSuit: CardSuit.joker,
        faceUp: false,
      ));
      CardSuit.values.forEach((suit) {
        CardType.values.forEach((type) {
          /// if the card is a joker then it is discarded.
          if ((type != CardType.joker) && (suit != CardSuit.joker)) {
            allCards.add(PlayingCard(
              cardType: type,
              cardSuit: suit,
              faceUp: false,
            ));
          }
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
      cardDeckClosed.removeAt(random.nextInt(allCards.length))
        ..opened = true
        ..faceUp = true,
    );
    // todo know the purpose of this set state
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
        return PositionOnScreen.left;
      case CardList.P2:
        return PositionOnScreen.top;
      case CardList.P3:
        return PositionOnScreen.right;
      case CardList.P4:
        return PositionOnScreen.bottom;
      default:
        return null;
    }
  }

  Player _getNextPlayer(Player currentPlayer) {
    switch (currentPlayer.position) {
      case PositionOnScreen.left:
        return playersList[1];
      case PositionOnScreen.top:
        return playersList[2];
      case PositionOnScreen.right:
        return playersList[3];
      case PositionOnScreen.bottom:
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
//      case CardList.P1SET:
//        return playersList[0].openCards;
//      case CardList.P2SET:
//        return playersList[1].openCards;
//      case CardList.P3SET:
//        return playersList[2].openCards;
//      case CardList.P4SET:
//        return playersList[3].openCards;
      case CardList.DROPPED:
        return droppedCards;
      default:
        return null;
    }
  }

  CardList _cardListFromPlayer(PositionOnScreen pos) {
    switch (pos) {
      case PositionOnScreen.left:
        return CardList.P1;
      case PositionOnScreen.top:
        return CardList.P2;
      case PositionOnScreen.right:
        return CardList.P3;
      case PositionOnScreen.bottom:
        return CardList.P4;
      default:
        return null;
    }
  }

  void _handleSetCards(Player settingPlayer) {
    if (settingPlayer != currentTurn) {
      print("Its not your turn");
      return;
    }
    if (settingPlayer.discarded) {
      settingScore = settingPlayer.setCards(settingScore, droppedCards.last);
      if (!settingPlayer.eligibleToDraw) {
        settingPlayer.discarded = false;
      }
    } else {
      settingScore = settingPlayer.setCards(settingScore);
    }
    _refreshList(_cardListFromPlayer(settingPlayer.position));
  }
}
