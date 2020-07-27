import 'package:flutter/material.dart';
import 'package:solitaire/models/playing_card.dart';
import 'package:solitaire/pages/game_screen.dart';
import 'package:solitaire/widgets/card_column.dart';
import 'package:solitaire/widgets/transformed_card.dart';

// The deck of cards which accept the final cards (Ace to King)
class EmptyCardDeck extends StatefulWidget {
  final CardSuit cardSuit;
  final List<PlayingCard> cardsAdded;
  final CardAcceptCallback onCardAdded;
  final CardList columnIndex;
  EmptyCardDeck({
    @required this.cardSuit,
    @required this.cardsAdded,
    @required this.onCardAdded,
    this.columnIndex,
  });

  @override
  _EmptyCardDeckState createState() => _EmptyCardDeckState();
}

class _EmptyCardDeckState extends State<EmptyCardDeck> {
  final List<CardList> playerCardLists = [
    CardList.P1,
    CardList.P2,
    CardList.P3,
    CardList.P4
  ];
  @override
  Widget build(BuildContext context) {
    return DragTarget<Map>(
      builder: (context, listOne, listTwo) {
        return widget.cardsAdded.length == 0
            ? Opacity(
                opacity: 0.7,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.white,
                    image: DecorationImage(
                      image: NetworkImage(
                        "https://spectramagazine.org/wp-content/uploads/2018/09/bb.jpg",
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                  height: 60.0,
                  width: 40.0,
                ),
              )
            : TransformedCard(
                playingCard: widget.cardsAdded.last,
                columnIndex: widget.columnIndex,
                attachedCards: [
                  widget.cardsAdded.last,
                ],
              );
      },
      onWillAccept: (value) {
        CardList cardIndex = value["fromIndex"];
        for (int players = 0; players < playerCardLists.length; players++) {
          if (cardIndex == playerCardLists[players]) {
            return true;
          }
        }
        return false;
      },
      onAccept: (value) {
        widget.onCardAdded(
          value["cards"],
          value["fromIndex"],
        );
      },
    );
  }

  Image _suitToImage() {
    switch (widget.cardSuit) {
      case CardSuit.hearts:
        return Image.asset('assets/images/hearts.png');
      case CardSuit.diamonds:
        return Image.asset('assets/images/diamonds.png');
      case CardSuit.clubs:
        return Image.asset('assets/images/clubs.png');
      case CardSuit.spades:
        return Image.asset('assets/images/spades.png');
      default:
        return null;
    }
  }
}
