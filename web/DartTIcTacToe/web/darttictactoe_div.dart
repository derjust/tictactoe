import 'dart:html';
import 'package:DartTIcTacToe/logger.dart' as Logger;

var player = 0;

void main() {
  
  querySelector("#A1").onClick.listen(handleClick);
  querySelector("#A2").onClick.listen(handleClick);
  querySelector("#A3").onClick.listen(handleClick);
  
  querySelector("#B1").onClick.listen(handleClick);
  querySelector("#B2").onClick.listen(handleClick);
  querySelector("#B3").onClick.listen(handleClick);
    
    
    querySelector("#C1").onClick.listen(handleClick);
    querySelector("#C2").onClick.listen(handleClick);
    querySelector("#C3").onClick.listen(handleClick);
      
      
}

void handleClick(MouseEvent event) {
  var cell= event.target.id; 
  print(cell + " clicked!");
  
  postCell(cell);
}



void postCell(cell) {
  var symbol;
  var url = "http://localhost:58080/tictactoe-web/simple.groovy?";
  if (player == 0) {
    symbol = "x";
  } else {
    symbol = "o";
  }
  url = url + "CMD=SET&coordinate="+cell +"&value=" + symbol;

   // call the web server asynchronously
   var request = HttpRequest.getString(url).then(onDataLoaded);
}

void onDataLoaded(data) {
  print(data);
  
  var url = "http://localhost:58080/tictactoe-web/simple.groovy?CMD=SHOW";
  var request = HttpRequest.getString(url).then(dump);
}

void dump(data) {
  print(data);
}
