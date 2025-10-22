import 'package:flutter/material.dart';
import 'package:trialog/core/constants/design_constants.dart';

/// Empty state component
class EmptyState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.inbox_outlined,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(DesignConstants.spacingLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: DesignConstants.iconSizeXl,
              color: DesignConstants.textDisabled,
            ),
            const SizedBox(height: DesignConstants.spacingMd),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: DesignConstants.textPrimary,
                  ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: DesignConstants.spacingSm),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: DesignConstants.textSecondary,
                    ),
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: DesignConstants.spacingLg),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
