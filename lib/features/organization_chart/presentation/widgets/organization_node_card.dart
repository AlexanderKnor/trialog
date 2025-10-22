import 'package:flutter/material.dart';
import 'package:trialog/core/constants/design_constants.dart';
import 'package:trialog/features/organization_chart/domain/entities/organization_node.dart';

/// Premium luxury organization card - high-end, elegant, with depth and dimension
/// Designed for maximum visual impact and professional presentation
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

    return Container(
      width: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        // Apple-like multi-layer shadows for premium depth
        boxShadow: [
          // Primary shadow - soft depth
          BoxShadow(
            color: Colors.black.withValues(alpha: isHovered ? 0.12 : 0.08),
            blurRadius: isHovered ? 24 : 20,
            offset: Offset(0, isHovered ? 8 : 6),
            spreadRadius: 0,
          ),
          // Secondary shadow - ambient softness
          BoxShadow(
            color: Colors.black.withValues(alpha: isHovered ? 0.08 : 0.05),
            blurRadius: isHovered ? 12 : 10,
            offset: Offset(0, isHovered ? 4 : 3),
            spreadRadius: -1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            // Subtle premium gradient like Apple cards
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFFFFF),
                Color(0xFFFCFCFC),
                Color(0xFFF8F8F8),
              ],
              stops: [0.0, 0.5, 1.0],
            ),
            border: Border.all(
              color: const Color(0xFFE5E5E7),
              width: 0.5,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(20),
              splashColor: DesignConstants.primaryColor.withValues(alpha: 0.04),
              highlightColor: DesignConstants.primaryColor.withValues(alpha: 0.02),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isHovered
                        ? DesignConstants.primaryColor.withValues(alpha: 0.15)
                        : Colors.transparent,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    // Avatar - premium design
                    _buildAvatar(context),
                    const SizedBox(height: 20),

                    // Name - Apple-like typography
                    Text(
                      node.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: const Color(0xFF1C1C1E),
                        letterSpacing: -0.3,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Role/Type indicator (only for CEO and departments)
                    if (node.type == NodeType.ceo ||
                        node.type == NodeType.department ||
                        node.type == NodeType.team) ...[
                      const SizedBox(height: 8),
                      Text(
                        _getRoleLabel(node.type),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF8E8E93),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -0.1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],

                    // Percentages - Premium Apple-style
                    if (employee != null &&
                        (employee.insurancePercentage != null ||
                            employee.realEstatePercentage != null)) ...[
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF9F9F9),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: const Color(0xFFE8E8E8),
                            width: 0.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            if (employee.insurancePercentage != null)
                              _buildSubtlePercentageRow(
                                'Versicherung',
                                employee.insurancePercentage!,
                              ),
                            if (employee.insurancePercentage != null &&
                                employee.realEstatePercentage != null)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Divider(
                                  height: 1,
                                  thickness: 0.5,
                                  color: Color(0xFFE8E8E8),
                                ),
                              ),
                            if (employee.realEstatePercentage != null)
                              _buildSubtlePercentageRow(
                                'Immobilien',
                                employee.realEstatePercentage!,
                              ),
                          ],
                        ),
                      ),
                    ],

                    // Contact info - subtle and minimal
                    if (employee?.email != null || employee?.phone != null) ...[
                      const SizedBox(height: 16),
                      Column(
                        children: [
                          if (employee?.email != null)
                            _buildContactRow(
                              Icons.mail_outline,
                              employee!.email!,
                            ),
                          if (employee?.email != null && employee?.phone != null)
                            const SizedBox(height: 8),
                          if (employee?.phone != null)
                            _buildContactRow(
                              Icons.phone_outlined,
                              employee!.phone!,
                            ),
                        ],
                      ),
                    ],
                  ],
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
    final size = 92.0;
    final employee = node.employee;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: node.type == NodeType.company ? BoxShape.rectangle : BoxShape.circle,
        borderRadius: node.type == NodeType.company ? BorderRadius.circular(22) : null,
        boxShadow: [
          // Apple-like avatar shadow
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: node.type == NodeType.company
            ? BorderRadius.circular(20)
            : BorderRadius.circular(size / 2),
        child: Container(
          decoration: BoxDecoration(
            color: node.type == NodeType.company
                ? DesignConstants.primaryColor
                : null,
          ),
          child: node.type == NodeType.company
              ? const Icon(
                  Icons.business_rounded,
                  size: 40,
                  color: Colors.white,
                )
              : employee != null
                  ? (employee.imageUrl != null
                      ? Image.network(
                          employee.imageUrl!,
                          width: size,
                          height: size,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              _buildInitialsAvatar(employee, size),
                        )
                      : _buildInitialsAvatar(employee, size))
                  : _buildInitialsAvatar(null, size),
        ),
      ),
    );
  }

  Widget _buildInitialsAvatar(employee, double size) {
    final initials = employee?.initials ?? '?';

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
            DesignConstants.primaryColor.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
      ),
    );
  }

  /// Apple-style percentage row - premium and refined
  Widget _buildSubtlePercentageRow(String label, double percentage) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF3C3C43),
            fontSize: 15,
            fontWeight: FontWeight.w500,
            letterSpacing: -0.2,
          ),
        ),
        Text(
          '${percentage.toStringAsFixed(0)} %',
          style: TextStyle(
            color: DesignConstants.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.1,
          ),
        ),
      ],
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 15,
          color: const Color(0xFF8E8E93),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFF8E8E93),
              fontSize: 13,
              fontWeight: FontWeight.w400,
              letterSpacing: -0.1,
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
        return 'Geschäftsführer';
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
