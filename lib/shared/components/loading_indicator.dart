import 'package:flutter/material.dart';
import 'package:trialog/core/constants/design_constants.dart';

/// Loading indicator component
class LoadingIndicator extends StatelessWidget {
  final double? size;
  final Color? color;

  const LoadingIndicator({
    super.key,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size ?? DesignConstants.iconSizeLg,
        height: size ?? DesignConstants.iconSizeLg,
        child: CircularProgressIndicator(
          color: color ?? DesignConstants.primaryColor,
          strokeWidth: 3.0,
        ),
      ),
    );
  }
}
