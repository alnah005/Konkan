import 'package:solitaire/models/playing_card.dart';

List<Map<int, List<PlayingCard>>> validate(List<PlayingCard> cards) {
  Map<int, PlayingCard> cardsMap = cards.asMap();
  Map<int, PlayingCard> jokersMap = new Map<int, PlayingCard>();
  Map<int, PlayingCard> nonJokersMap = new Map<int, PlayingCard>();

  bool hasJoker = false;
  bool hasAce = false;
  int aceIndex;

  final List<Map<int, List<PlayingCard>>> result =
      new List<Map<int, List<PlayingCard>>>();

  cardsMap.forEach((key, value) {
    if (value.cardType != CardType.joker) {
      nonJokersMap[key] = value;
      if (value.cardType == CardType.one) {
        hasAce = true;
        aceIndex = key;
      }
    } else {
      jokersMap[key] = value;
      hasJoker = true;
    }
  });

  Set uniqueSuits = nonJokersMap.values.map((e) => e.cardSuit).toSet();
  Set uniqueTypes = nonJokersMap.values.map((e) => e.cardType).toSet();

  int numberOfUniqueSuits = uniqueSuits.length;
  int numberOfUniqueTypes = uniqueTypes.length;

  int numberOfNonJokers = nonJokersMap.length;
  int numberOfJokers = jokersMap.length;
  int numberOfCards = cardsMap.length;

  if (numberOfCards > 13 || numberOfCards < 3) {
    return null;
  }

  if (numberOfCards < 5) {
    if (numberOfUniqueTypes == 1 && numberOfUniqueSuits == numberOfNonJokers) {
      if (hasJoker) {
        var res = getJokerSuitGroups(cards, jokersMap.keys.toList(),
            nonJokersMap.values.first.cardType, uniqueSuits);
        res.forEach((element) {
          result.add(buildMap(element));
        });
      } else {
        result.add(buildMap(cards));
      }
    }
  }
  if (numberOfUniqueSuits == 1 && numberOfUniqueTypes == numberOfNonJokers) {
    var r = checkSequence(nonJokersMap, jokersMap.keys.toList(), cards);

    if (r != null) {
      r.forEach((element) {
        result.add(buildMap(element));
      });
    }
    nonJokersMap.entries.first;

    if (hasAce) {
      PlayingCard ace2 = new PlayingCard(
          cardType: CardType.one, cardSuit: nonJokersMap[aceIndex].cardSuit);
      ace2.position = 14;
      ace2.penaltyVal = 11.0;
      Map<int, PlayingCard> njm = Map<int, PlayingCard>.from(nonJokersMap);
      njm[aceIndex] = ace2;
      var r2 = checkSequence(njm, jokersMap.keys.toList(), cards);
      if (r2 != null) {
        r2.forEach((element) {
          result.add(buildMap(element));
        });
      }
    }
  }
  return result;
}

Map<int, List<PlayingCard>> buildMap(List<PlayingCard> cardsList) {
  var map = Map<int, List<PlayingCard>>();
  double i = cardsList.fold(
      0, (previousValue, element) => previousValue + element.penaltyVal);
  map[i.round()] = cardsList;
  return map;
}

List<PlayingCard> copy(List<PlayingCard> cards) {
  List<PlayingCard> result = new List<PlayingCard>();
  cards.forEach((element) {
    result.add(new PlayingCard(
        cardSuit: element.cardSuit, cardType: element.cardType));
  });
  return result;
}

int checkDistances(Map<int, PlayingCard> nonJokersMap) {
  int index = nonJokersMap.keys.first;
  Set steps = new Set();
  PlayingCard value = nonJokersMap.values.first;
  Map<int, PlayingCard> njm = new Map<int, PlayingCard>.from(nonJokersMap);
  njm.remove(index);
  njm.forEach((index2, value2) {
    steps.add((index2 - index) / (value2.position - value.position).round());
  });
  if (steps.length != 1) {
    return 0;
  } else if (steps.first == 1.0) {
    return 1;
  } else if (steps.first == -1.0) {
    return -1;
  }
  return 0;
}

int getJokerPosition(MapEntry randomCard, int jokerIndex, int d) {
  int result = randomCard.value.position - (randomCard.key - jokerIndex) * d;
  if (result < 15 && result > 0) {
    return result;
  }
  return null;
}

