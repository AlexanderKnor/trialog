import 'package:flutter/material.dart';
import 'package:trialog/core/constants/design_constants.dart';
import 'package:trialog/features/organization_chart/domain/entities/organization_node.dart';

/// Widget to display an organization node card
class OrganizationNodeCard extends StatelessWidget {
  final OrganizationNode node;
  final VoidCallback? onTap;

  const OrganizationNodeCard({
    super.key,
    required this.node,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: DesignConstants.elevationMd,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(DesignConstants.borderRadiusLg),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(DesignConstants.borderRadiusLg),
        child: Container(
          padding: const EdgeInsets.all(DesignConstants.spacingMd),
          width: 200,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Avatar or Company Icon
              _buildAvatar(context),
              const SizedBox(height: DesignConstants.spacingSm),

              // Name
              Text(
                node.name,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: DesignConstants.fontWeightSemiBold,
                  color: DesignConstants.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // Percentages (if employee exists)
              if (node.employee != null &&
                  (node.employee!.insurancePercentage != null ||
                      node.employee!.realEstatePercentage != null)) ...[
                const SizedBox(height: DesignConstants.spacingXs),
                if (node.employee!.insurancePercentage != null)
                  Text(
                    'V: ${node.employee!.insurancePercentage}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: DesignConstants.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                if (node.employee!.realEstatePercentage != null)
                  Text(
                    'I: ${node.employee!.realEstatePercentage}%',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: DesignConstants.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
              ],

              // Email (if available)
              if (node.employee?.email != null) ...[
                const SizedBox(height: DesignConstants.spacingXs),
                Text(
                  node.employee!.email!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: DesignConstants.primaryColor,
                    fontSize: DesignConstants.fontSizeXs,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    if (node.type == NodeType.company) {
      // Company icon
      return Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: DesignConstants.primaryColor,
          borderRadius: BorderRadius.circular(DesignConstants.borderRadiusMd),
        ),
        child: const Icon(
          Icons.business,
          size: DesignConstants.iconSizeLg,
          color: DesignConstants.textOnPrimary,
        ),
      );
    } else if (node.employee != null) {
      // Employee avatar
      final employee = node.employee!;
      if (employee.imageUrl != null) {
        return CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(employee.imageUrl!),
        );
      } else {
        return CircleAvatar(
          radius: 30,
          backgroundColor: DesignConstants.primaryColor,
          child: Text(
            employee.initials,
            style: const TextStyle(
              color: DesignConstants.textOnPrimary,
              fontSize: DesignConstants.fontSizeLg,
              fontWeight: DesignConstants.fontWeightSemiBold,
            ),
          ),
        );
      }
    }

    // Default icon
    return const CircleAvatar(
      radius: 30,
      backgroundColor: DesignConstants.primaryColor,
      child: Icon(
        Icons.person,
        size: DesignConstants.iconSizeMd,
        color: DesignConstants.textOnPrimary,
      ),
    );
  }
}
