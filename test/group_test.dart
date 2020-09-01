import 'package:solitaire/models/playing_card.dart';
import 'package:solitaire/utils/groups.dart';
import 'package:solitaire/utils/meld.dart';
import 'package:solitaire/utils/playing_card_util.dart';

class Scenario {
  List<PlayingCard> cards = new List<PlayingCard>();
  List<MeldClass> melds;
  int choice;
  void add(PlayingCard card) {
    this.cards.add(card);
    this.melds = validate(cards);
  }

  void meld(PlayingCard card, [ind = 0]) {
    melds[ind].dropCard(card);
  }

  void test2() {
    this.melds = validate(this.cards);
  }

  void test() {
    test2();
    this.printResults();
  }

  void printResults() {
    var cardz = this.cards.map((e) => e.string);
    print("\nGroup = ${cardz} has ${melds.length} possible melds:");
    int i = 1;
    melds.forEach((element) {
      print("\t" + i.toString() + ")  " + element.shortInfo);
      i++;
    });
  }
}

void main() {
  Scenario m1 = new Scenario();
  m1.add(PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.joker));
  m1.add(PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.queen));
  m1.add(PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.joker));
  m1.test();

  var m2 = new Scenario();
  m2.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
  m2.add(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.five));
  m2.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
  m2.test();

  var m3 = new Scenario();
  m3.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
  m3.add(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.one));
  m3.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
  m3.test();

  var m4 = new Scenario();
  m4.add(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.one));
  m4.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
  m4.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
  m4.test();

  var m5 = new Scenario();
  m5.add(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.five));
  m5.add(PlayingCard(cardSuit: CardSuit.spades, cardType: CardType.five));
  m5.add(PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.five));
  m5.test();

  var m6 = new Scenario();
  m6.add(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.five));
  m6.add(PlayingCard(cardSuit: CardSuit.spades, cardType: CardType.five));
  m6.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
  m6.test();

  var m7 = new Scenario();
  m7.add(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.five));
  m7.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
  m7.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
  m7.test();
  m7.meld(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.six), 4);

  var m8 = new Scenario();
  m8.add(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.five));
  m8.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
  m8.add(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.three));
  m8.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
  m8.test();

  var m9 = new Scenario();
  m9.add(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.king));
  m9.add(PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.queen));
  m9.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
  m9.test();
}
