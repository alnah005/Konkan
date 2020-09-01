import 'package:solitaire/models/playing_card.dart';
import 'package:solitaire/utils/meld.dart';

List<Meld> validate(List<PlayingCard> cards) {
  Map<int, PlayingCard> cardsMap = cards.asMap();
  Map<int, PlayingCard> jokersMap = new Map<int, PlayingCard>();
  Map<int, PlayingCard> nonJokersMap = new Map<int, PlayingCard>();

  bool hasJoker = false;
  bool hasAce = false;
  int aceIndex;

  final List<Meld> result = new List<Meld>();

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
    return result;
  }

  if (numberOfCards < 5) {
    if (numberOfUniqueTypes == 1 && numberOfUniqueSuits == numberOfNonJokers) {
      if (hasJoker) {
        var results = getJokerSuitGroups(cards, jokersMap.keys.toList(),
            nonJokersMap.values.first.cardType, uniqueSuits);
        result.addAll(results);
      } else {
        result.add(MeldSuit(cards, []));
      }
    }
  }
  if (numberOfUniqueSuits == 1 && numberOfUniqueTypes == numberOfNonJokers) {
    var r = checkSequence(nonJokersMap, jokersMap.keys.toList(), cards);

    if (r != null) {
      result.addAll(r);
    }

    if (hasAce) {
      PlayingCard ace2 = new PlayingCard(
          cardType: CardType.one, cardSuit: nonJokersMap[aceIndex].cardSuit);
      ace2.position = 14;
      ace2.penaltyVal = 11.0;
      Map<int, PlayingCard> njm = Map<int, PlayingCard>.from(nonJokersMap);
      njm[aceIndex] = ace2;
      var r2 = checkSequence(njm, jokersMap.keys.toList(), cards);
      if (r2 != null) {
        result.addAll(r2);
      }
    }
  }
  result.sort((e, r) => r.penalty.compareTo(e.penalty));
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

Meld getJokerSequenceGroup(List<PlayingCard> cards, int d,
    List<int> jokerPositions, MapEntry randomCard) {
  bool invalid = false;
  var result = List<JokerPlaceHolder>();
  jokerPositions.forEach((element) {
    int r = getJokerPosition(randomCard, element, d);
    if (r != null) {
      result.add(
          new JokerPlaceHolder(getType(r), randomCard.value.cardSuit, element));
    } else {
      invalid = true;
    }
  });
  if (!invalid) {
    return new MeldSeq(cards, result, d);
  }
  return null;
}

List<Meld> checkSequence(Map<int, PlayingCard> nonJokersMap,
    List<int> jokerPositions, List<PlayingCard> cards) {
  List<Meld> result = new List<Meld>();
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
  }

  return result;
}

List<Meld> getJokerSuitGroups(List<PlayingCard> cards, List<int> jokerPositions,
    CardType groupType, Set uniqueCardSuits) {
  List<Meld> result = new List<Meld>();
  // printMe('getJokerSuitGroups');

  var remainingSuits = CardSuit.values
      .where((element) => element != CardSuit.joker)
      .toList()
      .where((element) => !uniqueCardSuits.toList().contains(element));

  if (remainingSuits.length > jokerPositions.length) {
    switch (remainingSuits.length) {
      case 3:
        var joker1 = new JokerPlaceHolder(
            groupType, remainingSuits.toList()[0], jokerPositions[0]);
        var joker2 = new JokerPlaceHolder(
            groupType, remainingSuits.toList()[1], jokerPositions[1]);
        var joker3 = new JokerPlaceHolder(
            groupType, remainingSuits.toList()[2], jokerPositions[1]);
        var joker3rep = new JokerPlaceHolder(
            groupType, remainingSuits.toList()[2], jokerPositions[0]);
        List<JokerPlaceHolder> group1 = new List<JokerPlaceHolder>();
        group1.add(joker1);
        group1.add(joker2);
        result.add(new MeldSuit(cards, group1));
        List<JokerPlaceHolder> group2 = new List<JokerPlaceHolder>();
        group2.add(joker1);
        group2.add(joker3);
        result.add(new MeldSuit(cards, group2));

        List<JokerPlaceHolder> group3 = new List<JokerPlaceHolder>();
        group3.add(joker3rep);
        group3.add(joker2);
        result.add(new MeldSuit(cards, group3));

        return result;
      case 2:
        var joker1 = new JokerPlaceHolder(
            groupType, remainingSuits.toList()[0], jokerPositions[0]);
        var joker2 = new JokerPlaceHolder(
            groupType, remainingSuits.toList()[1], jokerPositions[0]);
        List<JokerPlaceHolder> group1 = new List<JokerPlaceHolder>();
        group1.add(joker1);
        result.add(new MeldSuit(cards, group1));
        List<JokerPlaceHolder> group2 = new List<JokerPlaceHolder>();
        group2.add(joker2);
        result.add(new MeldSuit(cards, group2));

        return result;
    }
  } else if (remainingSuits.length == jokerPositions.length) {
    switch (remainingSuits.length) {
      case 2:
        var joker1 = new JokerPlaceHolder(
            groupType, remainingSuits.toList()[0], jokerPositions[0]);
        var joker2 = new JokerPlaceHolder(
            groupType, remainingSuits.toList()[1], jokerPositions[0]);

        result.add(MeldSuit(cards, [joker1, joker2]));
        break;
      case 1:
        var joker = new JokerPlaceHolder(
            groupType, remainingSuits.toList()[0], jokerPositions[0]);

        result.add(MeldSuit(cards, [joker]));
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
