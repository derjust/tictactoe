import 'Enum.dart';


abstract class Model {
  
  void setGames(List<int> gameId);
  List<int> getGames();
  
 
  void setGameId(int gameId);
  int getGameId();
  
  void setPlayerId(int playerId);
  int getPlayerId();
  
  Enum getCell(int row, int column);
  setCell(int row, int column, Enum value);
  resetCells();
  
}