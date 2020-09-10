import 'package:flutter/material.dart';
import 'package:solitaire/models/base_entity.dart';
import 'package:solitaire/models/player.dart';
import 'package:solitaire/models/playing_card.dart';

import 'card_column.dart';

/// new type def in order to save card being dragged, discarded deck,
/// card that was dragged to, and set card group
typedef Null CardAcceptCallbackSetCards(
    PlayingCard sourceCard,
    BaseEntity fromPlayer,
    PlayingCard destinationCard,
    List<PlayingCard> group);

class PlayerWidget extends StatefulWidget {
  final Player player;
  final horizontal;
  final reverseOrder;

  /// regular column
  final CardAcceptCallback onCardAdded;

  /// set column
  final CardAcceptCallbackSetCards onCardAddedSet;

  /// regular column
  final CardWillAcceptCallback onWillAcceptAdded;

  /// set column
  final CardWillAcceptCallback onWillAcceptAddedSet;
  PlayerWidget({
    Key key,
    @required this.player,
    @required this.onCardAdded,
    @required this.onWillAcceptAdded,
    @required this.onWillAcceptAddedSet,
    @required this.onCardAddedSet,
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
            children: _getChildren(),
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _getChildren(),
          );
  }

  List<Flexible> _getChildren() {
    var cards = Flexible(
      flex: 7,
      fit: FlexFit.loose,
      child: _getPlayerColumn(),
    );
    var setCards = Flexible(
      flex: 10,
      fit: FlexFit.loose,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: widget.player.openCards.expand((i) => i).toList().length > 0
              ? (widget.horizontal
                  ? _getPlayerSetColumn()
                  : setCardsSplitter(_getPlayerSetColumn()))
              : [
                  Container(
                    height: 0,
                    width: 0,
                  )
                ],
        ),
      ),
    );
    return widget.reverseOrder
        ? [
            setCards,
            cards,
          ]
        : [
            cards,
            setCards,
          ];
  }

  CardColumn _getPlayerColumn() {
    return CardColumn(
      cards: widget.player.cards,
      onWillAcceptAdded: (card, player, destinationCard) {
        return widget.onWillAcceptAdded(card, player, destinationCard);
      },
      onCardsAdded: (sourceCard, player, destinationCard) {
        widget.onCardAdded(sourceCard, player, destinationCard);
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
                return widget.onWillAcceptAddedSet(
                    card, player, destinationCard);
              },
              onCardsAdded: (sourceCard, player, destinationCard) {
                setState(() {
                  /// call to update player through gamescreen to refresh state
                  widget.onCardAddedSet(
                      sourceCard, player, destinationCard, listCards);
                });
              },
              setCards: true,
              entity: widget.player,
            ),
          ),
        )
        .toList();
  }

  List<Column> setCardsSplitter(List<Widget> cols) {
    if (cols.length > 3) {
      return widget.reverseOrder
          ? [
              Column(
                children: cols.sublist(3, cols.length),
              ),
              Column(
                children: cols.sublist(0, 3),
              ),
            ]
          : [
              Column(
                children: cols.sublist(0, 3),
              ),
              Column(
                children: cols.sublist(3, cols.length),
              ),
            ];
    }
    return [
      Column(
        children: cols,
      )
    ];
  }
}
