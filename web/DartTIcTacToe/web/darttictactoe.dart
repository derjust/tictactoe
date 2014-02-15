// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library sunflower;

import 'dart:html';
import 'dart:math';
import '../lib/Client.dart';
import '../lib/Enum.dart';

const int MAX_D = 400;
const int rows = 3;
const int cols = 3;
const num BOX_SIZE = MAX_D / 3;
const num centerX = MAX_D / 2;
const num centerY = centerX;
const num CROSS_RADIUS = BOX_SIZE * 0.4 - 10;
const num CIRCLE_RADIUS = BOX_SIZE * 0.4 - 10;

final CanvasElement canvas = querySelector("#canvas") as CanvasElement;
final CanvasRenderingContext2D context = canvas.context2D;

int currentMove = 0;

Client client = new Client("http://localhost:58080/tictactoe-web/simple.groovy");

void main() {
  canvas.width = MAX_D;
  canvas.height = MAX_D;
  canvas.onMouseUp.listen(mouseDown);
  draw(0);
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
         drawCircle(c * BOX_SIZE, r * BOX_SIZE);
       } else if (value == Enum.X){
         drawCross(c * BOX_SIZE, r * BOX_SIZE);
       }
    }
  }
      
 // window.requestAnimationFrame(_update);
}

/// Draw a small circle representing a seed centered at (x,y).
void drawCircle(num x, num y) {
  x = x + BOX_SIZE / 2;
  y = y + BOX_SIZE / 2;
  
  var gradient = context.createRadialGradient(x, y, CIRCLE_RADIUS - 5, x, y, CIRCLE_RADIUS + 5);
  gradient.addColorStop(0, 'gray');
  gradient.addColorStop(1, 'blue');
  
  context..beginPath()
         ..lineWidth = 10
         ..strokeStyle = gradient
         ..arc(x, y, CIRCLE_RADIUS, 0, 2 * PI, false)
         ..closePath()
         ..stroke();
}


/// Draw a small circle representing a seed centered at (x,y).
void drawCross(num x, num y) {
  
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
         ..moveTo(x - CROSS_RADIUS, y - CROSS_RADIUS)
         ..lineTo(x + CROSS_RADIUS, y + CROSS_RADIUS)
         ..closePath()
         ..stroke();
  
  context..beginPath()
         ..lineWidth = 10
         ..strokeStyle = gradient1
         ..moveTo(x - CROSS_RADIUS, y + CROSS_RADIUS)
         ..lineTo(x + CROSS_RADIUS, y - CROSS_RADIUS)
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
