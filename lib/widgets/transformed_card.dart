import 'dart:math';

import 'package:flutter/material.dart';
import 'package:solitaire/models/player.dart';
import 'package:solitaire/models/playing_card.dart';

// TransformedCard makes the card draggable and translates it according to
// position in the stack.
class TransformedCard extends StatefulWidget {
  final PlayingCard playingCard;
  final Player player;

  TransformedCard({
    @required this.playingCard,
    this.player,
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
            height: 30.0,
            width: 20.0,
            decoration: BoxDecoration(
              color: Colors.blue,
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8.0),
            ),
          )
        : widget.playingCard.isDraggable
            ? Draggable<Map>(
                child: _buildFaceUpCard(),
                feedback: _buildFaceUpCard(),
                childWhenDragging: Container(
                  width: 40.0,
                  height: 60.0,
                ),
                data: {
                  "sourceCard": widget.playingCard,
                  "player": widget.player,
                },
              )
            : _buildFaceUpCard();
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
                      child: Container(
                    height: 17.0,
                    child: widget.playingCard.suitImage,
                  )),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.playingCard.typeToString,
                      style: TextStyle(
                        fontSize: 10.0,
                      ),
                    ),
                    Container(
                        height: 10.0, child: widget.playingCard.suitImage),
                    Expanded(
                        child: Container(
                      width: 3,
                    )),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        child: Container(
                      width: 3,
                    )),
                    Transform.rotate(
                      angle: pi,
                      child: Container(
                          height: 10.0, child: widget.playingCard.suitImage),
                    ),
                    Transform.rotate(
                      angle: pi,
                      child: Text(
                        widget.playingCard.typeToString,
                        style: TextStyle(
                          fontSize: 10.0,
                        ),
                      ),
                    ),
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
