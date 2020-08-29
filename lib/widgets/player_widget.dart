import 'package:flutter/material.dart';
import 'package:solitaire/models/groups.dart';
import 'package:solitaire/models/player.dart';
import 'package:solitaire/models/playing_card.dart';

import 'card_column.dart';

class PlayerWidget extends StatefulWidget {
  final Player player;
  final horizontal;
  final reverseOrder;
  PlayerWidget({
    Key key,
    @required this.player,
    this.horizontal = false,
    this.reverseOrder = false,
  }) : super(key: key);

  @override
  PlayerWidgetState createState() => PlayerWidgetState();
}

class PlayerWidgetState extends State<PlayerWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.horizontal
        ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: widget.reverseOrder
                ? _getChildren().reversed.cast<Flexible>().toList()
                : _getChildren(),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: widget.reverseOrder
                ? _getChildren().reversed.cast<Flexible>().toList()
                : _getChildren(),
          );
  }

  List<Flexible> _getChildren() {
    return [
      Flexible(
        flex: 7,
        fit: FlexFit.loose,
        child: _getPlayerColumn(),
      ),
      Flexible(
        flex: 10,
        fit: FlexFit.loose,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
                widget.player.openCards.expand((i) => i).toList().length > 0
                    ? _getPlayerSetColumn()
                    : [
                        Container(
                          height: 0,
                          width: 0,
                        )
                      ],
          ),
        ),
      )
    ];
  }

  CardColumn _getPlayerColumn() {
    return CardColumn(
      cards: widget.player.cards,
      onWillAcceptAdded: (card, player, destinationCard) {
        if (player.identifier == widget.player.identifier) {
          return true;
        } else {
          return false;
        }
      },
      onCardsAdded: (sourceCard, player, destinationCard) {
        if (sourceCard != destinationCard) {
          setState(() {
            List<PlayingCard> currentCards = player.cards;
            int cardIndex = currentCards.indexOf(sourceCard);
            int newIndex = currentCards.indexOf(destinationCard);
            currentCards.insert(
                cardIndex >= newIndex ? newIndex : newIndex + 1, sourceCard);
            currentCards.removeAt(
                cardIndex >= (newIndex + 1) ? cardIndex + 1 : cardIndex);
          });
        }
      },
      entity: widget.player,
    );
  }

  List<Flexible> _getPlayerSetColumn() {
    return widget.player.openCards
        .map(
          (listCards) => Flexible(
            flex: listCards.length,
            fit: FlexFit.loose,
            child: CardColumn(
              cards: listCards,
              onWillAcceptAdded: (card, player, destinationCard) {
                return true;
              },
              onCardsAdded: (sourceCard, player, destinationCard) {
                var melds = validate(listCards);
                PlayingCard result = sourceCard;
                if (melds.length > 0) {
                  result = melds[0].dropCard(sourceCard);
                }
                if (result != sourceCard) {
                  var returnDeck = player.cards;
                  if (result != null) {
                    setState(() {
                      returnDeck.add(result);
                      returnDeck.remove(sourceCard);
                    });
                  } else {
                    setState(() {
                      returnDeck.remove(sourceCard);
                    });
                  }
                }
              },
              setCards: true,
              entity: widget.player,
            ),
          ),
        )
        .toList();
  }
}
