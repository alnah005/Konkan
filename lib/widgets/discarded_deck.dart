import 'package:flutter/material.dart';
import 'package:solitaire/models/playing_card.dart';
import 'package:solitaire/utils/enums.dart';
import 'package:solitaire/widgets/transformed_card.dart';

import 'card_column.dart';

class DiscardedDeck extends StatefulWidget {
  final CardAcceptCallback onCardAdded;
  final CardList columnIndex;
  const DiscardedDeck(
      {Key key, @required this.onCardAdded, @required this.columnIndex})
      : super(key: key);

  @override
  DiscardedDeckState createState() => DiscardedDeckState();
}

class DiscardedDeckState extends State<DiscardedDeck> {
  final List<PlayingCard> _cards = [];
  final List<CardList> playerCardLists = [
    CardList.P1,
    CardList.P2,
    CardList.P3,
    CardList.P4
  ];
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return DragTarget<Map>(
        builder: (context, listOne, listTwo) {
          double containerHeight;
          double containerWidth;
          double padSize;
          if (orientation == Orientation.portrait) {
            containerHeight = ((MediaQuery.of(context).size.height / 737) * 80)
                .floorToDouble();
            containerWidth = containerHeight * 0.75;
            padSize = ((MediaQuery.of(context).size.height / 737) * 10)
                .floorToDouble();
          } else {
            containerHeight = ((MediaQuery.of(context).size.height / 392) * 80)
                .floorToDouble();
            containerWidth = containerHeight * 0.75;
            padSize = ((MediaQuery.of(context).size.height / 392) * 10)
                .floorToDouble();
          }
          return Container(
            height: containerHeight,
            width: containerWidth,
            padding: EdgeInsets.all(padSize),
            child: _cards.length == 0
                ? Opacity(
                    opacity: 0.7,
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Colors.white,
                        image: DecorationImage(
                          image: NetworkImage(
                            "https://spectramagazine.org/wp-content/uploads/2018/09/bb.jpg",
                          ),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: containerHeight - 2 * padSize,
                    width: containerWidth - 2 * padSize,
                    child: Stack(
                        children: _cards.map((card) {
                      return TransformedCard(
                        playingCard: card,
                        columnIndex: widget.columnIndex,
                      );
                    }).toList()),
                  ),
          );
        },
        onWillAccept: (value) {
          CardList cardIndex = value["fromIndex"];
          for (int players = 0; players < playerCardLists.length; players++) {
            if (cardIndex == playerCardLists[players]) {
              return true;
            }
          }
          return false;
        },
        onAccept: (value) {
          widget.onCardAdded(value["cards"], value["fromIndex"],
              value["cards"].length > 0 ? value["cards"][0] : null);
        },
      );
    });
  }

  PlayingCard throwToDeck(PlayingCard discarded) {
    var result = discarded
      ..faceUp = true
      ..isDraggable = true
      ..opened = true;
    setState(() {
      _cards.add(result);
    });
    return result;
  }

  List<PlayingCard> recycleDeck() {
    if (_cards.isEmpty) {
      return [];
    }
    var result = _cards.map((e) => PlayingCard.clone(e)).toList();
    setState(() {
      _cards.clear();
    });
    return result;
  }

  PlayingCard getLastCard() {
    var result;
    setState(() {
      result = _cards.isNotEmpty ? _cards.removeLast() : null;
    });
    return result;
  }
}
