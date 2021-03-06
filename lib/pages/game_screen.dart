import 'dart:math';

import 'package:flutter/cupertino.dart';
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
    new Player(PositionOnScreen.left, isAI: true),
    new Player(PositionOnScreen.top, isAI: true),
    new Player(PositionOnScreen.right, isAI: true),
    new Player(PositionOnScreen.bottom)
  ];
  Player currentTurn;

  // Stores the card deck
  List<PlayingCard> cardDeckClosed = [];
  List<PlayingCard> cardDeckOpened = [];
  double settingScore = 51;

  // Stores the card in the upper boxes
  List<PlayingCard> droppedCards = [];

  PlayingCard drawFromDeck() {
    if (this.cardDeckClosed.length == 0) {
      this.recycleDeck();
    }

    return this.cardDeckClosed.removeLast()
      ..faceUp = false
      ..isDraggable = true
      ..opened = true;
  }

  void recycleDeck() {
    /// pulling out the last card so that it stays on the dropped cards stack
    print("recycling the deck..");
    var lastCard = this.droppedCards.removeLast();
    this.cardDeckClosed.addAll(this.droppedCards.map((e) => e
      ..opened = false
      ..isDraggable = false
      ..faceUp = false));
    this.droppedCards.clear();

    /// adding back the last card to the dropped cards stack
    this.droppedCards.add(lastCard);
    this.cardDeckClosed.shuffle();
  }

  @override
  void initState() {
    super.initState();
    _initialiseGame();
    currentTurn = playersList[3];
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
            flex: 3,
            fit: FlexFit.loose,
            child: CardColumn(
              cards: playersList[1].cards,
              onCardsAdded: (cards, index, card) {
                if (cards.first != card) {
                  setState(() {
                    List<PlayingCard> currentCards = _getListFromIndex(index);
                    int cardIndex = currentCards.indexOf(cards.first);
                    int newIndex = currentCards.indexOf(card);
                    currentCards.insert(
                        cardIndex >= newIndex ? newIndex : newIndex + 1,
                        cards.first);
                    currentCards.removeAt(cardIndex >= (newIndex + 1)
                        ? cardIndex + 1
                        : cardIndex);
                    _refreshList(index);
                  });
                }
              },
              columnIndex: CardList.P2,
            ),
          ),
          Flexible(
            flex: 7,
            fit: FlexFit.loose,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _getSetListFromIndex(CardList.P2SET)
                            .expand((i) => i)
                            .toList()
                            .length >
                        0
                    ? _getSetListFromIndex(CardList.P2SET)
                        .map(
                          (listCards) => CardColumn(
                            cards: listCards,
                            onCardsAdded: (cards, index, card) {},
                            columnIndex: CardList.P2,
                          ),
                        )
                        .toList()
                    : [
                        Container(
                          height: 0,
                          width: 0,
                        )
                      ],
              ),
            ),
          ),
//          Flexible(
//            fit: FlexFit.loose,
//            child: IconButton(
//              icon: Icon(Icons.add_circle),
//              tooltip: 'Set cards',
//              onPressed: () {
//                _handleSetCards(playersList[1]);
//              },
//            ),
//          ),
          Flexible(
            flex: 10,
            fit: FlexFit.loose,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Flexible(
                    flex: 3,
                    fit: FlexFit.loose,
                    child: CardColumn(
                      cards: playersList[0].cards,
                      onCardsAdded: (cards, index, card) {
                        if (cards.first != card) {
                          setState(() {
                            List<PlayingCard> currentCards =
                                _getListFromIndex(index);
                            int cardIndex = currentCards.indexOf(cards.first);
                            int newIndex = currentCards.indexOf(card);
                            currentCards.insert(
                                cardIndex >= newIndex ? newIndex : newIndex + 1,
                                cards.first);
                            currentCards.removeAt(cardIndex >= (newIndex + 1)
                                ? cardIndex + 1
                                : cardIndex);
                            _refreshList(index);
                          });
                        }
                      },
                      columnIndex: CardList.P1,
                    ),
                  ),
                  Flexible(
                    flex: 7,
                    fit: FlexFit.loose,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _getSetListFromIndex(CardList.P1SET)
                                    .expand((i) => i)
                                    .toList()
                                    .length >
                                0
                            ? _getSetListFromIndex(CardList.P1SET)
                                .map(
                                  (listCards) => CardColumn(
                                    cards: listCards,
                                    onCardsAdded: (cards, index, card) {},
                                    columnIndex: CardList.P1,
                                  ),
                                )
                                .toList()
                            : [
                                Container(
                                  height: 0,
                                  width: 0,
                                )
                              ],
                      ),
                    ),
                  ),
