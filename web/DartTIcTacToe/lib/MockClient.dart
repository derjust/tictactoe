import 'Client.dart';

class MockClient implements Client {
  
  int createPlayer(String name) {
    return 1;
  }
  
  
  int createGame() {
    return 2;
  }
  
  joinGame(int  gameId) {
    return gameId;
  }
  
  List<int> listGames() {
    List<int> retValue = new List<int>();
    
    retValue.add(3);
    retValue.add(42);
    
    return retValue;
  }
  
  
}