import 'package:flutter/material.dart';
import 'package:trialog/core/constants/design_constants.dart';
import 'package:trialog/features/organization_chart/presentation/widgets/organization_connector_painter.dart';

/// Isolated widget for rendering connector lines
/// Only rebuilds when positions actually change
class ConnectorLayer extends StatelessWidget {
  final Offset parentPosition;
  final List<Offset> childrenPositions;
  final Color? lineColor;
  final double? strokeWidth;

  const ConnectorLayer({
    super.key,
    required this.parentPosition,
    required this.childrenPositions,
    this.lineColor,
    this.strokeWidth,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        painter: OrganizationConnectorPainter(
          parentPosition: parentPosition,
          childrenPositions: childrenPositions,
          lineColor: lineColor ?? DesignConstants.primaryColor.withValues(alpha: 0.4),
          strokeWidth: strokeWidth ?? 2.0,
        ),
      ),
    );
  }
}
