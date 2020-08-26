import 'package:flutter/cupertino.dart';
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
  final bool setCards;
  CardColumn(
      {@required this.cards,
      @required this.onCardsAdded,
      @required this.columnIndex,
      this.setCards = false});

  @override
  _CardColumnState createState() => _CardColumnState();
}

class _CardColumnState extends State<CardColumn> {
  double translation;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double optimalTranslation = (width - 40) / 14;
    translation = widget.columnIndex == CardList.P4
        ? optimalTranslation
        : optimalTranslation / 2;
    translation = !_horizontal()
        ? height < width ? translation / 8.5 : translation
        : translation;
    return Container(
      width: _horizontal()
          ? double.infinity
          : widget.columnIndex == CardList.P4 ? 40 : 20,
      height: _horizontal()
          ? widget.columnIndex == CardList.P4 ? 60 : 30
          : double.infinity,
      child: _horizontal()
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[_getCardColumn()],
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[_getCardColumn()],
            ),
    );
  }

  Widget _getCardColumn() {
    return widget.cards.length > 0
        ? Flexible(
            fit: FlexFit.loose,
            child: Stack(
              children: widget.cards.map((card) {
                int index = widget.cards.indexOf(card);
                return dragTarget(card, index);
              }).toList(),
            ),
          )
        : Container();
  }

  Positioned dragTarget(PlayingCard card, int index) {
    return Positioned(
      left: _horizontal() ? -index.roundToDouble() * -translation : 0,
      top: _horizontal() ? 0 : index.roundToDouble() * translation,
      child: DragTarget<Map>(
        builder: (context, listOne, listTwo) {
          return transformedCard(card, index);
        },
        onWillAccept: (value) {
          CardList index = value["fromIndex"];
          if ((index == widget.columnIndex) ||
              (isAPlayerDeck(index) && widget.setCards)) {
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
      columnIndex: widget.columnIndex,
    );
  }

  bool isAPlayerDeck(CardList index) {
    switch (index) {
      case CardList.P1:
        return true;
      case CardList.P2:
        return true;
      case CardList.P3:
        return true;
      case CardList.P4:
        return true;
      default:
        return false;
    }
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
