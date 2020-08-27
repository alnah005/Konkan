import 'package:solitaire/models/base_game_state.dart';
import 'package:solitaire/models/base_round_state.dart';
import 'package:solitaire/models/player.dart';

class KonkanGameState<Y> extends BaseGameState<Y> {
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
