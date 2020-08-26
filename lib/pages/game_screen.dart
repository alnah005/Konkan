import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solitaire/models/groups.dart';
import 'package:solitaire/models/player.dart';
import 'package:solitaire/models/playing_card.dart';
import 'package:solitaire/widgets/card_column.dart';
import 'package:solitaire/widgets/empty_card.dart';
import 'package:solitaire/widgets/transformed_card.dart';

enum CardList { P1, P2, P3, P4, P1SET, P2SET, P3SET, P4SET, DROPPED, REMAINING }

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
  double settingScore = 51;

  // Stores the card in the upper boxes
  List<PlayingCard> droppedCards = [];

  PlayingCard drawFromDeck() {
    print(cardDeckClosed.length);
    var result = this.cardDeckClosed.removeLast()
      ..faceUp = false
      ..isDraggable = true
      ..opened = true;
    if (this.cardDeckClosed.length == 0) {
      setState(() {
        recycleDeck();
      });
    }
    return result;
  }

  void recycleDeck() {
    print("recycling the deck..");
    this.cardDeckClosed.addAll(this.droppedCards.map((e) => e
      ..opened = false
      ..isDraggable = false
      ..faceUp = false));
    this.droppedCards.clear();
    this.cardDeckClosed.shuffle();
  }

  @override
  void initState() {
    super.initState();
    _initialiseGame();
    settingScore = 51;
    currentTurn = playersList[3];
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
            flex: 5,
            fit: FlexFit.tight,
            child: _getPlayerColumn(playersList[1].cards, CardList.P2),
          ),
          Flexible(
            flex: 10,
            fit: FlexFit.tight,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _getSetListFromIndex(CardList.P2)
                            .expand((i) => i)
                            .toList()
                            .length >
                        0
                    ? _getPlayerSetColumn(CardList.P2)
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
            flex: 30,
            fit: FlexFit.tight,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Flexible(
                    flex: 3,
                    fit: FlexFit.loose,
                    child: _getPlayerColumn(playersList[0].cards, CardList.P1),
                  ),
                  Flexible(
                    flex: 10,
                    fit: FlexFit.tight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _getSetListFromIndex(CardList.P1)
                                          .expand((i) => i)
                                          .toList()
                                          .length >
                                      0
                                  ? _getPlayerSetColumn(CardList.P1)
                                      .sublist(0, 2)
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
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: _getSetListFromIndex(CardList.P1)
                                          .expand((i) => i)
                                          .toList()
                                          .length >
                                      2
                                  ? _getPlayerSetColumn(CardList.P1)
                                      .sublist(2, 4)
                                  : [
                                      Container(
                                        height: 0,
                                        width: 0,
                                      )
                                    ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                      flex: 5, fit: FlexFit.tight, child: _buildFinalDecks()),
                  Flexible(
                    flex: 10,
                    fit: FlexFit.tight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: _getSetListFromIndex(CardList.P3)
                                          .expand((i) => i)
                                          .toList()
                                          .length >
                                      0
                                  ? _getPlayerSetColumn(CardList.P3)
                                      .sublist(0, 2)
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
                          flex: 1,
                          fit: FlexFit.tight,
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: _getSetListFromIndex(CardList.P3)
                                          .expand((i) => i)
                                          .toList()
                                          .length >
                                      2
                                  ? _getPlayerSetColumn(CardList.P3)
                                      .sublist(2, 4)
                                  : [
                                      Container(
                                        height: 0,
                                        width: 0,
                                      )
                                    ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.loose,
                    child: _getPlayerColumn(playersList[2].cards, CardList.P3),
                  ),
                ],
              ),
            ),
          ),
          Flexible(flex: 4, fit: FlexFit.tight, child: _buildCardDeck()),
          Flexible(
            flex: 3,
            fit: FlexFit.tight,
            child: IconButton(
              icon: Icon(Icons.add_circle),
              tooltip: 'Set cards',
              onPressed: () {
                _handleSetCards(playersList[3]);
              },
            ),
          ),
          Flexible(
            flex: 10,
            fit: FlexFit.tight,
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: _getSetListFromIndex(CardList.P4)
                            .expand((i) => i)
                            .toList()
                            .length >
                        0
                    ? _getPlayerSetColumn(CardList.P4)
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
            flex: 10,
            fit: FlexFit.tight,
            child: _getPlayerColumn(playersList[3].cards, CardList.P4),
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
            child: Opacity(
              opacity: ((cardDeckClosed.length) / 50) * 0.6 + 0.4,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: TransformedCard(
                  // random card
                  playingCard: cardDeckClosed.last,
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
                _handleSetCards(currentTurn);

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
    );
  }

  // Initialise a new game
  void _initialiseGame() {
    for (int i = 0; i < playersList.length; i++) {
      playersList[i].initialize("Player " + (i + 1).toString());
    }
    // Stores the card deck
    cardDeckClosed = [];

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
    _refreshList();
  }

  void _refreshList([CardList index]) {
    for (int players = 0;
        players < GameScreen.playerCardLists.length;
        players++) {
      if (_getListFromIndex(GameScreen.playerCardLists[players]).length == 0) {
        _handleWin(GameScreen.playerCardLists[players]);
      }
    }
    if (index != null) {
      setState(() {
        _getListFromIndex(index);
      });
    } else {
      setState(() {});
    }
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
      case CardList.P1:
        return playersList[0].openCards;
      case CardList.P2:
        return playersList[1].openCards;
      case CardList.P3:
        return playersList[2].openCards;
      case CardList.P4:
        return playersList[3].openCards;
      default:
        return [];
    }
  }

  List<PlayingCard> _getListFromIndex(CardList index) {
    switch (index) {
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
      droppedCards.isEmpty
          ? settingScore = settingPlayer.setCards(settingScore)
          : settingScore =
              settingPlayer.setCards(settingScore, droppedCards.last);

      if (!settingPlayer.eligibleToDraw) {
        droppedCards.removeAt(droppedCards.indexOf(droppedCards.last));
        settingPlayer.discarded = false;
      }
    } else {
      settingScore = settingPlayer.setCards(settingScore);
    }
    _refreshList(_cardListFromPlayer(settingPlayer.position));
  }

  Widget _getPlayerColumn(List<PlayingCard> playerCards, CardList whichPlayer) {
    return CardColumn(
      cards: playerCards,
      onCardsAdded: (cards, index, card) {
        if (cards.first != card) {
          setState(() {
            List<PlayingCard> currentCards = _getListFromIndex(index);
            int cardIndex = currentCards.indexOf(cards.first);
            int newIndex = currentCards.indexOf(card);
            currentCards.insert(
                cardIndex >= newIndex ? newIndex : newIndex + 1, cards.first);
            currentCards.removeAt(
                cardIndex >= (newIndex + 1) ? cardIndex + 1 : cardIndex);
            _refreshList(index);
          });
        }
      },
      columnIndex: whichPlayer,
    );
  }

  List<Flexible> _getPlayerSetColumn(CardList whichPlayer) {
    return _getSetListFromIndex(whichPlayer)
        .map(
          (listCards) => Flexible(
            flex: listCards.length,
            fit: FlexFit.loose,
            child: CardColumn(
              cards: listCards,
              onCardsAdded: (cards, index, card) {
                var melds = validate(listCards);
                PlayingCard result = cards.first;
                if (melds.length > 0) {
                  result = melds[0].dropCard(cards.first);
                }
                if (result != cards.first) {
                  var returnDeck = _getListFromIndex(index);
                  if (result != null) {
                    setState(() {
                      returnDeck.add(result);
                      returnDeck.remove(cards.first);
                      _refreshList(index);
                    });
                  } else {
                    setState(() {
                      returnDeck.remove(cards.first);
                      _refreshList(index);
                    });
                  }
                }
              },
              columnIndex: whichPlayer,
              setCards: true,
            ),
          ),
        )
        .toList();
  }
}
