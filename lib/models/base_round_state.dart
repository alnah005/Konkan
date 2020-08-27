import 'package:solitaire/models/player.dart';

abstract class BaseRoundState<T> {
  Player _currentPlayer;
  T _playerGameInfo;

  // initialize variables in round and start round
  void initializeRound();

  /// call this method after a round has finished to start a new round
  ///
  /// Parameters:
  ///    [previousRound]: previous round state
  ///
  /// Returns:
  ///    RoundState which is the Updated round state for next round
  BaseRoundState nextRound(BaseRoundState previousRound);

  /// call this method after a turn has finished to switch player and his info
  ///
  /// Parameters:
  ///      [nextPlayer]: player next in line to replace current player
  ///      [playerInfo]: information about the player in the game
  void nextTurnVariables(Player nextPlayer, T playerInfo) {
    this.trackTurnStats();
    _currentPlayer = nextPlayer;
    _playerGameInfo = playerInfo;
  }

  /// call this method after a turn has finished to track player info
  void trackTurnStats();
}
