library Client;

import 'package:logging/logging.dart'; 
import 'package:logging_handlers/logging_handlers_shared.dart';
import 'dart:html';
import 'Model.dart';
import 'ModelImpl.dart';
import 'dart:convert';
import 'Enum.dart';
//409
class BoardPosition {
  int col;
  int row;
}

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
      var url = baseUrl + "/player";
      request.open("POST", url, async: false);

      String jsonData = '{ name: "'+name+'" }'; 
      request.send(jsonData); // perform the async POST
  }
  
  void createGame() {
    HttpRequest request = new HttpRequest(); // create a new XHR
    
    // add an event handler that is called when the request finishes
    request.onReadyStateChange.listen((_) {
      if (request.readyState == HttpRequest.DONE &&
          (request.status == 200 || request.status == 0)) {
          // data saved OK.
          print(request.responseText); // output the response from the server
        
          Map data = JSON.decode(request.responseText);
          String gameid = data["gameid"];
          model.setGameId(gameid);
        
      } else {
        throw new Exception(request);
      }
    });

    // POST the data to the server
    var url = baseUrl + " /game";
    request.open("POST", url, async: false);

    String jsonData = '{ playerid: "'+model.getPlayerId()+'" }'; 
    request.send(jsonData); // perform the async POST
  }
  
  void joinGame(String gameId) {
    HttpRequest request = new HttpRequest(); // create a new XHR

    // POST the data to the server
    var url = baseUrl + "/game/" + gameId;
    request.open("POST", url, async: false);
    
    var mapData = new Map();
    mapData["playerid"] = model.getPlayerId();

    String jsonData = JSON.encode(mapData); 
    
    request.send(jsonData); // perform the async POST
        
  }
  
  void listGames() {
    HttpRequest request = new HttpRequest(); // create a new XHR
    
    // add an event handler that is called when the request finishes
    request.onReadyStateChange.listen((_) {
      if (request.readyState == HttpRequest.DONE &&
          (request.status == 200 || request.status == 0)) {
          // data saved OK.
          print(request.responseText); // output the response from the server
          
          List<String> games = new List();
          
          var data = JSON.decode(request.responseText);
          for(var element in data.games ) {
            games.add(element["gameid"]);
          }
        
      } else {
        throw new Exception(request);
      }
    });

    // POST the data to the server
    var url = baseUrl + " /game";
    request.open("GET", url, async: false);

    request.send(); // perform the async POST    
  }
  
  
  void setCell(int row, int col, Enum value) {
    HttpRequest request = new HttpRequest(); // create a new XHR
    
    // add an event handler that is called when the request finishes
    request.onError.listen((_) {
      warn("blub");
    });
    request.onReadyStateChange.listen((_) {
      if (request.readyState == HttpRequest.DONE &&
          (request.status == 204 || request.status == 0)) {
          // data saved OK.
          print("Posted Move"); // output the response from the server

          updateBoard();
        
      } else {
        warn("Error: " +request.toString());
      }
    });

    // POST the data to the server
    var url = baseUrl + "/game/" + model.getGameId() + "/move";
    request.open("POST", url, async: false);
    
    var mapData = new Map();
    mapData["playerid"] = model.getPlayerId();
    mapData["field"] = mapCell(row, col);

    String jsonData = JSON.encode(mapData); 
    request.send(jsonData); // perform the async POST
    
//    model.setCell(row, col, value);
  }
  
  void updateBoard() {
    var url = baseUrl + "/game/" + model.getGameId() + "/move";
    HttpRequest request = new HttpRequest(); // create a new XHR
    
    // add an event handler that is called when the request finishes
    request.onReadyStateChange.listen((_) {
      if (request.readyState == HttpRequest.DONE &&
          (request.status == 200 || request.status == 0)) {
/*
URL: /game/{ gameid: 123 }/move

HTTP METHOD GET

RESPONSE: [ moves: { { field: A1, playerid: 123 }, { field: B2, playerid: 456 } } ]
 */
          Map data = JSON.decode(request.responseText);
          List moves = data["moves"];
          model.resetCells();
          for(var aField in moves) {
            
            BoardPosition pos = mapCellBack(aField["field"]);

            if (aField["playerid"].compareTo(model.getPlayerId()) == 0) {
              model.setCell(pos.row, pos.col, Enum.X);
            } else {
              model.setCell(pos.row, pos.col, Enum.O);
            }
          }
          
      } else {
        throw new Exception(request);
      }
    });

    // POST the data to the server
    
    request.open("GET", url, async: false);
     
    request.send(); // perform the async POST
  }
  
  String mapCell(int row, int col) {
    String retValue;
    if (0 == row) {
      retValue = "A";
    } else if (1 == row) {
      retValue = "B";
    } else  if (2 == row) {
      retValue ="C";
    }
    
    retValue += col.toString();
    
    return retValue;
  }
  

  
  BoardPosition mapCellBack(String cell) {
    String row = cell.substring(0,1);
    String col = cell.substring(1,1);
    BoardPosition retValue = new BoardPosition();
    if ("A".compareTo(row) == 0) {
      retValue.row= 0;
    } else if ("B".compareTo(row) == 0) {
      retValue.row= 1;
    } else {
      retValue.row= 2;
    }
    
    retValue.col = int.parse(col);
    return retValue;
    }
  
  Enum getCell(int row, int col) {
    return model.getCell(row, col);
  }
  
}
