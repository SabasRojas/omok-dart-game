# Omok Game (Gomoku) in Dart  

A **command-line implementation of Omok (Gomoku)**, a classic board game where players aim to align five stones in a row on a 15x15 grid. Built in **Dart**, this project includes a machine opponent with both random and smart strategies.  

---

## 🎮 Features  
- **15x15 board** with ASCII visualization.  
- **Two AI strategies**:  
  - **Random** – places stones randomly.  
  - **Smart** – blocks opponent’s winning moves and prioritizes its own.  
- **Interactive CLI gameplay**: enter coordinates like `8 10` to place a stone.  
- **Automatic win detection** (horizontal, vertical, and diagonal).  
- **Game-over conditions** when a player wins or the board is full.  

---

## 🛠️ Project Structure  
- **`main.dart`** – Entry point, handles setup and strategy selection.  
- **`OmokController.dart`** – Core game logic, win checks, and AI moves.  
- **`OmokBoard.dart`** – Represents the 15x15 board and last move.  
- **`OmokView.dart`** – Handles display of the board and messages.  
- **`Position.dart`** – Helper class to represent coordinates.  

---

## 🚀 Getting Started  

### Prerequisites  
- Install [Dart SDK](https://dart.dev/get-dart).  

### Run the Game  
Clone this repository and run:  

```bash
dart run main.dart
