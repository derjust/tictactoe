library Client;

import 'dart:html';
import 'Model.dart';
import 'ModelImpl.dart';
import 'dart:convert';
import 'Enum.dart';

class Client {
  String baseUrl;

  Model model;
  
  Client(String baseUrl) {
    if (baseUrl == null || baseUrl.isEmpty) {
      throw new Exception("No baseUrl!");
    }
    this.baseUrl = baseUrl;
    this.model = new ModelImpl();
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
            String playerid = data["playerid"];
            model.setPlayerId(playerid);
          
        } else {
          throw new Exception(request);
        }
      });

      // POST the data to the server
      var url = baseUrl + " /player";
      request.open("POST", url, async: false);

      String jsonData = '{ name: "'+name+'" }'; 
      request.send(jsonData); // perform the async POST
  }
  
  int createGame() {
    
  }
  
  joinGame(int  gameId) {
    
  }
  
  void listGames() {
    
  }
  
  
  void setCell(int row, int col, Enum value) {
    model.setCell(row, col, value);
  }
  
  Enum getCell(int row, int col) {
    return model.getCell(row, col);
  }
  
  
}