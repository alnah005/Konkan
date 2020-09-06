import 'package:flutter/material.dart';
import 'package:solitaire/models/playing_card.dart';
import 'package:solitaire/utils/playing_card_util.dart';

/// Class to visualize and regulate deck that players draw from
class KonkanDeck extends StatefulWidget {
  final int numberOfDecks;
  final int numberOfJokers;

  const KonkanDeck(
      {Key key, @required this.numberOfDecks, @required this.numberOfJokers})
      : super(key: key);

  @override
  KonkanDeckState createState() => KonkanDeckState();
}

class KonkanDeckState extends State<KonkanDeck> {
  final List<PlayingCard> _cards = [];
  var numOfPlayers = 0;
  var maxDeckCards = 106;
  @override
  void initState() {
    super.initState();
    this.initializeDecks();
  }

  @override
  Widget build(BuildContext context) {
    maxDeckCards =
        widget.numberOfDecks * 52 + widget.numberOfJokers - numOfPlayers * 14;
    maxDeckCards = maxDeckCards > _cards.length ? maxDeckCards : _cards.length;
    return Opacity(
      opacity: (_cards.length / maxDeckCards) * 0.6 + 0.4,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          height: 30.0,
          width: 20.0,
          decoration: BoxDecoration(
            color: Colors.blue,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }

  void initializeDecks() {
    for (var i = 0; i < widget.numberOfDecks; i++) {
      CardSuit.values.forEach((suit) {
        CardType.values.forEach((type) {
          if (suit != CardSuit.joker && type != CardType.joker) {
            _cards.add(PlayingCard(
              cardType: type,
              cardSuit: suit,
              faceUp: false,
            ));
          }
        });
      });
    }
    for (var i = 0; i < widget.numberOfJokers; i++) {
      _cards.add(PlayingCard(
        cardType: CardType.joker,
        cardSuit: CardSuit.joker,
        faceUp: false,
      ));
    }
    _cards.shuffle();
  }

  PlayingCard drawFromDeck([PlayingCard discarded]) {
    var result;
    if (_cards.isNotEmpty) {
      setState(() {
        result = _cards.removeLast()
          ..faceUp = false
          ..isDraggable = true
          ..opened = true;
      });
    }
    return result;
  }

  /// return  this [numCards] of [PlayingCard]
  ///
  /// removes one card at a time from deck. Shuffles, removes, shuffles...etc
  /// until it has a list of [PlayingCard] of size [numCards]
  List<PlayingCard> distributeCards(int numCards) {
    List<PlayingCard> res = [];
    for (int i = 0; i < numCards; i++) {
      res.add(_cards.removeLast()
        ..faceUp = false
        ..isDraggable = true
        ..opened = true);
      _cards.shuffle();
    }
    numOfPlayers += 1;
    return res;
  }

  void recycleDeck(List<PlayingCard> dropped) {
    print("recycling the deck..");
    if (dropped.isNotEmpty) {
      setState(() {
        _cards.addAll(dropped.map((e) => e
          ..opened = false
          ..isDraggable = false
          ..faceUp = false));
      });
    }
    if (_cards.length == (widget.numberOfDecks * 52 + widget.numberOfJokers)) {
      numOfPlayers = 0;
      print(_cards.length);
    }
    _cards.shuffle();
  }
}