List<PlayingCard> getJokerSequenceGroup(List<PlayingCard> cards, int d,
    List<int> jokerPositions, MapEntry randomCard) {
  bool invalid = false;
  var result = copy(cards);
  jokerPositions.forEach((element) {
    int r = getJokerPosition(randomCard, element, d);
    if (r != null) {
      PlayingCard c = new PlayingCard(
          cardType: getType(r), cardSuit: randomCard.value.cardSuit);
      result[element] = c;
    } else {
      invalid = true;
    }
  });
  if (!invalid) {
    return result;
  }
  return null;
}

List<List<PlayingCard>> checkSequence(Map<int, PlayingCard> nonJokersMap,
    List<int> jokerPositions, List<PlayingCard> cards) {
  List<List<PlayingCard>> result = new List<List<PlayingCard>>();
  int d;
  MapEntry safeCard = nonJokersMap.entries.first;
  if (nonJokersMap.length > 1) {
    d = checkDistances(nonJokersMap);
    if (d == 0) {
      return null;
    } else {
      var r = getJokerSequenceGroup(cards, d, jokerPositions, safeCard);
      if (r != null) {
        result.add(r);
      }
    }
  } else {
    var r2 = getJokerSequenceGroup(cards, 1, jokerPositions, safeCard);
    if (r2 != null) {
      result.add(r2);
    }
    if (jokerPositions.contains(1)) {
      var r2 = getJokerSequenceGroup(cards, -1, jokerPositions, safeCard);
      if (r2 != null) {
        result.add(r2);
      }
    }

    // return result;
  }

  return result;
}

List<List<PlayingCard>> getJokerSuitGroups(List<PlayingCard> cards,
    List<int> jokerPositions, CardType groupType, Set uniqueCardSuits) {
  List<List<PlayingCard>> result = new List<List<PlayingCard>>();
  // print('getJokerSuitGroups');

  var remainingSuits = CardSuit.values
      .where((element) => element != CardSuit.joker)
      .toList()
      .where((element) => !uniqueCardSuits.toList().contains(element));

  if (remainingSuits.length > jokerPositions.length) {
    // print('remainingSuits.length > jokerPositions.length');
    // print(remainingSuits);
    // print(uniqueCardSuits);
    switch (remainingSuits.length) {
      case 3:
        // print('case3');
        var card1 = PlayingCard(
            cardSuit: remainingSuits.toList()[0], cardType: groupType);
        var card2 = PlayingCard(
            cardSuit: remainingSuits.toList()[1], cardType: groupType);
        var card3 = PlayingCard(
            cardSuit: remainingSuits.toList()[2], cardType: groupType);
        var group1 = copy(cards);
        group1[jokerPositions[0]] = card1;
        group1[jokerPositions[1]] = card2;
        result.add(group1);
        var group2 = copy(cards);
        group2[jokerPositions[0]] = card1;
        group2[jokerPositions[1]] = card3;
        result.add(group2);
        var group3 = copy(cards);
        group3[jokerPositions[0]] = card2;
        group3[jokerPositions[1]] = card3;
        result.add(group3);
        return result;
      case 2:
        // print('case2');
        var card1 = PlayingCard(
            cardSuit: remainingSuits.toList()[0], cardType: groupType);
        var card2 = PlayingCard(
            cardSuit: remainingSuits.toList()[1], cardType: groupType);
        var group1 = copy(cards);
        group1[jokerPositions[0]] = card1;
        result.add(group1);
        var group2 = copy(cards);
        group2[jokerPositions[0]] = card2;
        result.add(group2);
        return result;
    }
  } else if (remainingSuits.length == jokerPositions.length) {
    switch (remainingSuits.length) {
      case 2:
        var card1 = PlayingCard(
            cardSuit: remainingSuits.toList()[0], cardType: groupType);
        var card2 = PlayingCard(
            cardSuit: remainingSuits.toList()[1], cardType: groupType);
        var group1 = copy(cards);
        group1[jokerPositions[0]] = card1;
        group1[jokerPositions[1]] = card2;
        result.add(group1);
        break;
      case 1:
        var card = PlayingCard(
            cardSuit: remainingSuits.toList()[0], cardType: groupType);
        var group1 = copy(cards);
        group1[jokerPositions[0]] = card;
        result.add(group1);
        break;
    }
  }
  return result;
}

List<List<PlayingCard>> checkSuits(Map<int, PlayingCard> nonJokersMap,
    Set uniqueCardSuits, List<int> jokerPositions, List<PlayingCard> cards) {
  List<List<PlayingCard>> l = new List<List<PlayingCard>>();
  l.add(cards);
  return l;
}
