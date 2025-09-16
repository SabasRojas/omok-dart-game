/// Entry point for the Omok game application.
///
/// By Sabas Rojas and Jose Legarreta

import 'dart:io';

import 'OmokView.dart';
import 'OmokController.dart';

void main() {
  final view = OmokView();
  final controller = OmokController(view);

  // Here we ask the user to select a strategy until a valid option is chosen
  int? strategy;
  while (strategy != 1 && strategy != 2) {
    view.displayMessage('Select the machine strategy [1 for Smart or 2 for Random]:');
    var input = stdin.readLineSync();

    // This checks if the user input is valid and not empty
    if (input != null && input.isNotEmpty) {
      strategy = int.tryParse(input);
      // This displays an error message for invalid strategy
      if (strategy != 1 && strategy != 2) {
        view.displayMessage('Invalid strategy. Please select 1 for Smart or 2 for Random.');
      }
    } else {
      // Here we display a message when no input is detected
      view.displayMessage('No input detected. Please enter 1 for Smart or 2 for Random.');
    }
  }

  // This starts the game with the selected strategy
  controller.playGame(strategy!);
}