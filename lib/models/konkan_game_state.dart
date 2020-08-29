import 'package:solitaire/models/base_game_state.dart';
import 'package:solitaire/models/base_round_state.dart';
import 'package:solitaire/models/player.dart';
import 'package:solitaire/models/playing_card.dart';

class KonkanGameState<Y> extends BaseGameState<Y> {
  List<PlayingCard> cardDeckClosed = [];
  double settingScore = 51;

  // Stores the card in the upper boxes
  List<PlayingCard> droppedCards = [];

  KonkanGameState(
      {int numOfPlayers,
      List<Player> playerList,
      List<Y> playerInfo,
      BaseRoundState roundState})
      : super(
            numberOfPlayers: numOfPlayers,
            players: playerList,
            playerGameInfo: playerInfo,
            round: roundState);

  @override
  void addPlayer(Player player, Y playerInfo) {
    // TODO: implement addPlayer
  }

  @override
  bool checkGameWin() {
    // TODO: implement checkGameWin
    throw UnimplementedError();
  }

  @override
  bool checkRoundWin() {
    // TODO: implement checkRoundWin
    throw UnimplementedError();
  }

  @override
  void initializeGame(
      [int numOfPlayers,
      List<Player> playerList,
      List<Y> playerInfo,
      BaseRoundState roundState]) {
    // TODO: implement initializeGame
    KonkanGameState(
        numOfPlayers: numOfPlayers,
        playerList: playerList,
        playerInfo: playerInfo,
        roundState: roundState);
    assert(super.numberOfPlayers <= 0 && playerList.isEmpty,
        "Gamestate must have at least 1 player");
    assert(super.numberOfPlayers > 4 || playerList.length > 4,
        "Gamestate must have at most 4 players");
    if (playerList.isEmpty) {
      for (int i = 0; i < super.numberOfPlayers - 1; i++) {
//        if (PositionOnScreen.values[i] != PositionOnScreen.bottom) {
//          super.players.add(new Player(PositionOnScreen.values[i], isAI: true));
//        }
//        super.players.add(new Player(
//              PositionOnScreen.bottom,
//            ));
      }
    }
  }

  @override
  Player initializeRound(List<Player> playerList) {
    // TODO: implement initializeRound
    throw UnimplementedError();
  }

  @override
  Player nextPlayer() {
    // TODO: implement nextPlayer
    throw UnimplementedError();
  }

  @override
  void removePlayer(Player player) {
    // TODO: implement removePlayer
  }

  @override
  void trackGameStats() {
    // TODO: implement trackGameStats
  }

  @override
  void trackRoundStats() {
    // TODO: implement trackRoundStats
  }
}
