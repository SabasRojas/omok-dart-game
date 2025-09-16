/// The View Class responsible for displaying the game board and messages.
///
/// By Sabas Rojas and Jose Legarreta

import 'OmokBoard.dart';

class OmokView {
  /// This displays the game board based on the provided game
  void displayBoard(OmokBoard game) {
    print('   1 2 3 4 5 6 7 8 9 0 1 2 3 4 5');
    print('  y - - - - - - - - - - - - - - ');
    for (int i = 0; i < game.board.length; i++) {
      String row = (i + 1).toString().padLeft(2) + '|';
      for (int j = 0; j < game.board[i].length; j++) {
        row += ' ${game.board[i][j]}';
      }
      print(row);
    }
    print('Last stone placed: ${game.lastStone}');
  }

  /// This displays a message
  void displayMessage(String message) {
    print(message);
  }
}