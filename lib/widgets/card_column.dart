import 'package:flutter/material.dart';
import 'package:solitaire/models/playing_card.dart';
import 'package:solitaire/pages/game_screen.dart';
import 'package:solitaire/widgets/transformed_card.dart';

typedef Null CardAcceptCallback(List<PlayingCard> card, CardList fromIndex);

// This is a stack of overlayed cards (implemented using a stack)
class CardColumn extends StatefulWidget {
  // List of cards in the stack
  final List<PlayingCard> cards;

  // Callback when card is added to the stack
  final CardAcceptCallback onCardsAdded;

  // The index of the list in the game
  final CardList columnIndex;

  CardColumn(
      {@required this.cards,
      @required this.onCardsAdded,
      @required this.columnIndex});

  @override
  _CardColumnState createState() => _CardColumnState();
}

class _CardColumnState extends State<CardColumn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      height: 4 * 20.0,
      width: 70.0,
      margin: EdgeInsets.all(2.0),
      child: DragTarget<Map>(
        builder: (context, listOne, listTwo) {
          return Stack(
            children: widget.cards.map((card) {
              int index = widget.cards.indexOf(card);
              return TransformedCard(
                playingCard: card,
                transformIndex: index,
                attachedCards: widget.cards.sublist(index, widget.cards.length),
                columnIndex: widget.columnIndex,
              );
            }).toList(),
          );
        },
        onWillAccept: (value) {
          CardList index = value["fromIndex"];
          if (index == widget.columnIndex) {
            print('Goodjob');
            return true;
          }
          return false;
        },
        onAccept: (value) {
          widget.onCardsAdded(
            value["cards"],
            value["fromIndex"],
          );
        },
      ),
    );
  }
}