//                  Flexible(
//                    flex: 1,
//                    fit: FlexFit.loose,
//                    child: IconButton(
//                      icon: Icon(Icons.add_circle),
//                      tooltip: 'Set cards',
//                      onPressed: () {
//                        _handleSetCards(playersList[0]);
//                      },
//                    ),
//                  ),
                  Flexible(
                      flex: 7, fit: FlexFit.loose, child: _buildFinalDecks()),
//                  Flexible(
//                    flex: 1,
//                    fit: FlexFit.loose,
//                    child: IconButton(
//                      icon: Icon(Icons.add_circle),
//                      tooltip: 'Set cards',
//                      onPressed: () {
//                        _handleSetCards(playersList[2]);
//                      },
//                    ),
//                  ),
                  Flexible(
                    flex: 7,
                    fit: FlexFit.loose,
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: _getSetListFromIndex(CardList.P3SET)
                                    .expand((i) => i)
                                    .toList()
                                    .length >
                                0
                            ? _getSetListFromIndex(CardList.P3SET)
                                .map(
                                  (listCards) => CardColumn(
                                    cards: listCards,
                                    onCardsAdded: (cards, index, card) {},
                                    columnIndex: CardList.P3,
                                  ),
                                )
                                .toList()
                            : [
                                Container(
                                  height: 0,
                                  width: 0,
                                )
                              ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 3,
                    fit: FlexFit.loose,
                    child: CardColumn(
                      cards: playersList[2].cards,
                      onCardsAdded: (cards, index, card) {
                        if (cards.first != card) {
                          setState(() {
                            List<PlayingCard> currentCards =
                                _getListFromIndex(index);
                            int cardIndex = currentCards.indexOf(cards.first);
                            int newIndex = currentCards.indexOf(card);
                            currentCards.insert(
                                cardIndex >= newIndex ? newIndex : newIndex + 1,
                                cards.first);
                            currentCards.removeAt(cardIndex >= (newIndex + 1)
                                ? cardIndex + 1
                                : cardIndex);
                            _refreshList(index);
                          });
                        }
                      },
                      columnIndex: CardList.P3,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Flexible(flex: 5, fit: FlexFit.loose, child: _buildCardDeck()),
          Flexible(
            flex: 5,
            fit: FlexFit.loose,
            child: IconButton(
              icon: Icon(Icons.add_circle),
              tooltip: 'Set cards',
              onPressed: () {
                _handleSetCards(playersList[3]);
              },
            ),
          ),
          Flexible(
            flex: 7,
            fit: FlexFit.loose,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _getSetListFromIndex(CardList.P4SET)
                            .expand((i) => i)
                            .toList()
                            .length >
                        0
                    ? _getSetListFromIndex(CardList.P4SET)
                        .map(
                          (listCards) => Flexible(
                            fit: FlexFit.loose,
                            child: CardColumn(
                              cards: listCards,
                              onCardsAdded: (cards, index, card) {},
                              columnIndex: CardList.P4,
                            ),
                          ),
                        )
                        .toList()
                    : [
                        Container(
                          height: 0,
                          width: 0,
                        )
                      ],
              ),
            ),
          ),
          Flexible(
            flex: 7,
            fit: FlexFit.loose,
            child: CardColumn(
              cards: playersList[3].cards,
              onCardsAdded: (cards, index, card) {
                if (cards.first != card) {
                  setState(() {
                    List<PlayingCard> currentCards = _getListFromIndex(index);
                    int cardIndex = currentCards.indexOf(cards.first);
                    int newIndex = currentCards.indexOf(card);
                    currentCards.insert(
                        cardIndex >= newIndex ? newIndex : newIndex + 1,
                        cards.first);
                    currentCards.removeAt(cardIndex >= (newIndex + 1)
                        ? cardIndex + 1
                        : cardIndex);
                    _refreshList(index);
                  });
                }
              },
              columnIndex: CardList.P4,
            ),
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
                    var newCard = this.drawFromDeck();
                    newCard.faceUp = true;
                    currentTurn.cards.add(newCard);
                    currentTurn.discarded = false;
                    currentTurn.eligibleToDraw = false;
                  } else {
                    print("you need to throw a card");
                  }
                }
              });
            },
          ),
