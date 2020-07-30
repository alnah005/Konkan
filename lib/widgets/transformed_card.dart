import 'package:flutter/material.dart';
import 'package:solitaire/models/playing_card.dart';
import 'package:solitaire/pages/game_screen.dart';

// TransformedCard makes the card draggable and translates it according to
// position in the stack.
class TransformedCard extends StatefulWidget {
  final PlayingCard playingCard;
  final double transformDistance;
  final CardList columnIndex;

//  final List<PlayingCard> attachedCards;

  TransformedCard({
    @required this.playingCard,
    this.transformDistance = 20.0,
    this.columnIndex,
//    this.attachedCards,
  });

  @override
  _TransformedCardState createState() => _TransformedCardState();
}

class _TransformedCardState extends State<TransformedCard> {
  @override
  Widget build(BuildContext context) {
    return _buildCard();
  }

  Widget _buildCard() {
    return !widget.playingCard.faceUp
        ? Container(
            height: 60.0,
            width: 40.0,
            decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8.0),
            ),
          )
        : Draggable<Map>(
            child: _buildFaceUpCard(),
            feedback: _buildFaceUpCard(),
            childWhenDragging: Container(
              width: 40.0,
              height: 60.0,
            ),
            data: {
              "cards": [widget.playingCard],
              "fromIndex": widget.columnIndex,
            },
          );
  }

  Widget _buildFaceUpCard() {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
          border: Border.all(color: Colors.black),
        ),
        height: 60.0,
        width: 40,
        child: Stack(
          children: <Widget>[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Center(
                    child: Text(
                      widget.playingCard.typeToStringBody,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  Container(
                    height: 20.0,
                    child: widget.playingCard.suitImage,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.playingCard.typeToString,
                      style: TextStyle(
                        fontSize: 10.0,
                      ),
                    ),
                    Container(height: 10.0, child: widget.playingCard.suitImage)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
