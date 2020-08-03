import 'package:flutter/material.dart';
import 'package:solitaire/models/playing_card.dart';
import 'package:solitaire/pages/game_screen.dart';
import 'package:solitaire/widgets/transformed_card.dart';

typedef Null CardAcceptCallback(
    List<PlayingCard> card, CardList fromIndex, PlayingCard cardAfter);

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
    return _horizontal()
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[_getCardColumn()],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[_getCardColumn()],
          );
  }

  Widget _getCardColumn() {
    return Container(
        height: _horizontal() ? 60 : (widget.cards.length * 20.0) + 60,
        width: _horizontal() ? (widget.cards.length * 20.0) + 40 : 40,
        alignment: Alignment.topCenter,
        margin: EdgeInsets.all(2.0),
        child: widget.cards.length > 0
            ? Stack(
                children: widget.cards.map((card) {
                  int index = widget.cards.indexOf(card);
                  return dragTarget(card, index);
                }).toList(),
              )
            : Container());
  }

  Positioned dragTarget(PlayingCard card, int index) {
    return Positioned(
      left: _horizontal() ? -index.roundToDouble() * -20 : 0,
      top: _horizontal() ? 0 : index.roundToDouble() * 20,
      child: DragTarget<Map>(
        builder: (context, listOne, listTwo) {
          return transformedCard(card, index);
        },
        onWillAccept: (value) {
          CardList index = value["fromIndex"];
          if (index == widget.columnIndex) {
            return true;
          }
          return false;
        },
        onAccept: (value) {
          widget.onCardsAdded(value["cards"], value["fromIndex"], card);
        },
      ),
    );
  }

  Widget transformedCard(PlayingCard card, int index) {
    return TransformedCard(
      playingCard: card,
//      transformIndex: index,
//                        attachedCards:
//                            widget.cards.sublist(index, widget.cards.length),
      columnIndex: widget.columnIndex,
    );
  }

  bool _horizontal() {
    switch (widget.columnIndex) {
      case CardList.P1:
        return false;
      case CardList.P2:
        return true;
      case CardList.P3:
        return false;
      case CardList.P4:
        return true;
      default:
        return false;
    }
  }
}
