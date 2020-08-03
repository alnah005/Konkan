import 'package:flutter/material.dart';

enum CardSuit { spades, hearts, diamonds, clubs, joker }

enum CardType {
  one,
  two,
  three,
  four,
  five,
  six,
  seven,
  eight,
  nine,
  ten,
  jack,
  queen,
  king,
  joker,
}

extension CardSuitExt on CardSuit {
  Image get image {
    switch (this) {
      case CardSuit.hearts:
        return Image.asset('assets/images/hearts.png');
      case CardSuit.diamonds:
        return Image.asset('assets/images/diamonds.png');
      case CardSuit.clubs:
        return Image.asset('assets/images/clubs.png');
      case CardSuit.spades:
        return Image.asset('assets/images/spades.png');
      case CardSuit.joker:
        return Image.asset('assets/images/joker.png');
      default:
        return null;
    }
  }

  CardColor get color {
    if (this == CardSuit.hearts || this == CardSuit.diamonds) {
      return CardColor.red;
    } else {
      return CardColor.black;
    }
  }
}

extension CardExt on CardType {
  Map get data {
    switch (this) {
      case CardType.one:
        return {"BodyString": "1", "HeadString": "1", "Penalty": 1};
      case CardType.two:
        return {"BodyString": "2", "HeadString": "2", "Penalty": 2};
      case CardType.three:
        return {"BodyString": "3", "HeadString": "3", "Penalty": 3};
      case CardType.four:
        return {"BodyString": "4", "HeadString": "4", "Penalty": 4};
      case CardType.five:
        return {"BodyString": "5", "HeadString": "5", "Penalty": 5};
      case CardType.six:
        return {"BodyString": "6", "HeadString": "6", "Penalty": 6};
      case CardType.seven:
        return {"BodyString": "7", "HeadString": "7", "Penalty": 7};
      case CardType.eight:
        return {"BodyString": "8", "HeadString": "8", "Penalty": 8};
      case CardType.nine:
        return {"BodyString": "9", "HeadString": "9", "Penalty": 9};
      case CardType.ten:
        return {"BodyString": "10", "HeadString": "10", "Penalty": 10};
      case CardType.jack:
        return {"BodyString": "J", "HeadString": "J", "Penalty": 10};
      case CardType.queen:
        return {"BodyString": "Q", "HeadString": "Q", "Penalty": 10};
      case CardType.king:
        return {"BodyString": "K", "HeadString": "K", "Penalty": 10};
      case CardType.joker:
        return {"BodyString": "", "HeadString": "JKR", "Penalty": 10};
    }
    return {};
  }
}

enum CardColor {
  red,
  black,
}

// Simple playing card model
class PlayingCard {
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
  }
}
