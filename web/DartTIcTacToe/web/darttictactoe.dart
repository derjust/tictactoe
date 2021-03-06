// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:logging_handlers/logging_handlers_shared.dart';

import 'dart:html';
import 'dart:math';
import '../lib/Client.dart';
import '../lib/Enum.dart';
import 'dart:async';

WebSocket ws;


const int MAX_D = 400;
const int rows = 3;
const int cols = 3;
const num BOX_SIZE = MAX_D / 3;
const num centerX = MAX_D / 2;
const num centerY = centerX;
const num CROSS_RADIUS = BOX_SIZE * 0.4 - 10;
const num CIRCLE_RADIUS = BOX_SIZE * 0.4 - 10;

final CanvasElement canvas = querySelector("#board") as CanvasElement;
final CanvasRenderingContext2D context = canvas.context2D;

final DivElement container = querySelector("#container");
final DivElement loginView = querySelector("#login");
final DivElement startscreenView = querySelector("#startscreen");
final DivElement gameView = querySelector("#game");

int currentMove = 0;

Client client = new Client("http://192.168.2.24:8080/TicTacWildfy-0.0.1-SNAPSHOT/rest");

void main() {
//  initWebSocket();
//  startQuickLogging();
  canvas.width = MAX_D;
  canvas.height = MAX_D;
  canvas.onMouseUp.listen(mouseDown);
  draw(0);
  
  querySelector("#submitNickname").onClick.listen(login);
  querySelector("#joinGame").onClick.listen(joinGame);
  querySelector("#createGame").onClick.listen(createGame);
  querySelector("#abort").onClick.listen(abort);
      
  
  container.children.remove(gameView);
  container.children.remove(startscreenView);
}

void login(MouseEvent event) {
  
  InputElement nickname = querySelector("#nickname") as InputElement;
  
  client.createPlayer(nickname.value, loginDone);
  
}

void loginDone(int playerId) {
  //success
  container.children.remove(loginView);
  container.children.add(startscreenView);
  initStartscreenView();
}


void initStartscreenView() {
  client.listGames(onListGamesDone);
}

void onListGamesDone(List<int> games) {
  
  querySelector("#gameList").children.clear();
  for(int game in games) {
    var newGame = new OptionElement();
    newGame.value = game.toString();
    newGame.text = "Game " + game.toString();
    newGame.selected = false;
    querySelector("#gameList").children.add(newGame);
  }
  
}

void joinGame(MouseEvent event) {
  for( var gameElement in querySelector("#gameList").children) {
    if((gameElement as OptionElement).selected) {
      client.joinGame(gameElement.value);
    }
  }
  
  container.children.remove(startscreenView);
  container.children.add(gameView);
}

void createGame(MouseEvent event) {
  
  client.createGame();
  
  container.children.remove(startscreenView);
  container.children.add(gameView);
}

void abort(MouseEvent event) {
  //TODO leave game
  
  container.children.remove(gameView);
  container.children.add(startscreenView);
}

void mouseDown(MouseEvent event) {
  if (event != null) {
    int x = event.offset.x;
    int y = event.offset.y;

    int row = calcRow(y);
    int col = calcColumn(x);
    
    if(currentMove % 2 == 0) {
      client.setCell(row, col, Enum.X);  
    } else {
      client.setCell(row, col, Enum.O);
    }
    
    currentMove++;
  }
  
  draw(0);
}

int calcRow(int x) {
  return x ~/ BOX_SIZE;
}

int calcColumn(int y) {
  return y ~/ BOX_SIZE;
}

