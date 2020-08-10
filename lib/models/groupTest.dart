import 'package:solitaire/models/groups.dart';
import 'package:solitaire/models/playing_card.dart';

class LogicTest {
  List<List<PlayingCard>> scenarios = new List<List<PlayingCard>>();
  void printTests() {
    for (var scenario in this.scenarios) {
      print("\nScenario         " +
          scenario.map((e) => e.string).toList().toString());
      for (var scenario2 in GroupBase(scenario).subGroups) {
        print("Possible group   " +
            scenario2.map((e) => e.string).toList().toString());
      }
      print("-----");
    }
  }

  LogicTest() {
    List<PlayingCard> m = new List<PlayingCard>();
    m.add(PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.two));
    m.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
    m.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
    this.scenarios.add(m);
    List<PlayingCard> m2 = new List<PlayingCard>();
    m2.add(PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.king));
    m2.add(PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.king));
    m2.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
    this.scenarios.add(m2);
    List<PlayingCard> m3 = new List<PlayingCard>();
    m3.add(PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.five));
    m3.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
    m3.add(PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.five));
    m3.add(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.five));
    this.scenarios.add(m3);
    List<PlayingCard> m4 = new List<PlayingCard>();
    m4.add(PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.five));
    m4.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
    m4.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
    m4.add(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.five));
    this.scenarios.add(m4);
    List<PlayingCard> m5 = new List<PlayingCard>();
    m5.add(PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.five));
    m5.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
    m5.add(PlayingCard(cardSuit: CardSuit.spades, cardType: CardType.five));
    m5.add(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.five));
    this.scenarios.add(m5);
    List<PlayingCard> m6 = new List<PlayingCard>();
    m6.add(PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.five));
    m6.add(PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.six));
    m6.add(PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.seven));
    m6.add(PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.eight));
    this.scenarios.add(m6);
    List<PlayingCard> m7 = new List<PlayingCard>();
    m7.add(PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.eight));
    m7.add(PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.seven));
    m7.add(PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.six));
    m7.add(PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.five));
    this.scenarios.add(m7);
    List<PlayingCard> m8 = new List<PlayingCard>();
    m8.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
    m8.add(PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.seven));
    m8.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
    m8.add(PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.five));
    this.scenarios.add(m8);
    List<PlayingCard> m9 = new List<PlayingCard>();
    m9.add(PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.five));
    m9.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
    m9.add(PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.seven));
    m9.add(PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.eight));
    m9.add(PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.joker));
    this.scenarios.add(m9);
    List<PlayingCard> m10 = new List<PlayingCard>();
    m10.add(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.one));
    m10.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
    m10.add(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.three));
    m10.add(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.four));
    m10.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
    this.scenarios.add(m10);
    List<PlayingCard> m13 = new List<PlayingCard>();
    m13.add(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.one));
    m13.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
    m13.add(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.three));
    m13.add(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.four));
    m13.add(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.five));
    this.scenarios.add(m13);
    List<PlayingCard> m12 = new List<PlayingCard>();
    m12.add(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.one));
    m12.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.king));
    m12.add(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.queen));
    m12.add(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.jack));
    m12.add(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.ten));
    this.scenarios.add(m12);
    List<PlayingCard> m11 = new List<PlayingCard>();
    m11.add(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.one));
    m11.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
    m11.add(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.queen));
    m11.add(PlayingCard(cardSuit: CardSuit.clubs, cardType: CardType.jack));
    m11.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
    this.scenarios.add(m11);
    List<PlayingCard> m14 = new List<PlayingCard>();
    m14.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
    m14.add(PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.seven));
    m14.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
    this.scenarios.add(m14);
    List<PlayingCard> m15 = new List<PlayingCard>();
    m15.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
    m15.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
    m15.add(PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.king));
    this.scenarios.add(m15);
    List<PlayingCard> m16 = new List<PlayingCard>();
    m16.add(PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.seven));
    m16.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
    m16.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
    this.scenarios.add(m16);
    List<PlayingCard> m17 = new List<PlayingCard>();
    m17.add(PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.one));
    m17.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
    m17.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
    this.scenarios.add(m17);
    this.printTests();
  }
}

class TestSuitGroups {
  List<List<PlayingCard>> scenarios = new List<List<PlayingCard>>();

  void test() {
    for (List<PlayingCard> s in this.scenarios) {
      var r = GroupBase(s);
      for (var m in r.subGroups) {
        for (var n in m) {
          print(n.cardType.toString() + "  " + n.cardSuit.toString());
        }
        print('\n');
      }
      print(r.subGroups);
    }
  }

  TestSuitGroups() {
    List<PlayingCard> m = new List<PlayingCard>();
    m.add(PlayingCard(cardSuit: CardSuit.hearts, cardType: CardType.two));
//    m.add(PlayingCard(cardSuit: CardSuit.diamonds, cardType: CardType.two));
//    m.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
    m.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
    m.add(PlayingCard(cardSuit: CardSuit.joker, cardType: CardType.joker));
    this.scenarios.add(m);

    this.test();
  }
}
