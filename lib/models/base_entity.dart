import 'package:konkan/models/playing_card.dart';
import 'package:konkan/utils/enums.dart';

/// This class encapsulates a collection of cards and
///  collection identifier
class BaseEntity {
  List<PlayingCard> cards = [];
  CardList identifier;
  BaseEntity(this.identifier);
}
