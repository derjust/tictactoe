// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library sunflower;

import 'dart:html';
import 'dart:math';

const String ORANGE = "orange";
const int SEED_RADIUS = 30;
const int BOX_SIZE = 100;
const int MAX_D = 300;
const int rows = 3;
const int cols = 3;
const num centerX = MAX_D / 2;
const num centerY = centerX;

final CanvasRenderingContext2D context =
  (querySelector("#canvas") as CanvasElement).context2D;

void main() {
  draw();
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

  drawSeed(1 * BOX_SIZE, 2 * BOX_SIZE);
  drawCross(0 * BOX_SIZE, 1 * BOX_SIZE);
}

/// Draw a small circle representing a seed centered at (x,y).
void drawSeed(num x, num y) {
  context..beginPath()
         ..lineWidth = 10
         ..strokeStyle = "BLUE"
         ..arc(x + BOX_SIZE / 2, y + BOX_SIZE / 2, SEED_RADIUS, 0, 2 * PI, false)
         ..closePath()
         ..stroke();
}


/// Draw a small circle representing a seed centered at (x,y).
void drawCross(num x, num y) {
  x = x + BOX_SIZE / 2;
  y = y + BOX_SIZE / 2;
  context..beginPath()
         ..lineWidth = 10
         ..strokeStyle = ORANGE
         ..moveTo(x - SEED_RADIUS / 2, y - SEED_RADIUS / 2)
         ..lineTo(x + SEED_RADIUS / 2, y + SEED_RADIUS / 2)
         ..moveTo(x - SEED_RADIUS / 2, y + SEED_RADIUS / 2)
         ..lineTo(x + SEED_RADIUS / 2, y - SEED_RADIUS / 2)
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
