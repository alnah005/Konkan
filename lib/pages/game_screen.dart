import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:solitaire/models/base_entity.dart';
import 'package:solitaire/models/player.dart';
import 'package:solitaire/models/playing_card.dart';
import 'package:solitaire/utils/enums.dart';
import 'package:solitaire/widgets/discarded_deck.dart';
import 'package:solitaire/widgets/konkan_deck.dart';
import 'package:solitaire/widgets/player_widget.dart';

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
  List<Player> playerObjects = [
    new Player(CardList.P1, isAI: true),
    new Player(CardList.P2, isAI: true),
    new Player(CardList.P3, isAI: true),
    new Player(CardList.P4)
  ];
  Player currentTurn;

  // Stores the card deck
  double settingScore = 51;
  GlobalKey<KonkanDeckState> deckKey = GlobalKey();
  GlobalKey<DiscardedDeckState> discardedDeckKey = GlobalKey();
  var deck;
  var discardedDeck;
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

  @override
  void initState() {
    super.initState();
    deck = KonkanDeck(
      key: deckKey,
      numberOfDecks: 2,
      numberOfJokers: 2,
    );
    discardedDeck = DiscardedDeck(
      key: discardedDeckKey,
      onWillAcceptAdded: (sourceCard, player, destinationCard) {
        print(player.identifier);
        if (GameScreen.playerCardLists.contains(player.identifier)) {
          return true;
        }
        return false;
      },
      onCardAdded: (sourceCard, player, destinationCard) {
        if (player.identifier == currentTurn.identifier &&
            !currentTurn.discarded) {
          discardedDeckKey.currentState
              .throwToDeck(sourceCard..isDraggable = true);
          setState(() {
            player.cards.removeAt(player.cards.indexOf(sourceCard));
          });
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
            discardedDeckKey.currentState.throwToDeck(throwCard);
            currentTurn.cards.removeAt(1);
            currentTurn = _getNextPlayer(currentTurn);
            currentTurn.initializeForNextTurn();
          }

          currentTurn.initializeForNextTurn();
        }
      },
      discardEntity: BaseEntity(CardList.DROPPED),
    );
    Future.delayed(const Duration(milliseconds: 30), () {
      /// Anything that uses a key will go here.
      _initialiseGame();
      currentTurn = playerObjects[3];
    });
    settingScore = 51;
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
              player: playerObjects[1],
              horizontal: true,
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
                      player: playerObjects[0],
                    ),
                  ),
                  Expanded(child: Container()),
                  Flexible(
                      flex: 10, fit: FlexFit.loose, child: _buildFinalDecks()),
                  Flexible(
                    flex: 7,
                    fit: FlexFit.loose,
                    child: PlayerWidget(
                      player: playerObjects[2],
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
                _handleSetCards(playerObjects[3]);
              },
            ),
          ),
          Flexible(
              flex: 7,
              fit: FlexFit.loose,
              child: PlayerWidget(
                player: playerObjects[3],
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
            child: deck,
            onTap: () {
              setState(() {
                if (currentTurn.eligibleToDraw) {
                  var newCard = this.drawFromDeck();
                  newCard.faceUp = true;
                  currentTurn.cards.add(newCard);
                  currentTurn.discarded = false;
                  currentTurn.eligibleToDraw = false;
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
        child: discardedDeck,
      ),
    );
  }

  // Initialise a new game
  void _initialiseGame() {
    /// Discard all player cards to discarded deck
    for (int players = 0;
        players < GameScreen.playerCardLists.length;
        players++) {
      var cardList = _getListFromIndex(GameScreen.playerCardLists[players]);
      var setCardList =
          _getSetListFromIndex(GameScreen.playerCardLists[players]);
      cardList.forEach((e) => discardedDeckKey.currentState.throwToDeck(e));
      setCardList.forEach((e) => e.forEach((element) {
            discardedDeckKey.currentState.throwToDeck(element);
          }));
    }

    /// clear all player decks
    for (int i = 0; i < playerObjects.length; i++) {
      playerObjects[i].initialize(playerObjects[i].name);
    }

    /// move all discarded cards to main deck
    this.recycleDecks();

    /// redistribute cards to players
    for (int players = 0;
        players < GameScreen.playerCardLists.length;
        players++) {
      var cardList = _getListFromIndex(GameScreen.playerCardLists[players]);
      for (var card in deckKey.currentState.distributeCards(14)) {
        playerObjects[players].isAI
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

    /// refresh player cards
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
      setState(() {
        for (int players = 0;
            players < GameScreen.playerCardLists.length;
            players++) {
          _getListFromIndex(GameScreen.playerCardLists[players]);
        }
      });
    }
  }

  // Handle a win condition
  void _handleWin(CardList whichPlayer) {
    for (int i = 0; i < playerObjects.length; i++) {
      playerObjects[i].recordGame(whichPlayer);
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
        return playerObjects[0].name;
      case CardList.P2:
        return playerObjects[1].name;
      case CardList.P3:
        return playerObjects[2].name;
      case CardList.P4:
        return playerObjects[3].name;
      default:
        return "Null";
    }
  }

  Player _getNextPlayer(Player currentPlayer) {
    switch (currentPlayer.identifier) {
      case CardList.P1:
        return playerObjects[1];
      case CardList.P2:
        return playerObjects[2];
      case CardList.P3:
        return playerObjects[3];
      case CardList.P4:
        return playerObjects[0];
      default:
        return null;
    }
  }

  List<List<PlayingCard>> _getSetListFromIndex(CardList index) {
    switch (index) {
      case CardList.P1:
        return playerObjects[0].openCards;
      case CardList.P2:
        return playerObjects[1].openCards;
      case CardList.P3:
        return playerObjects[2].openCards;
      case CardList.P4:
        return playerObjects[3].openCards;
      default:
        return [];
    }
  }

  List<PlayingCard> _getListFromIndex(CardList index) {
    switch (index) {
      case CardList.P1:
        return playerObjects[0].cards;
      case CardList.P2:
        return playerObjects[1].cards;
      case CardList.P3:
        return playerObjects[2].cards;
      case CardList.P4:
        return playerObjects[3].cards;
      default:
        return [];
    }
  }

  void _handleSetCards(Player settingPlayer) {
    if (settingPlayer != currentTurn) {
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
    _refreshList(settingPlayer.identifier);
  }
}
