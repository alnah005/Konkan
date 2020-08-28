import 'package:flutter/material.dart';
import 'package:solitaire/models/playing_card.dart';

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
  final List<PlayingCard> _dropped = [];

  @override
  void initState() {
    super.initState();
    this.initializeDecks();
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity:
          ((_cards.length) / (_cards.length + _dropped.length)) * 0.6 + 0.4,
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
    print('hello');
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
    print(_cards.length);
    var result;
    if (_cards.isNotEmpty) {
      setState(() {
        result = _cards.removeLast()
          ..faceUp = false
          ..isDraggable = true
          ..opened = true;
      });
    }
    if (discarded != null) {
      _dropped.add(discarded);
    }
    return result;
  }

  List<PlayingCard> distributeCards(int numCards) {
    print(_cards.length);
    List<PlayingCard> res = [];
    for (int i = 0; i < numCards; i++) {
      res.add(_cards.removeLast()
        ..faceUp = false
        ..isDraggable = true
        ..opened = true);
      _cards.shuffle();
    }
    return res;
  }

  void recycleDeck() {
    print("recycling the deck..");
    setState(() {
      _cards.addAll(_dropped.map((e) => e
        ..opened = false
        ..isDraggable = false
        ..faceUp = false));
      _dropped.clear();
      _cards.shuffle();
    });
  }
}
