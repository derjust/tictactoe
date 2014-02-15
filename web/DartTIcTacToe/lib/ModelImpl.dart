library ModelImpl;

import 'Model.dart';
import 'Enum.dart';

import 'package:logging/logging.dart'; 
import 'package:logging_handlers/logging_handlers_shared.dart';


class ModelImpl implements Model {
  String gameId;
  String playerId;
  List<String> games;
  
  ModelImpl() {
    resetCells();
  }
  
  void setGames(List<String> games) {
    this.games = games;
  }
  
  List<String> getGames() {
    return games;
  }  
  
  
  void setGameId(String gameId) {
    this.gameId = gameId;
  }
  
  String getGameId() {
    return this.gameId;
  }
  
  void setPlayerId(String playerId) {
    this.playerId = playerId;
  }
  
  String getPlayerId() {
    return this.playerId;
  }
  
  var board;
  
  Enum getCell(int row, int column) {
    return board[row][column];
  }
  setCell(int row, int column, Enum value) {
    debug("Row: " + row + " column " + colum + " value: " + value);
    board[row][column] = value;
  }
  
  void resetCells() {
    board = new List(3);
    board[0] = [Enum.EMPTY, Enum.EMPTY, Enum.EMPTY];
    board[1] = [Enum.EMPTY, Enum.EMPTY, Enum.EMPTY];
    board[2] = [Enum.EMPTY, Enum.EMPTY, Enum.EMPTY];
  }
  
}