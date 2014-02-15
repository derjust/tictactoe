// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library sunflower;

import 'dart:html';
import 'dart:math';

const int MAX_D = 400;
const int rows = 3;
const int cols = 3;
const num BOX_SIZE = MAX_D / 3;
const num centerX = MAX_D / 2;
const num centerY = centerX;
const num CROSS_RADIUS = BOX_SIZE * 0.4 - 10;
const num CIRCLE_RADIUS = BOX_SIZE * 0.4 - 10;

final CanvasElement canvas = querySelector("#canvas") as CanvasElement;
final CanvasRenderingContext2D context =
  canvas.context2D;

int currentMove = 0;

void main() {
  canvas.width = MAX_D;
  canvas.height = MAX_D;
  canvas.onClick.listen(mouseDown);
  draw();
}

void mouseDown(MouseEvent event) {
  if (event != null) {
    int x = event.offset.x;
    int y = event.offset.y;
    
    
    
    if(currentMove % 2 == 0) {
      drawCircle(calcRow(x) * BOX_SIZE, calcColumn(y) * BOX_SIZE);
    } else {
      drawCross(calcRow(x) * BOX_SIZE, calcColumn(y) * BOX_SIZE);
    }
    
    currentMove++;
  }
}

int calcRow(int x) {
  return x ~/ BOX_SIZE;
}

int calcColumn(int y) {
  return y ~/ BOX_SIZE;
}

/// Draw the complete figure for the current number of seeds.
void draw() {
  context.clearRect(0, 0, MAX_D, MAX_D);

  for (var r = 1; r < rows; r++) {
    drawLine(0, r * BOX_SIZE, MAX_D, r * BOX_SIZE);    
  }
  
  for (var c = 1; c < cols; c++) {
    drawLine(c * BOX_SIZE, 0, c * BOX_SIZE, MAX_D);    
  }
  
}

/// Draw a small circle representing a seed centered at (x,y).
void drawCircle(num x, num y) {
  context..beginPath()
         ..lineWidth = 10
         ..strokeStyle = "BLUE"
         ..arc(x + BOX_SIZE / 2, y + BOX_SIZE / 2, CIRCLE_RADIUS, 0, 2 * PI, false)
         ..closePath()
         ..stroke();
}


/// Draw a small circle representing a seed centered at (x,y).
void drawCross(num x, num y) {
  x = x + BOX_SIZE / 2;
  y = y + BOX_SIZE / 2;
  context..beginPath()
         ..lineWidth = 10
         ..strokeStyle = "ORANGE"
         ..moveTo(x - CROSS_RADIUS, y - CROSS_RADIUS)
         ..lineTo(x + CROSS_RADIUS, y + CROSS_RADIUS)
         ..moveTo(x - CROSS_RADIUS, y + CROSS_RADIUS)
         ..lineTo(x + CROSS_RADIUS, y - CROSS_RADIUS)
         ..closePath()
         ..stroke();
}

/// Draw a small circle representing a seed centered at (x,y).
void drawLine(num x1, num y1, num x2, num y2) {
  context..beginPath()
         ..lineWidth = 10
         ..fillStyle = "BLACK"
         ..strokeStyle = "BLACK"
         ..moveTo(x1, y1)
         ..lineTo(x2, y2)
         ..closePath()
         ..stroke();
}
