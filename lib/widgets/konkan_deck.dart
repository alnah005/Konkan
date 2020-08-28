import 'package:flutter/material.dart';
import 'package:solitaire/models/playing_card.dart';
import 'package:solitaire/utils/enums.dart';
import 'package:solitaire/widgets/transformed_card.dart';

class KonkanDeck extends StatefulWidget {
  final int numberOfDecks;
  final int numberOfJokers;

  const KonkanDeck({Key key, this.numberOfDecks, this.numberOfJokers})
      : super(key: key);

  @override
  KonkanDeckState createState() => KonkanDeckState();
}

class KonkanDeckState extends State<KonkanDeck> {
  final List<PlayingCard> _cards = [];
  final List<PlayingCard> _dropped = [];

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity:
          ((_cards.length) / (_cards.length + _dropped.length)) * 0.6 + 0.4,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: TransformedCard(
          // random card
          playingCard: _cards.last,
          columnIndex: CardList.REMAINING,
        ),
      ),
    );
  }

  void initializeDecks() {
    for (var i = 0; i < widget.numberOfDecks; i++) {
      CardSuit.values.forEach((suit) {
        CardType.values.forEach((type) {
          _cards.add(PlayingCard(
            cardType: type,
            cardSuit: suit,
            faceUp: false,
          ));
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

  PlayingCard drawFromDeck(PlayingCard discarded) {
    print(_cards.length);
    var result = _cards.removeLast()
      ..faceUp = false
      ..isDraggable = true
      ..opened = true;
    _dropped.add(discarded);
    return result;
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
