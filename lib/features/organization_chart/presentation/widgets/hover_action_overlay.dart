import 'package:flutter/material.dart';
import 'package:trialog/core/constants/design_constants.dart';

/// Isolated hover overlay that doesn't trigger parent rebuilds
/// This widget manages its own hover state independently
class HoverActionOverlay extends StatefulWidget {
  final Widget child;
  final List<HoverAction> actions;
  final Widget? topLeftWidget;

  const HoverActionOverlay({
    super.key,
    required this.child,
    required this.actions,
    this.topLeftWidget,
  });

  @override
  State<HoverActionOverlay> createState() => _HoverActionOverlayState();
}

class _HoverActionOverlayState extends State<HoverActionOverlay> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // The child widget (card)
          widget.child,

          // Top left widget (e.g., children count badge)
          if (widget.topLeftWidget != null)
            Positioned(
              top: 8,
              left: 8,
              child: widget.topLeftWidget!,
            ),

          // Hover actions (top right)
          if (_isHovered && widget.actions.isNotEmpty)
            Positioned(
              top: 8,
              right: 8,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (int i = 0; i < widget.actions.length; i++) ...[
                    if (i > 0) const SizedBox(width: 4),
                    _buildActionButton(widget.actions[i]),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(HoverAction action) {
    return Container(
      decoration: BoxDecoration(
        color: action.color,
        borderRadius: BorderRadius.circular(DesignConstants.borderRadiusRound),
        boxShadow: DesignConstants.shadowSm,
      ),
      child: IconButton(
        icon: Icon(action.icon, size: 16, color: Colors.white),
        onPressed: action.onPressed,
        tooltip: action.tooltip,
        padding: const EdgeInsets.all(4),
        constraints: const BoxConstraints(
          minWidth: 28,
          minHeight: 28,
        ),
      ),
    );
  }
}

/// Action configuration for hover overlay
class HoverAction {
  final IconData icon;
  final String tooltip;
  final Color color;
  final VoidCallback onPressed;

  const HoverAction({
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.onPressed,
  });
}
