import 'package:solitaire/models/playing_card.dart';
import 'package:solitaire/utils/enums.dart';

class BaseEntity {
  List<PlayingCard> cards = [];
  CardList identifier;
  BaseEntity(this.identifier);
}
