import 'dart:html';
import 'Model.dart';
import 'dart:convert';

class Client {
  String baseUrl = "http://localhost:58080/tictactoe-web/simple.groovy?";

  Model model;
  
  Client(Model model, String baseUrl) {
    if (baseUrl == null || baseUrl.isEmpty) {
      throw new Exception("No baseUrl!");
    }
    this.baseUrl = baseUrl;
    this.model = model;
  }
  
  void createPlayer(String name) {
      HttpRequest request = new HttpRequest(); // create a new XHR
      
      // add an event handler that is called when the request finishes
      request.onReadyStateChange.listen((_) {
        if (request.readyState == HttpRequest.DONE &&
            (request.status == 200 || request.status == 0)) {
            // data saved OK.
            print(request.responseText); // output the response from the server
          
            Map data = JSON.decode(request.responseText);
          
          
        } else {
          throw new Exception(request);
        }
      });

      // POST the data to the server
      var url = baseUrl + " /player";
      request.open("POST", url, async: false);

      String jsonData = '{ name: "'+name+'" }'; // etc...
      request.send(jsonData); // perform the async POST
  }
  
  void onDataLoadedCreatePlayer(data) {
    
  }
  
  void onDataLoaded(String responseText) {
    var jsonString = responseText;
    print(jsonString);
  }
  
  int createGame() {
    
  }
  
  joinGame(int  gameId) {
    
  }
  
  void listGames() {
    
  }
  
  
  
  
  
  
  
}