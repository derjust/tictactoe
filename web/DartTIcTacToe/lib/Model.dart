import 'Enum.dart';

abstract class Model {
  
  void setGames(List<String> gameId);
  List<String> getGames();
  
 
  void setGameId(String gameId);
  String getGameId();
  
  void setPlayerId(String playerId);
  String getPlayerId();
  
  Enum getCell(int row, int column);
  setCell(int row, int column, Enum value);
  resetCells();
  
}