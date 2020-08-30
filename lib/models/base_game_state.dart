import 'package:solitaire/models/base_round_state.dart';
import 'package:solitaire/models/player.dart';

abstract class BaseGameState<T> {
  int numberOfPlayers;
  List<Player> players;
  List<T> playerGameInfo;
  BaseRoundState<T> round;

  BaseGameState(
      {this.numberOfPlayers, this.players, this.playerGameInfo, this.round});

  /// This method is called to initialize GameState
  ///
  ///Mainly called to initialize GameState (method constructor)
  BaseGameState.initializeGame(
      [int numOfPlayers,
      List<Player> playerList,
      List<T> playerInfo,
      BaseRoundState roundState]);

  /// This method is called to initialize round (cards, scores...etc)
  ///
  /// Mainly called to initialize Round (method constructor)
  ///
  /// Parameters:
  /// [playerList]: contains the list of players in the game
  ///
  /// Returns:
  ///    player in current turn
  Player initializeRound(List<Player> playerList);

  /// Check if current player has won and update next round state
  /// for all players and update round
  ///
  /// Returns:
  ///     True if current player has won
  ///     False if not
  bool checkRoundWin();

  /// Check if a player has lost a game and record all players stats
  ///
  /// Returns:
  ///     True if a player has lost
  ///     False if not
  bool checkGameWin();

  /// If current player hasn't won, go to next player to continue game
  ///
  /// Returns:
  ///     Player next in line to current player
  Player nextPlayer();

  /// call this method after a round has finished to update the round variable
  void trackRoundStats();

  /// call this method after the game has finished to record player stats
  void trackGameStats();

  /// call this to kick a player out of the game
  void removePlayer(Player player);

  /// call this to add a player into the game
  void addPlayer(Player player, T playerInfo);

  /// This method is called to set up next round (cards, scores...etc)
  void nextRound();
}
