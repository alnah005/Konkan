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

CardType getType(int position) {
  switch (position) {
    case 1:
      return CardType.one;
    case 2:
      return CardType.two;
    case 3:
      return CardType.three;
    case 4:
      return CardType.four;
    case 5:
      return CardType.five;
    case 6:
      return CardType.six;
    case 7:
      return CardType.seven;
    case 8:
      return CardType.eight;
    case 9:
      return CardType.nine;
    case 10:
      return CardType.ten;
    case 11:
      return CardType.jack;
    case 12:
      return CardType.queen;
    case 13:
      return CardType.king;
    case 14:
      return CardType.one;
  }
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

        /// ace is both in position 1 and 14
        return {
          "BodyString": "1",
          "HeadString": "1",
          "Position": 1,
          "Penalty": 1
        };
      case CardType.two:
        return {
          "BodyString": "2",
          "HeadString": "2",
          "Position": 2,
          "Penalty": 2
        };
      case CardType.three:
        return {
          "BodyString": "3",
          "HeadString": "3",
          "Position": 3,
          "Penalty": 3
        };
      case CardType.four:
        return {
          "BodyString": "4",
          "HeadString": "4",
          "Position": 4,
          "Penalty": 4
        };
      case CardType.five:
        return {
          "BodyString": "5",
          "HeadString": "5",
          "Position": 5,
          "Penalty": 5
        };
      case CardType.six:
        return {
          "BodyString": "6",
          "HeadString": "6",
          "Position": 6,
          "Penalty": 6
        };
      case CardType.seven:
        return {
          "BodyString": "7",
          "HeadString": "7",
          "Position": 7,
          "Penalty": 7
        };
      case CardType.eight:
        return {
          "BodyString": "8",
          "HeadString": "8",
          "Position": 8,
          "Penalty": 8
        };
      case CardType.nine:
        return {
          "BodyString": "9",
          "HeadString": "9",
          "Position": 9,
          "Penalty": 9
        };
      case CardType.ten:
        return {
          "BodyString": "10",
          "HeadString": "10",
          "Position": 10,
          "Penalty": 10
        };
      case CardType.jack:
        return {
          "BodyString": "J",
          "HeadString": "J",
          "Position": 11,
          "Penalty": 10
        };
      case CardType.queen:
        return {
          "BodyString": "Q",
          "HeadString": "Q",
          "Position": 12,
          "Penalty": 10
        };
      case CardType.king:
        return {
          "BodyString": "K",
          "HeadString": "K",
          "Position": 13,
          "Penalty": 10
        };
      case CardType.joker:
        return {
          "BodyString": "",
          "HeadString": "JKR",
          "Position": 15,
          "Penalty": 10
        };
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
}
