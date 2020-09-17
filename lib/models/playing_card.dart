import 'package:flutter/material.dart';
import 'package:konkan/utils/playing_card_util.dart';

// Simple playing card model
abstract class Card {
  CardSuit cardSuit;
  CardType cardType;
}

class PlayingCard extends Card {
  CardSuit cardSuit;
  CardType cardType;
  bool faceUp;
  bool opened;
  String typeToString;
  String typeToStringBody;
  Image suitImage;
  double penaltyVal;
  CardColor cardColor;
  bool isDraggable;

  /// the position on the sequence
  int position;

  PlayingCard({
    @required this.cardSuit,
    @required this.cardType,
    this.faceUp = false,
    this.opened = false,
    this.isDraggable = false,
  }) {
    var data = this.cardType.data;
    this.typeToString = data['HeadString'];
    this.typeToStringBody = data['BodyString'];
    this.penaltyVal = data['Penalty'].toDouble();
    this.suitImage = cardSuit.image;
    this.cardColor = cardSuit.color;
    this.position = data["Position"];
  }

  String get string {
    var result = "";
    result += this.typeToString;
//    result += " ";
    result += this.cardSuit.string;
//    result += ']';
    return result;
  }

  PlayingCard.clone(PlayingCard source)
      : this.cardType = source.cardType,
        this.cardSuit = source.cardSuit,
        this.faceUp = source.faceUp,
        this.isDraggable = source.isDraggable,
        this.opened = source.opened,
        this.typeToString = source.typeToString,
        this.typeToStringBody = source.typeToStringBody,
        this.penaltyVal = source.penaltyVal,
        this.suitImage = source.suitImage,
        this.cardColor = source.cardColor,
        this.position = source.position;
}
