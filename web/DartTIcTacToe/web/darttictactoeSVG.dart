// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// library sunflower;

import 'dart:html';
import 'dart:svg';
import '../lib/Client.dart';
import '../lib/Enum.dart';
import '../lib/Model.dart';
import '../lib/ModelImpl.dart';

final SvgElement svg = querySelector("#svg");

int spacing = 50;

Model model;

getCircle(cx, cy, r){
  CircleElement circle = new CircleElement();
    circle.setAttribute('cx', cx.toString());
    circle.setAttribute('cy', cy.toString());
    circle.setAttribute('r', (r - 5).toString());
    circle.setAttribute('fill', 'white');
    circle.setAttribute('stroke-width', '5');
    circle.setAttribute('stroke', 'red');
    
    return circle;
}

getX(x, y, width, height){
  SvgElement xElement = new SvgElement.tag('g');
  LineElement line1 = new LineElement();
  line1
    ..setAttribute('x1', (x + 2).toString())
    ..setAttribute('y1', (y + 2).toString())
    ..setAttribute('x2', (x + width - 2).toString())
    ..setAttribute('y2', (y + height - 2).toString())
    ..setAttribute('stroke', 'blue')
    ..setAttribute('stroke-width', '5');

  LineElement line2 = new LineElement();
  line2
    ..setAttribute('x1', (x + 2).toString())
    ..setAttribute('y1', (y + height - 2).toString())
    ..setAttribute('x2', (x + width - 2).toString())
    ..setAttribute('y2', (y + 2).toString())
    ..setAttribute('stroke', 'blue')
    ..setAttribute('stroke-width', '5');
  
  xElement.children.add(line1);
  xElement.children.add(line2);
  
  return xElement;
}

int currentMove = 0;

void main() {
  model = new ModelImpl();
  drawGrid();
}

void drawGrid(){
  for(int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      
      RectElement rect = new RectElement();
          rect
            ..setAttribute('x', (i * spacing).toString())
            ..setAttribute('y', (j * spacing).toString() )
            ..setAttribute('height', spacing.toString())
            ..setAttribute('width', spacing.toString())
            ..setAttribute('fill', 'white')
            ..setAttribute('opacity', '0')
            ..setAttribute("column", i.toString())
            ..setAttribute("row", j.toString());
          
        if(i < 2 && j > 1) {
          
          int x = int.parse(rect.getAttribute("x")) + int.parse(rect.getAttribute("width"));
          drawLine(x.toString(), "0", x.toString(), (spacing * 3).toString());
        }
        if(i > 1 && j < 2) {
          int y = int.parse(rect.getAttribute("y")) + int.parse(rect.getAttribute("height"));
          
          drawLine("0", y.toString(), (spacing * 3).toString(), y.toString());
        }
          
          rect.onClick.listen(mouseDown);
          
          svg.children.add(rect);
    }
  }
}

void drawLine(x1, y1, x2, y2) {
  LineElement line = new LineElement();
  
  line
      ..setAttribute('x1', x1)
      ..setAttribute('y1', y1)
      ..setAttribute('x2', x2)
      ..setAttribute('y2', y2)
      ..setAttribute('stroke', 'black')
      ..setAttribute('stroke-width', '4');
  svg.children.add(line);
 
}

void mouseDown(MouseEvent event) {
  
  RectElement rect = event.toElement;
  
  int column = int.parse(rect.getAttribute("column"));
  int row = int.parse(rect.getAttribute("row"));
  
 if(currentMove % 2 == 0){
   int cx = int.parse(rect.getAttribute('x')) + 25;
   int cy = int.parse(rect.getAttribute('y')) + 25;
   double r = double.parse(rect.getAttribute('width'));
   model.setCell(row, column, Enum.O);
   rect.replaceWith(getCircle(cx, cy, (r / 2)));
 } else {
   int x1 = int.parse(rect.getAttribute('x'));
   int y1 = int.parse(rect.getAttribute('y'));
   int width = int.parse(rect.getAttribute("width"));
   int height = int.parse(rect.getAttribute("height"));
   model.setCell(row, column, Enum.X);   
   rect.replaceWith(getX(x1, y1, width, height));
 }
 
 currentMove++;
}
