/// Controller class responsible for handling user input and game logic.
///
/// By Sabas Rojas and Jose Legarreta

import 'dart:io';
import 'dart:math';

import 'OmokView.dart';
import 'OmokBoard.dart';
import 'Position.dart';

class OmokController {
  final OmokView view;
  OmokBoard game;

  OmokController(this.view) : game = OmokBoard(List.generate(15, (_) => List.filled(15, '.')), 'X');

  /// This starts the game with the selected strategy
  void playGame(int strategy) {
    view.displayMessage('Welcome to Omok Game!');

    // Set machine's stone
    String machineStone = 'O';
    String playerStone = 'X';

    // Set machine's strategy
    bool Function() machineMove;
    if (strategy == 1) {
      machineMove = () => makeSmartMove(machineStone);
    } else {
      machineMove = () => makeRandomMove(machineStone);
    }

    // Main game loop
    while (true) {
      view.displayBoard(game);

      // Player's move
      view.displayMessage('Enter x and y (1-15, e.g., 8 10):');
      var input = stdin.readLineSync();
      if (input == null || input.isEmpty) continue;

      var coordinates = input.split(' ');
      if (coordinates.length != 2) {
        view.displayMessage('Invalid input. Please enter two space-separated integers.');
        continue;
      }

      var x = int.tryParse(coordinates[0]);
      var y = int.tryParse(coordinates[1]);

      if (x == null || y == null || x < 1 || x > 15 || y < 1 || y > 15) {
        view.displayMessage('Invalid coordinates. Please enter values between 1 and 15.');
        continue;
      }

      // Place player's stone
      if (!placeStone(x - 1, y - 1, playerStone)) {
        view.displayMessage('Failed to place stone. Please try again.');
        continue;
      }

      // Check for player's win
      if (checkWin(x - 1, y - 1, playerStone)) {
        view.displayBoard(game);
        view.displayMessage('Congratulations! You win!');
        break;
      }

      // Machine's move
      if (isBoardFull()) {
        view.displayMessage('Game over! The board is full.');
        break;
      }

      if (strategy == 1) {
        if (makeSmartMove(machineStone)) {
          view.displayMessage('Machine placed its stone.');
        } else {
          view.displayMessage('Machine failed to place stone.');
        }
      } else {
        if (makeRandomMove(machineStone)) {
          view.displayMessage('Machine placed its stone.');
        } else {
          view.displayMessage('Machine failed to place stone.');
        }
      }

      // This checks if the machine wins
      if (checkWin(-1, -1, machineStone)) {
        view.displayBoard(game);
        view.displayMessage('Machine wins!');
        break;
      }
    }
  }

  /// This places a stone at position x and y
  bool placeStone(int x, int y, String stone) {
    if (game.board[x][y] == '.') {
      game.board[x][y] = stone;
      return true;
    }
    return false;
  }

  /// This checks if there is a win based on the stone placed at position x and y
  bool checkWin(int x, int y, String stone) {
    if (x == -1 && y == -1) {
      // Check the entire board for machine's win
      for (int i = 0; i < 15; i++) {
        for (int j = 0; j < 15; j++) {
          if (checkWin(i, j, stone)) return true;
        }
      }
      return false;
    }

    int count;

    // Check horizontally
    count = countStones(x, y, -1, 0, stone) + countStones(x, y, 1, 0, stone) + 1;
    if (count >= 5) return true;

    // Check vertically
    count = countStones(x, y, 0, -1, stone) + countStones(x, y, 0, 1, stone) + 1;
    if (count >= 5) return true;

    // Check diagonally (from top left to bottom right)
    count = countStones(x, y, -1, -1, stone) + countStones(x, y, 1, 1, stone) + 1;
    if (count >= 5) return true;

    // Check diagonally (from top right to bottom left)
    count = countStones(x, y, 1, -1, stone) + countStones(x, y, -1, 1, stone) + 1;
    return count >= 5;
  }

  int countStones(int x, int y, int dx, int dy, String stone) {
    int count = 0;
    int cx = x + dx;
    int cy = y + dy;

    while (cx >= 0 && cy >= 0 && cx < 15 && cy < 15 && game.board[cx][cy] == stone) {
      count++;
      cx += dx;
      cy += dy;
    }

    return count;
  }

  /// This method is used to make a move if the user selected smart as the strategy
  bool makeSmartMove(String stone) {
    String opponentStone = getOpponentStone(stone);
    List<Position> activePositions = getActivePositions();

    // This checks for potential winning moves for both the machine and the opponent
    for (Position pos in activePositions) {
      if (game.board[pos.i][pos.j] == '.') {
        // Check if the machine wins if it places a stone at (pos.i, pos.j)
        game.board[pos.i][pos.j] = stone;
        if (checkWin(pos.i, pos.j, stone)) {
          // Making the winning move
          placeStone(pos.i, pos.j, stone);
          return true;
        }
        game.board[pos.i][pos.j] = '.'; // Undo the move

        // Check if the opponent wins if they place a stone at (pos.i, pos.j)
        game.board[pos.i][pos.j] = opponentStone;
        if (checkWin(pos.i, pos.j, opponentStone)) {
          // This blocks the opponent's potential winning move
          game.board[pos.i][pos.j] = '.';
          placeStone(pos.i, pos.j, stone);
          return true;
        }
        game.board[pos.i][pos.j] = '.'; // Undo the move
      }
    }

    // Here if there are no potential winning moves for both players we just make a random move
    return makeRandomMove(stone);
  }

  String getOpponentStone(String stone) {
    return stone == 'X' ? 'O' : 'X';
  }

  /// This method simply places a random stone on the board
  bool makeRandomMove(String stone) {
    var random = Random();
    int x, y;
    do {
      x = random.nextInt(15);
      y = random.nextInt(15);
    } while (game.board[x][y] != '.');

    return placeStone(x, y, stone);
  }

  /// This checks if the board is full and there are no empty spaces left
  bool isBoardFull() {
    for (var row in game.board) {
      if (row.contains('.')) return false;
    }
    return true;
  }

  /// This method finds and returns the coordinates of empty spaces on the board where the stones can be placed
  List<Position> getActivePositions() {
    List<Position> activePositions = [];
    for (int i = 0; i < game.board.length; i++) {
      for (int j = 0; j < game.board[i].length; j++) {
        if (game.board[i][j] == '.') {
          activePositions.add(Position(i, j));
        }
      }
    }
    return activePositions;
  }
}
