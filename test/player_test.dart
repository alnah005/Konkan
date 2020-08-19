import 'package:solitaire/models/player.dart';
import 'package:test/test.dart';

void main() {
  test('player won', () {
    final player = Player(PositionOnScreen.bottom);
    expect(player.personalInfo.wins, 0);
    expect(player.personalInfo.losses, 0);
    player.recordGame(PositionOnScreen.bottom);
    expect(player.personalInfo.wins, 1);
    expect(player.personalInfo.losses, 0);
    player.recordGame(PositionOnScreen.right);
    expect(player.personalInfo.wins, 1);
    expect(player.personalInfo.losses, 1);
  });
}
