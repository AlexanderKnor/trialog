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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConnectorLayer &&
          runtimeType == other.runtimeType &&
          parentPosition == other.parentPosition &&
          _listEquals(childrenPositions, other.childrenPositions) &&
          lineColor == other.lineColor &&
          strokeWidth == other.strokeWidth;

  @override
  int get hashCode =>
      parentPosition.hashCode ^
      childrenPositions.hashCode ^
      lineColor.hashCode ^
      strokeWidth.hashCode;

  bool _listEquals(List<Offset> a, List<Offset> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