//          cardDeckOpened.isNotEmpty
//              ? Padding(
//                  padding: const EdgeInsets.all(4.0),
//                  child: TransformedCard(
//                    playingCard: cardDeckOpened.last,
////                    attachedCards: [
////                      cardDeckOpened.last,
////                    ],
//                    columnIndex: CardList.BURNT,
//                  ),
//                )
//              : Container(
//                  width: 40.0,
//                ),
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
              shadows: [
                BoxShadow(
                  offset: const Offset(3.0, 3.0),
                  blurRadius: 5.0,
                  spreadRadius: 2.0,
                )
              ],
            ),
            // todo fix this for all kinds of devices using Build Context
            height: 88,
            width: 68,
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: EmptyCardDeck(
              cardSuit: CardSuit.hearts,
              cardsAdded: droppedCards,
              onCardAdded: (cards, index, card) {
                if (_getPositionFromIndex(index) == currentTurn.position &&
                    !currentTurn.discarded) {
                  droppedCards.add(cards.first..isDraggable = true);
                  _getListFromIndex(index)
                      .removeAt(_getListFromIndex(index).indexOf(cards.first));
                  _refreshList(index);
                  currentTurn = _getNextPlayer(currentTurn);

                  while (currentTurn.isAI) {
                    currentTurn.cards.shuffle();

                    /// in the commented line below, I tried to add some time before
                    /// the AI makes a decision but it needs to have an asynchronous
                    /// environment. This needs a lot of refactoring to the code.
                    //await new Future.delayed(const Duration(seconds: 5));

                    /// We can use this code however this freezes everything for the
                    /// set period of time, making the screen seem laggy or glitched.
                    //sleep(const Duration(seconds:1));

                    currentTurn.cards.add(this.drawFromDeck());
                    var throwCard = currentTurn.cards[1];
                    throwCard.faceUp = true;
                    throwCard.isDraggable = true;
                    droppedCards.add(throwCard);
                    currentTurn.cards.removeAt(1);
                    currentTurn = _getNextPlayer(currentTurn);
                    currentTurn.initializeForNextTurn();
                  }

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
        playersList[players].isAI
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

  List<List<PlayingCard>> _getSetListFromIndex(CardList index) {
    switch (index) {
      case CardList.P1SET:
        return playersList[0].openCards;
      case CardList.P2SET:
        return playersList[1].openCards;
      case CardList.P3SET:
        return playersList[2].openCards;
      case CardList.P4SET:
        return playersList[3].openCards;
      default:
        return [];
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
      case CardList.DROPPED:
        return droppedCards;
      default:
        return [];
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
        droppedCards.removeAt(droppedCards.indexOf(droppedCards.last));
        settingPlayer.discarded = false;
      }
    } else {
      settingScore = settingPlayer.setCards(settingScore);
    }
    _refreshList(_cardListFromPlayer(settingPlayer.position));
  }
}
