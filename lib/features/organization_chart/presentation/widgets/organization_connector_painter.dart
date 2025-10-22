import 'package:flutter/material.dart';

/// Custom painter that draws elegant curved lines between parent and children nodes
class OrganizationConnectorPainter extends CustomPainter {
  /// Position of the parent node's bottom center
  final Offset parentPosition;

  /// Positions of all children nodes' top centers
  final List<Offset> childrenPositions;

  /// Color of the connector lines
  final Color lineColor;

  /// Width of the connector lines
  final double strokeWidth;

  const OrganizationConnectorPainter({
    required this.parentPosition,
    required this.childrenPositions,
    this.lineColor = Colors.blue,
    this.strokeWidth = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (childrenPositions.isEmpty) return;

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw curved line from parent to each child
    for (final childPosition in childrenPositions) {
      final path = _createCurvedPath(parentPosition, childPosition);
      canvas.drawPath(path, paint);
    }
  }

  /// Creates an elegant curved path from parent to child using cubic bezier curve
  Path _createCurvedPath(Offset start, Offset end) {
    final path = Path();
    path.moveTo(start.dx, start.dy);

    // Calculate control points for smooth S-curve
    final verticalDistance = end.dy - start.dy;
    final horizontalDistance = end.dx - start.dx;

    // If nodes are vertically aligned (no horizontal offset)
    if (horizontalDistance.abs() < 5) {
      // Simple vertical line
      path.lineTo(end.dx, end.dy);
    } else {
      // Elegant curved line
      // Control points are positioned to create smooth S-curve
      final controlPointOffset = verticalDistance * 0.6;

      final controlPoint1 = Offset(
        start.dx,
        start.dy + controlPointOffset,
      );

      final controlPoint2 = Offset(
        end.dx,
        end.dy - controlPointOffset,
      );

      // Cubic bezier curve for elegant connection
      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        end.dx,
        end.dy,
      );
    }

    return path;
  }

  @override
  bool shouldRepaint(OrganizationConnectorPainter oldDelegate) {
    return parentPosition != oldDelegate.parentPosition ||
        childrenPositions != oldDelegate.childrenPositions ||
        lineColor != oldDelegate.lineColor ||
        strokeWidth != oldDelegate.strokeWidth;
  }
}
