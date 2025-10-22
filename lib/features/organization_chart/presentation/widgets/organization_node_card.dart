import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:trialog/core/constants/design_constants.dart';
import 'package:trialog/features/organization_chart/domain/entities/organization_node.dart';

/// Premium organization node card with glassmorphism and smooth animations
/// Hover state is now controlled externally for better UX
class OrganizationNodeCard extends StatelessWidget {
  final OrganizationNode node;
  final VoidCallback? onTap;
  final bool isHovered;

  const OrganizationNodeCard({
    super.key,
    required this.node,
    this.onTap,
    this.isHovered = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final employee = node.employee;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
      transform: Matrix4.translationValues(0, isHovered ? -4 : 0, 0),
      child: Container(
        width: 240,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: DesignConstants.primaryColor.withValues(alpha: isHovered ? 0.12 : 0.06),
              blurRadius: isHovered ? 24 : 16,
              offset: Offset(0, isHovered ? 8 : 4),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: Colors.black.withValues(alpha: isHovered ? 0.04 : 0.03),
              blurRadius: isHovered ? 12 : 8,
              offset: Offset(0, isHovered ? 4 : 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                // Slightly off-white background for visibility
                color: const Color(0xFFFAFAFA),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isHovered
                      ? DesignConstants.primaryColor.withValues(alpha: 0.25)
                      : const Color(0xFFE5E5E5),
                  width: 1.5,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFFFBFBFB),
                    const Color(0xFFF5F5F5),
                  ],
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(20),
                  splashColor: DesignConstants.primaryColor.withValues(alpha: 0.08),
                  highlightColor: DesignConstants.primaryColor.withValues(alpha: 0.04),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Avatar with animated gradient ring
                        _buildAvatar(context),
                        const SizedBox(height: 16),

                        // Name
                        Text(
                          node.name,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            color: const Color(0xFF1A1A1A),
                            letterSpacing: -0.3,
                            height: 1.3,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        // Role/Type indicator (only for CEO and departments, not regular employees)
                        if (node.type == NodeType.ceo ||
                            node.type == NodeType.department ||
                            node.type == NodeType.team) ...[
                          const SizedBox(height: 4),
                          Text(
                            _getRoleLabel(node.type),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: DesignConstants.primaryColor.withValues(alpha: 0.7),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],

                        // Percentages - Elegant text-based display
                        if (employee != null &&
                            (employee.insurancePercentage != null ||
                                employee.realEstatePercentage != null)) ...[
                          const SizedBox(height: 16),
                          Column(
                            children: [
                              if (employee.insurancePercentage != null)
                                _buildElegantPercentageRow(
                                  'Versicherung',
                                  employee.insurancePercentage!,
                                  const Color(0xFF10274C),
                                ),
                              if (employee.insurancePercentage != null &&
                                  employee.realEstatePercentage != null)
                                const SizedBox(height: 8),
                              if (employee.realEstatePercentage != null)
                                _buildElegantPercentageRow(
                                  'Immobilien',
                                  employee.realEstatePercentage!,
                                  const Color(0xFF10274C),
                                ),
                            ],
                          ),
                        ],

                        // Contact info
                        if (employee?.email != null) ...[
                          const SizedBox(height: 12),
                          _buildContactRow(Icons.email_outlined, employee!.email!),
                        ],
                        if (employee?.phone != null) ...[
                          const SizedBox(height: 6),
                          _buildContactRow(Icons.phone_outlined, employee!.phone!),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context) {
    final size = 70.0;
    final employee = node.employee;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: size + 8,
      height: size + 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isHovered
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  DesignConstants.primaryColor.withValues(alpha: 0.6),
                  DesignConstants.primaryColor.withValues(alpha: 0.3),
                ],
              )
            : null,
      ),
      child: Center(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: node.type == NodeType.company
                ? BoxShape.rectangle
                : BoxShape.circle,
            borderRadius: node.type == NodeType.company
                ? BorderRadius.circular(16)
                : null,
            color: node.type == NodeType.company
                ? DesignConstants.primaryColor
                : null,
            boxShadow: [
              BoxShadow(
                color: DesignConstants.primaryColor.withValues(alpha: 0.2),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: node.type == NodeType.company
              ? const Icon(
                  Icons.business_outlined,
                  size: 36,
                  color: Colors.white,
                )
              : employee != null
                  ? (employee.imageUrl != null
                      ? ClipOval(
                          child: Image.network(
                            employee.imageUrl!,
                            width: size,
                            height: size,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _buildInitialsAvatar(employee, size),
                          ),
                        )
                      : _buildInitialsAvatar(employee, size))
                  : const Icon(
                      Icons.person_outline,
                      size: 36,
                      color: Colors.white,
                    ),
        ),
      ),
    );
  }

  Widget _buildInitialsAvatar(employee, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            DesignConstants.primaryColor,
            DesignConstants.primaryColor.withValues(alpha: 0.7),
          ],
        ),
      ),
      child: Center(
        child: Text(
          employee.initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  /// Elegant percentage display without icons - professional and clean
  Widget _buildElegantPercentageRow(
      String label, double percentage, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: color.withValues(alpha: 0.12),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: color.withValues(alpha: 0.85),
              fontSize: 13,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${percentage.toStringAsFixed(0)} %',
            style: TextStyle(
              color: color,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: DesignConstants.textSecondary.withValues(alpha: 0.7),
        ),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              color: DesignConstants.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w400,
              letterSpacing: 0.1,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _getRoleLabel(NodeType type) {
    switch (type) {
      case NodeType.ceo:
        return 'CEO';
      case NodeType.department:
        return 'Abteilung';
      case NodeType.team:
        return 'Team';
      case NodeType.employee:
        return 'Mitarbeiter';
      default:
        return '';
    }
  }
}
