import 'Model.dart';
import 'Enum.dart';


class ModelImpl implements Model {
  int gameId;
  int playerId;
  List<int> games;
  
  ModelImpl() {
    resetCells();
  }
  
  void setGames(List<int> gameId) {
    
  }
  
  List<int> getGames() {
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
    board[row][column] = value;
  }
  
  void resetCells() {
    board[0] = [Enum.EMPTY, Enum.EMPTY, Enum.EMPTY];
    board[1] = [Enum.EMPTY, Enum.EMPTY, Enum.EMPTY];
    board[2] = [Enum.EMPTY, Enum.EMPTY, Enum.EMPTY];
  }
  
}