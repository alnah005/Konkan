import 'package:solitaire/models/groups.dart';
import 'package:solitaire/models/playing_card.dart';

class Scenario {
  List<PlayingCard> cards = new List<PlayingCard>();
  void add(PlayingCard card) {
    this.cards.add(card);
  }

  void expecting(String e) {
    List<Map<int, List<PlayingCard>>> ll = validate(this.cards);
    var r = ll
        .map((e) =>
            e.map((key, value) => MapEntry(key, value.map((e) => e.string))))
        .toString();

    if (r != e) {
      print('Error matching\n');
      print(e);
//      throw ("");
    } else {
      print('Sucessful matching\n');
    }
  }

  void test() {
    this.printResults();
  }

  void printResults() {
    List<Map<int, List<PlayingCard>>> ll = validate(this.cards);
    print(
        "Testing for  --- ${this.cards.fold('', (previousValue, element) => previousValue + element.string + ' ')} ---");
    print(ll.map((e) =>
        e.map((key, value) => MapEntry(key, value.map((e) => e.string)))));
  }
}

void main() {
  Scenario m1 = new Scenario();
  m1.add(PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.joker));
  m1.add(PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.queen));
  m1.add(PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.joker));
  m1.test();
  m1.expecting(
      "({30: (Q♤, Q♥, Q♢)}, {30: (Q♤, Q♥, Q♧)}, {30: (Q♢, Q♥, Q♧)}, {30: (J♥, Q♥, K♥)})");

  var m2 = new Scenario();
  m2.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
  m2.add(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.five));
  m2.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
  m2.test();
  m2.expecting(
      "({15: (5♤, 5♧, 5♥)}, {15: (5♤, 5♧, 5♢)}, {15: (5♥, 5♧, 5♢)}, {15: (4♧, 5♧, 6♧)})");

  var m3 = new Scenario();
  m3.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
  m3.add(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.one));
  m3.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
  m3.test();
  m3.expecting("({33: (1♤, 1♧, 1♥)}, {33: (1♤, 1♧, 1♢)}, {33: (1♥, 1♧, 1♢)})");

  var m4 = new Scenario();
  m4.add(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.one));
  m4.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
  m4.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
  m4.test();
  m4.expecting(
      "({33: (1♧, 1♤, 1♥)}, {33: (1♧, 1♤, 1♢)}, {33: (1♧, 1♥, 1♢)}, {16: (1♧, 2♧, 3♧)}, {31: (1♧, K♧, Q♧)})");

  var m5 = new Scenario();
  m5.add(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.five));
  m5.add(PlayingCard(cardSuit: CardSuit.spades, cardType: CardType.five));
  m5.add(PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.five));
  m5.test();
  m5.expecting("({15: (5♧, 5♤, 5♢)})");

  var m6 = new Scenario();
  m6.add(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.five));
  m6.add(PlayingCard(cardSuit: CardSuit.spades, cardType: CardType.five));
  m6.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
  m6.test();
  m6.expecting("({15: (5♧, 5♤, 5♥)}, {15: (5♧, 5♤, 5♢)})");

  var m7 = new Scenario();
  m7.add(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.five));
  m7.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
  m7.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
  m7.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
  m7.test();
  m7.expecting("({26: (5♧, 6♧, 7♧, 8♧)}, {14: (5♧, 4♧, 3♧, 2♧)})");

  var m8 = new Scenario();
  m8.add(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.five));
  m8.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
  m8.add(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.three));
  m8.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
  m8.test();
  m8.expecting("({14: (5♧, 4♧, 3♧, 2♧)})");

  var m9 = new Scenario();
  m9.add(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.king));
  m9.add(PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.queen));
  m9.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
  m9.test();
  m9.expecting("()");
}
