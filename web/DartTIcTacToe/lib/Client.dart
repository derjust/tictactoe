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
  
  void createPlayer(String name, onSuccess(int)) {
    info("create player " + name);
      HttpRequest request = new HttpRequest(); // create a new XHR
      
      // add an event handler that is called when the request finishes
      request.onReadyStateChange.listen((_) {
        
        if (request.readyState == HttpRequest.DONE &&
            (request.status == 200 || request.status == 0)) {
            // data saved OK.
            print(request.responseText); // output the response from the server
          
            Map data = JSON.decode(request.responseText);
            int playerid = data["playerid"];
            info("created playerid " + playerid.toString());
            model.setPlayerId(playerid);
            
            onSuccess(playerid);
            
        }
        
      });

      // POST the data to the server
      var url = baseUrl + "/player";
      request.open("POST", url, async: false);
      request.setRequestHeader("Content-type","application/json");

      String jsonData = '{ "name": "'+name+'" }'; 
      request.send(jsonData); // perform the async POST
  }
  
  void createGame() {
    HttpRequest request = new HttpRequest(); // create a new XHR
    
    // add an event handler that is called when the request finishes
    request.onReadyStateChange.listen((_) {
      if (request.readyState == HttpRequest.DONE &&
          (request.status == 202 || request.status == 0)) {
          // data saved OK.
          print(request.responseText); // output the response from the server
        
          Map data = JSON.decode(request.responseText);
          int gameid = data["gameid"];
          model.setGameId(gameid);
        
      } else {
        info("state: " + request.readyState.toString());
        info("status: " + request.status.toString());
      }
    });

    // POST the data to the server
    var url = baseUrl + "/game";
    request.open("POST", url, async: false);
    request.setRequestHeader("Content-type","application/json");

    String jsonData = '{ "playerid": '+model.getPlayerId().toString()+' }'; 
    request.send(jsonData); // perform the async POST
  }
  
  void joinGame(String gameId) {
    HttpRequest request = new HttpRequest(); // create a new XHR

    // POST the data to the server
    var url = baseUrl + "/game/" + gameId;
    request.open("POST", url, async: false);
    request.setRequestHeader("Content-type","application/json");
    
    var mapData = new Map();
    mapData["playerid"] = model.getPlayerId();

    String jsonData = JSON.encode(mapData); 
    
    request.send(jsonData); // perform the async POST
        
  }
  
  void listGames( onSuccess(List)) {
    HttpRequest request = new HttpRequest(); // create a new XHR
    
    // add an event handler that is called when the request finishes
    request.onReadyStateChange.listen((_) {
      if (request.readyState == HttpRequest.DONE &&
          (request.status == 200 || request.status == 0)) {
          // data saved OK.
          print(request.responseText); // output the response from the server
          
          List<String> games = new List();
          
          var data = JSON.decode(request.responseText);
          for(var element in data ) {
            games.add(element["gameid"]);
          }
          
          model.setGames(games);
          onSuccess(games);
      }
    });

    // POST the data to the server
    var url = baseUrl + "/game";
    request.open("GET", url, async: false);
    request.setRequestHeader("Content-type","application/json");

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
    var url = baseUrl + "/game/" + model.getGameId().toString() + "/move";
    request.open("POST", url, async: false);
    request.setRequestHeader("Content-type","application/json");
    
    var mapData = new Map();
    mapData["playerid"] = model.getPlayerId();
    mapData["field"] = mapCell(row, col);

    String jsonData = JSON.encode(mapData); 
    request.send(jsonData); // perform the async POST
    
//    model.setCell(row, col, value);
  }
  
  void updateBoard() {
    var url = baseUrl + "/game/" + model.getGameId().toString() + "/move";
    HttpRequest request = new HttpRequest(); // create a new XHR
    
    // add an event handler that is called when the request finishes
    request.onReadyStateChange.listen((_) {
      if (request.readyState == HttpRequest.DONE &&
          (request.status == 202 || request.status == 0)) {
/*
URL: /game/{ gameid: 123 }/move

HTTP METHOD GET

RESPONSE: [ moves: { { field: A1, playerid: 123 }, { field: B2, playerid: 456 } } ]
 */
        String json = request.responseText;
          List data = JSON.decode(json);
          model.resetCells();
          for(var element in data) {
            int moveid= element["moveid"];
            
            loadMove(moveid);
          }
                    
      } 
    });

    // POST the data to the server
    
    request.open("GET", url, async: false);
    request.setRequestHeader("Content-type","application/json");
     
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
    String col = cell.substring(1,2);
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
 
  void loadMove(int moveId) {
    var url = baseUrl + "/game/" + model.getGameId().toString() +
        "/move/$moveId";
    HttpRequest request = new HttpRequest(); // create a new XHR

    // add an event handler that is called when the request finishes
    request.onReadyStateChange.listen((_) {
      if (request.readyState == HttpRequest.DONE && (request.status == 202 ||
          request.status == 0)) {
        /*
URL: /game/{ gameid: 123 }/move

HTTP METHOD GET

RESPONSE: [ moves: { { field: A1, playerid: 123 }, { field: B2, playerid: 456 } } ]
 */
        String json = request.responseText;
        var move = JSON.decode(json);
        move = move[0];
        info("Move: $move");

        BoardPosition pos = mapCellBack(move["field"]);

        if (move["playerid"].compareTo(model.getPlayerId()) == 0) {
          model.setCell(pos.row, pos.col, Enum.X);
        } else {
          model.setCell(pos.row, pos.col, Enum.O);
        }

      }
    });

    request.open("GET", url, async: false);
    request.setRequestHeader("Content-type", "application/json");

    request.send(); // perform the async POST
  }
  
}
