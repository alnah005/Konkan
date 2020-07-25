import 'package:flutter/material.dart';
import 'package:solitaire/models/playing_card.dart';

enum position_on_screen { bottom, right, left, top }

class PlayerInfo {
  String avatarPath;
  int age;
  int wins;
  int losses;
  double avgScore;
  PlayerInfo(
      {this.avatarPath = "",
      this.age = 18,
      this.wins = 0,
      this.losses = 0,
      this.avgScore = 0.0});
}

class Player {
  List<PlayingCard> cards = new List(14);
  PlayingCard extraCard;
  position_on_screen position;
  PlayerInfo personalInfo;
  Player({@required this.position, this.personalInfo});
}
