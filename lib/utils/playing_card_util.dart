import 'package:flutter/material.dart';

enum CardSuit { spades, hearts, diamonds, clubs, joker }

enum CardType {
  joker,
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
    default:
      return null;
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

  String get string {
    switch (this) {
      case CardSuit.hearts:
        return "♥";
      case CardSuit.diamonds:
        return "♢";
      case CardSuit.clubs:
        return "♧";
      case CardSuit.spades:
        return "♤";
      case CardSuit.joker:
        return "";
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
          "String": "Ace",
          "BodyString": "",
          "HeadString": "A",
          "Position": 1,
          "Penalty": 11
        };
      case CardType.two:
        return {
          "String": "Two",
          "BodyString": "2",
          "HeadString": "2",
          "Position": 2,
          "Penalty": 2
        };
      case CardType.three:
        return {
          "String": "Three",
          "BodyString": "3",
          "HeadString": "3",
          "Position": 3,
          "Penalty": 3
        };
      case CardType.four:
        return {
          "String": "Four",
          "BodyString": "4",
          "HeadString": "4",
          "Position": 4,
          "Penalty": 4
        };
      case CardType.five:
        return {
          "String": "Five",
          "BodyString": "5",
          "HeadString": "5",
          "Position": 5,
          "Penalty": 5
        };
      case CardType.six:
        return {
          "String": "Six",
          "BodyString": "6",
          "HeadString": "6",
          "Position": 6,
          "Penalty": 6
        };
      case CardType.seven:
        return {
          "String": "Seven",
          "BodyString": "7",
          "HeadString": "7",
          "Position": 7,
          "Penalty": 7
        };
      case CardType.eight:
        return {
          "String": "Eight",
          "BodyString": "8",
          "HeadString": "8",
          "Position": 8,
          "Penalty": 8
        };
      case CardType.nine:
        return {
          "String": "Nine",
          "BodyString": "9",
          "HeadString": "9",
          "Position": 9,
          "Penalty": 9
        };
      case CardType.ten:
        return {
          "String": "Ten",
          "BodyString": "10",
          "HeadString": "10",
          "Position": 10,
          "Penalty": 10
        };
      case CardType.jack:
        return {
          "String": "Jack",
          "BodyString": "J",
          "HeadString": "J",
          "Position": 11,
          "Penalty": 10
        };
      case CardType.queen:
        return {
          "String": "Queen",
          "BodyString": "Q",
          "HeadString": "Q",
          "Position": 12,
          "Penalty": 10
        };
      case CardType.king:
        return {
          "String": "King",
          "BodyString": "K",
          "HeadString": "K",
          "Position": 13,
          "Penalty": 10
        };
      case CardType.joker:
        return {
          "String": "Joker",
          "BodyString": "",
          "HeadString": "JKR",
          "Position": 15,
          "Penalty": 50
        };
    }
    return {};
  }
}

enum CardColor {
  red,
  black,
}
