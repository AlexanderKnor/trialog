import 'package:flutter/material.dart';

/// Subtle hover overlay with elegant action buttons
/// Manages hover state for the entire card area including buttons
class HoverActionOverlay extends StatefulWidget {
  final Widget Function(bool isHovered) childBuilder;
  final List<HoverAction> actions;
  final Widget? topLeftWidget;

  const HoverActionOverlay({
    super.key,
    required this.childBuilder,
    required this.actions,
    this.topLeftWidget,
  });

  @override
  State<HoverActionOverlay> createState() => _HoverActionOverlayState();
}

class _HoverActionOverlayState extends State<HoverActionOverlay>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHover(bool hovering) {
    if (_isHovered != hovering) {
      setState(() => _isHovered = hovering);
      if (hovering) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // The child widget (card) - receives hover state
          widget.childBuilder(_isHovered),

          // Top left widget (e.g., children count badge) - always visible
          if (widget.topLeftWidget != null)
            Positioned(
              top: -6,
              left: -6,
              child: IgnorePointer(
                child: widget.topLeftWidget!,
              ),
            ),

          // Action buttons inside card (top right)
          if (widget.actions.isNotEmpty)
            Positioned(
              top: 8,
              right: 8,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  alignment: Alignment.topRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (int i = 0; i < widget.actions.length; i++) ...[
                        if (i > 0) const SizedBox(width: 6),
                        _CompactActionButton(
                          action: widget.actions[i],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Subtle action button designed to match elegant card design
class _CompactActionButton extends StatefulWidget {
  final HoverAction action;

  const _CompactActionButton({
    required this.action,
  });

  @override
  State<_CompactActionButton> createState() => _CompactActionButtonState();
}

class _CompactActionButtonState extends State<_CompactActionButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Tooltip(
        message: widget.action.tooltip,
        waitDuration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C2E),
          borderRadius: BorderRadius.circular(6),
        ),
        textStyle: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isHovered
                ? widget.action.color
                : widget.action.color.withValues(alpha: 0.9),
            boxShadow: [
              BoxShadow(
                color: widget.action.color.withValues(alpha: _isHovered ? 0.25 : 0.15),
                blurRadius: _isHovered ? 8 : 4,
                offset: Offset(0, _isHovered ? 3 : 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.action.onPressed,
              customBorder: const CircleBorder(),
              splashColor: Colors.white.withValues(alpha: 0.2),
              highlightColor: Colors.white.withValues(alpha: 0.1),
              child: Center(
                child: Icon(
                  widget.action.icon,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
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
