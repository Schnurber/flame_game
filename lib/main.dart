import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';

/// Creates new game and gesture recognizer
void main() async {
  Size dimensions = await Flame.util.initialDimensions();
  MyGame g = new MyGame(dimensions);
  runApp(g.widget);
  Flame.util.addGestureRecognizer(new TapGestureRecognizer()
    ..onTapDown = (TapDownDetails evt) =>
        g.handleInput(evt.globalPosition.dx, evt.globalPosition.dy));
}

/// Simple game class
class MyGame extends Game {
  // The only sprite
  SpriteComponent comp;

  // Fullscreen dimension
  Size dimensions;
  AnimationController controller;
  Animation<double> posAnimation;

  /// Gets dimensions of screen
  MyGame(this.dimensions) {
    Sprite sprite = Sprite("ship.png");
    comp = new SpriteComponent.fromSprite(
        dimensions.width / 4, dimensions.width / 4, sprite);
    // Position in center
    comp.x = dimensions.width / 2 - comp.width / 2;
    comp.y = dimensions.height / 2 - comp.height / 2;
  }

  /// Game loop
  @override
  void render(Canvas canvas) {
    //Render Text
    TextPainter txt = Flame.util.text('Tap on Screen',
        textAlign: TextAlign.center, fontSize: 24.0, color: Colors.blue[800]);
    txt.paint(
        canvas, Offset(dimensions.width / 2 - txt.width / 2, 50.0)); // position
    // Update ship pos
    comp.y += 1;
    if (comp.y > dimensions.height) comp.y = -comp.height;
    //Render ship
    comp.render(canvas);
  }

  /// From gesture recognizer
  void handleInput(double xp, double yp) {
    comp.x = xp - comp.width / 2;
    comp.y = yp - comp.height / 2;
  }

  @override
  void update(double t) {
    // TODO: implement update
  }
}