/// Draw the complete figure for the current number of seeds.
void draw(num dt) {
  context.clearRect(0, 0, MAX_D, MAX_D);

  dt = dt * 0.005;
  num vr = (dt % 10 - 5).abs();
  num vc = ((dt*0.8+5) % 10 - 5).abs();
  num vcs = ((dt*1.5+3) % 6 - 3).abs();

  for (var r = 1; r < rows; r++) {
    drawLine(0, vr + r * BOX_SIZE, dt % 5 + MAX_D, r * BOX_SIZE - vr);    
  }
  
  for (var c = 1; c < cols; c++) {
    drawLine(vc + c * BOX_SIZE, 0, c * BOX_SIZE - vc, MAX_D);    
  }
  
  for (var r = 0; r < rows; r++) {
    for (var c = 0; c < cols; c++) {

      Enum value = client.getCell(r, c);
      if (value == Enum.O) {
         num size = CIRCLE_RADIUS + vcs - 3;
         drawCircle(c * BOX_SIZE, r * BOX_SIZE, size);
       } else if (value == Enum.X){
         num size = CROSS_RADIUS + vcs - 3;
         drawCross(c * BOX_SIZE, r * BOX_SIZE, size);
       }
    }
  }
      
 window.requestAnimationFrame(_update);
}

/// Draw a small circle representing a seed centered at (x,y).
void drawCircle(num x, num y, num size) {
  x = x + BOX_SIZE / 2;
  y = y + BOX_SIZE / 2;
  
  var gradient = context.createRadialGradient(x, y, size - 5, x, y, size + 5);
  gradient.addColorStop(0, 'gray');
  gradient.addColorStop(1, 'blue');
  
  context..beginPath()
         ..lineWidth = 10
         ..strokeStyle = gradient
         ..arc(x, y, size, 0, 2 * PI, false)
         ..closePath()
         ..stroke();
}


/// Draw a small circle representing a seed centered at (x,y).
void drawCross(num x, num y, num size) {
  
  x = x + BOX_SIZE / 2;
  y = y + BOX_SIZE / 2;
  
  var gradient1 = context.createLinearGradient(x - 5, y - 5, x + 5, y + 5);
  gradient1.addColorStop(0, 'RED');
  gradient1.addColorStop(1, 'ORANGE');
  
  var gradient2 = context.createLinearGradient(x - 5, y + 5, x + 5, y - 5);
  gradient2.addColorStop(0, 'RED');
  gradient2.addColorStop(1, 'ORANGE');
  
  context..beginPath()
         ..lineWidth = 10
         ..strokeStyle = gradient2
         ..moveTo(x - size, y - size)
         ..lineTo(x + size, y + size)
         ..closePath()
         ..stroke();
  
  context..beginPath()
         ..lineWidth = 10
         ..strokeStyle = gradient1
         ..moveTo(x - size, y + size)
         ..lineTo(x + size, y - size)
         ..closePath()
         ..stroke();
}

/// Draw a small circle representing a seed centered at (x,y).
void drawLine(num x1, num y1, num x2, num y2) {
  context..beginPath()
         ..lineWidth = 10
         ..strokeStyle = "BLACK"
         ..moveTo(x1, y1)
         ..lineTo(x2, y2)
         ..shadowBlur=20
         ..shadowColor="gray"
         ..shadowOffsetX=8
         ..shadowOffsetY=3
         ..closePath()
         ..stroke();
  
  context..beginPath()
         ..lineWidth = 1
         ..strokeStyle = "GRAY"
         ..moveTo(x1, y1)
         ..lineTo(x2, y2)
         ..closePath()
         ..stroke();
}


void _update(num highResTime) {
  draw(highResTime);
}


void outputMsg(String msg) {
  print(msg);
}

void initWebSocket([int retrySeconds = 2]) {
  var reconnectScheduled = false;

  outputMsg("Connecting to websocket");
  ws = new WebSocket('ws://192.168.2.24:8080/TicTacWildfy-0.0.1-SNAPSHOT');

  void scheduleReconnect() {
    if (!reconnectScheduled) {
      new Timer(new Duration(milliseconds: 1000 * retrySeconds), () => initWebSocket(retrySeconds * 2));
    }
    reconnectScheduled = true;
  }

  ws.onOpen.listen((e) {
    outputMsg('Connected');
    ws.send('Hello from Dart!');
  });

  ws.onClose.listen((e) {
    outputMsg('Websocket closed, retrying in $retrySeconds seconds');
    scheduleReconnect();
  });

  ws.onError.listen((e) {
    outputMsg("Error connecting to ws");
    scheduleReconnect();
  });

  ws.onMessage.listen((MessageEvent e) {
    outputMsg('Received message: ${e.data}');
  });
}
