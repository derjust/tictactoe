library ModelImpl;

import 'Model.dart';
import 'Enum.dart';

import 'package:logging/logging.dart'; 
import 'package:logging_handlers/logging_handlers_shared.dart';


class ModelImpl implements Model {
  int gameId = -1;
  int playerId = -1;
  List<String> games = new List();
  
  ModelImpl() {
    resetCells();
  }
  
  void setGames(List<String> games) {
    this.games = games;
  }
  
  List<String> getGames() {
    return games;
  }  
  
  
  void setGameId(int gameId) {
    this.gameId = gameId;
  }
  
  int getGameId() {
    return this.gameId;
  }
  
  void setPlayerId(int playerId) {
    this.playerId = playerId;
  }
  
  int getPlayerId() {
    return this.playerId;
  }
  
  var board;
  
  Enum getCell(int row, int column) {
    return board[row][column];
  }
  setCell(int row, int column, Enum value) {
    info("Row: $row column $column value: $value");
    board[row][column] = value;
  }
  
  void resetCells() {
    board = new List(3);
    board[0] = [Enum.EMPTY, Enum.EMPTY, Enum.EMPTY];
    board[1] = [Enum.EMPTY, Enum.EMPTY, Enum.EMPTY];
    board[2] = [Enum.EMPTY, Enum.EMPTY, Enum.EMPTY];
  }
  
}