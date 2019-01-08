import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:aeyrium_sensor/aeyrium_sensor.dart';
import 'package:sensors/sensors.dart';
import 'dart:math' as math;

/// Creates new game and gesture recognizer
void main() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  Size dimensions = await Flame.util.initialDimensions();
  MyGame g = new MyGame(dimensions);
  runApp(g.widget);

  Flame.util.addGestureRecognizer(new TapGestureRecognizer()
    ..onTapDown = (TapDownDetails evt) =>
        g.handleInput(evt.globalPosition.dx, evt.globalPosition.dy));

  AeyriumSensor.sensorEvents.listen((SensorEvent event) {
    g.handleTurn(event.pitch, event.roll);
  });

  accelerometerEvents.listen((AccelerometerEvent event) {
    // Do something with the event.
    g.handleAcc(event.x, event.y, event.z);
  });
}


/// Simple game class
class MyGame extends Game {
  // The only sprite
  SpriteComponent comp;
  String infoTxt = 'Tap on Screen';
  // Fullscreen dimension
  Size dimensions;

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
    TextPainter txt = Flame.util.text(infoTxt,
        textAlign: TextAlign.left, fontSize: 24.0, color: Colors.blue[800]);
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

  void handleTurn(double pitch, double roll) {
    /*
    double p = pitch / math.pi * 180.0;
    double r = roll  / math.pi * 180.0;

    infoTxt = 'Pitch:${p.toStringAsFixed(3)} Roll:${r.toStringAsFixed(3)}';
    comp.x -= r / 10;
    _handleSensor();
    */

  }
  void handleAcc(double ax, double ay, double az) {

    infoTxt = 'X:${ax.toStringAsFixed(3)}';
    comp.x -= ax;
    _handleSensor();
  }
  
  void _handleSensor() {
    if (comp.x > dimensions.width) comp.x = -comp.width;
    if (comp.x < -comp.width) comp.x = dimensions.width;
  }
  @override
  void update(double t) {
    // TODO: implement update
  }
}
