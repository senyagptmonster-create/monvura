import 'dart:math' as math;
import 'package:flutter/material.dart';

class SleepChronotypePainter extends CustomPainter {
  final String chronotype; // Bear, Lion, Wolf, Dolphin

  const SleepChronotypePainter({required this.chronotype});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2 * 0.88;

    // 24-hour circular dial track
    final trackPaint = Paint()
      ..color = const Color(0xFF1E293B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14.0;
    canvas.drawCircle(center, radius, trackPaint);

    // Sleep zone arc (e.g. 23:00 to 07:00 -> ~120 degrees)
    final sleepArcPaint = Paint()
      ..color = const Color(0xFF6366F1).withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14.0
      ..strokeCap = StrokeCap.round;

    // 23:00 is around top-right, 07:00 is bottom-right
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 3,
      math.pi * 0.75,
      false,
      sleepArcPaint,
    );

    // Peak cognitive zone arc (10:00 to 14:00)
    final peakArcPaint = Paint()
      ..color = const Color(0xFFA5B4FC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14.0
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.65,
      math.pi * 0.45,
      false,
      peakArcPaint,
    );

    // Center icon badge
    final badgePaint = Paint()..color = const Color(0xFF101424);
    canvas.drawCircle(center, radius * 0.58, badgePaint);
    canvas.drawCircle(center, radius * 0.58, Paint()..color = const Color(0xFF6366F1).withValues(alpha: 0.3)..style = PaintingStyle.stroke..strokeWidth = 2.0);
  }

  @override
  bool shouldRepaint(covariant SleepChronotypePainter oldDelegate) {
    return oldDelegate.chronotype != chronotype;
  }
}
