import 'package:flutter/material.dart';
import 'package:solitaire/models/base_entity.dart';
import 'package:solitaire/models/playing_card.dart';
import 'package:solitaire/utils/enums.dart';
import 'package:solitaire/widgets/transformed_card.dart';

import 'card_column.dart';

class DiscardedDeck extends StatefulWidget {
  final CardAcceptCallback onCardAdded;
  final CardWillAcceptCallback onWillAcceptAdded;
  const DiscardedDeck({
    Key key,
    @required this.onCardAdded,
    @required this.onWillAcceptAdded,
  }) : super(key: key);

  @override
  DiscardedDeckState createState() => DiscardedDeckState();
}

class DiscardedDeckState extends State<DiscardedDeck> {
  BaseEntity discardEntity = BaseEntity(CardList.DROPPED);

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
            child: discardEntity.cards.length == 0
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
                        children: discardEntity.cards.map((card) {
                      return TransformedCard(
                        playingCard: card,
                        entity: discardEntity,
                      );
                    }).toList()),
                  ),
          );
        },
        onWillAccept: (value) {
          return widget.onWillAcceptAdded(value["sourceCard"], value["entity"],
              discardEntity.cards.isNotEmpty ? discardEntity.cards.last : null);
        },
        onAccept: (value) {
          widget.onCardAdded(value["sourceCard"], value["entity"],
              discardEntity.cards.isNotEmpty ? discardEntity.cards.last : null);
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
      discardEntity.cards.add(result);
    });
    return result;
  }

  /// Creates a copy of all discarded cards and returns the copy
  /// it also deletes the original list that is getting rendered
  List<PlayingCard> recycleDeck() {
    if (discardEntity.cards.isEmpty) {
      return [];
    }
    var result = discardEntity.cards.map((e) => PlayingCard.clone(e)).toList();
    setState(() {
      discardEntity.cards.clear();
    });
    return result;
  }

  PlayingCard getLastCard() {
    var result;
    setState(() {
      result = discardEntity.cards.isNotEmpty
          ? discardEntity.cards.removeLast()
          : null;
    });
    return result;
  }
}
