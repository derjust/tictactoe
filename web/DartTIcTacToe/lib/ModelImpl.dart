library ModelImpl;

import 'Model.dart';
import 'Enum.dart';

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
    board[row][column] = value;
  }
  
  void resetCells() {
    board[0] = [Enum.EMPTY, Enum.EMPTY, Enum.EMPTY];
    board[1] = [Enum.EMPTY, Enum.EMPTY, Enum.EMPTY];
    board[2] = [Enum.EMPTY, Enum.EMPTY, Enum.EMPTY];
  }
  
}