import 'dart:math';

import 'package:flutter/material.dart';

import 'ar_location_view.dart';

enum RadarPosition {
  topLeft,
  topCenter,
  topRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
  custom,
}

class RadarPainter extends CustomPainter {
  const RadarPainter({
    required this.maxDistance,
    required this.arAnnotations,
    required this.heading,
    required this.markerColor,
    required this.background,
    required this.borderColor,
  });

  final angle = pi / 7;

  final Color markerColor;
  final Color background;
  final Color borderColor;
  final double maxDistance;
  final List<ArAnnotation> arAnnotations;
  final double heading;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final center = Offset(radius, radius);

    // Rotate the entire canvas based on the heading
    canvas.save(); // Save the current state of the canvas
    canvas.translate(radius, radius);
    // Convert heading from degrees to radians by multiplying by pi/180
    canvas.rotate(-heading *
        (pi /
            180)); // Negative to rotate in opposite direction of heading change
    canvas.translate(-radius, -radius);

    // Draw the background circle
    final Paint paintBackground = Paint()..color = background;
    canvas.drawCircle(center, radius, paintBackground);

    // Create a paint for the border
    final Paint paintBorder = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..color = borderColor;

    // Draw the border
    canvas.drawCircle(center, radius, paintBorder);

    // Gradient arc for viewing direction
    // final Path path = Path();
    // final double angleView = pi / 7; // example base angle
    // path.moveTo(center.dx, center.dy);
    // path.lineTo(center.dx + radius * cos(angleView),
    //     center.dy + radius * sin(angleView));
    // path.arcTo(Rect.fromCircle(center: center, radius: radius), angleView,
    //     -2 * angleView, false);
    // path.close();
    // final Paint paint2 = Paint()
    //   ..shader = RadialGradient(
    //     colors: [
    //       Colors.blueAccent.withAlpha(168),
    //       Colors.blueAccent.withAlpha(20),
    //     ],
    //   ).createShader(Rect.fromCircle(center: center, radius: radius))
    //   ..style = PaintingStyle.fill;
    // canvas.drawPath(path, paint2);

    // Draw markers
    drawMarker(canvas, arAnnotations, radius);

    canvas.restore(); // Restore the canvas to the saved state
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  void drawMarker(
      Canvas canvas, List<ArAnnotation> annotations, double radius) {
    for (final annotation in annotations) {
      final Paint paint = Paint()..color = markerColor;
      final distanceInRadar =
          annotation.distanceFromUser / maxDistance * radius;
      final alpha = pi - annotation.azimuth.toRadians;
      final dx = (distanceInRadar) * sin(alpha);
      final dy = (distanceInRadar) * cos(alpha);
      final center = Offset(dx + radius, dy + radius);
      canvas.drawCircle(center, 3, paint);
    }
  }
}
