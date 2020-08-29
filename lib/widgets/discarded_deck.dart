import 'package:flutter/material.dart';
import 'package:solitaire/models/base_entity.dart';
import 'package:solitaire/models/playing_card.dart';
import 'package:solitaire/widgets/transformed_card.dart';

import 'card_column.dart';

class DiscardedDeck extends StatefulWidget {
  final CardAcceptCallback onCardAdded;
  final CardWillAcceptCallback onWillAcceptAdded;
  final BaseEntity discardEntity;
  const DiscardedDeck(
      {Key key,
      @required this.onCardAdded,
      @required this.onWillAcceptAdded,
      @required this.discardEntity})
      : super(key: key);

  @override
  DiscardedDeckState createState() => DiscardedDeckState();
}

class DiscardedDeckState extends State<DiscardedDeck> {
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
            child: widget.discardEntity.cards.length == 0
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
                        children: widget.discardEntity.cards.map((card) {
                      print(widget.discardEntity.identifier);
                      return TransformedCard(
                        playingCard: card,
                        entity: widget.discardEntity,
                      );
                    }).toList()),
                  ),
          );
        },
        onWillAccept: (value) {
          return widget.onWillAcceptAdded(
              value["sourceCard"],
              value["entity"],
              widget.discardEntity.cards.isNotEmpty
                  ? widget.discardEntity.cards.last
                  : null);
        },
        onAccept: (value) {
          widget.onCardAdded(
              value["sourceCard"],
              value["entity"],
              widget.discardEntity.cards.isNotEmpty
                  ? widget.discardEntity.cards.last
                  : null);
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
      widget.discardEntity.cards.add(result);
    });
    return result;
  }

  List<PlayingCard> recycleDeck() {
    if (widget.discardEntity.cards.isEmpty) {
      return [];
    }
    var result =
        widget.discardEntity.cards.map((e) => PlayingCard.clone(e)).toList();
    setState(() {
      widget.discardEntity.cards.clear();
    });
    return result;
  }

  PlayingCard getLastCard() {
    var result;
    setState(() {
      result = widget.discardEntity.cards.isNotEmpty
          ? widget.discardEntity.cards.removeLast()
          : null;
    });
    return result;
  }
}
