import 'package:flutter/material.dart';
import 'package:solitaire/models/playing_card.dart';
import 'package:solitaire/utils/enums.dart';
import 'package:solitaire/widgets/transformed_card.dart';

class DiscardedDeck extends StatefulWidget {
  const DiscardedDeck({Key key}) : super(key: key);

  @override
  DiscardedDeckState createState() => DiscardedDeckState();
}

class DiscardedDeckState extends State<DiscardedDeck> {
  final List<PlayingCard> _cards = [];

  @override
  Widget build(BuildContext context) {
    return _cards.isEmpty
        ? Container()
        : TransformedCard(
            playingCard: _cards.last,
            columnIndex: CardList.DROPPED,
          );
  }

  PlayingCard throwToDeck(PlayingCard discarded) {
    var result = discarded
      ..faceUp = true
      ..isDraggable = true
      ..opened = true;
    _cards.add(result);
    return result;
  }

  List<PlayingCard> recycle() {
    var result = _cards;
    _cards.clear();
    return result;
  }
}
