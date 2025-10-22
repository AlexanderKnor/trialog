import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trialog/core/constants/design_constants.dart';
import 'package:trialog/features/organization_chart/domain/entities/organization_node.dart';
import 'package:trialog/features/organization_chart/presentation/state/organization_chart_providers.dart';
import 'package:trialog/features/organization_chart/presentation/widgets/add_employee_dialog.dart';
import 'package:trialog/features/organization_chart/presentation/widgets/organization_node_card.dart';

/// Hierarchical node that can have children below it
class HierarchicalNode extends ConsumerStatefulWidget {
  final OrganizationNode node;
  final bool showDeleteButton;

  const HierarchicalNode({
    super.key,
    required this.node,
    this.showDeleteButton = true,
  });

  @override
  ConsumerState<HierarchicalNode> createState() => _HierarchicalNodeState();
}

class _HierarchicalNodeState extends ConsumerState<HierarchicalNode> {
  bool _isHovered = false;
  final GlobalKey _cardKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final children = widget.node.children;
    final hasChildren = children.isNotEmpty;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // The node card with hover actions
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Card with key for position measurement
              Container(
                key: _cardKey,
                child: OrganizationNodeCard(
                  node: widget.node,
                  onTap: () => _showNodeDetails(context),
                ),
              ),

              // Children count badge
              if (hasChildren)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: DesignConstants.successColor,
                      borderRadius: BorderRadius.circular(
                        DesignConstants.borderRadiusRound,
                      ),
                    ),
                    child: Text(
                      '${children.length}',
                      style: const TextStyle(
                        color: DesignConstants.textOnPrimary,
                        fontSize: 10,
                        fontWeight: DesignConstants.fontWeightBold,
                      ),
                    ),
                  ),
                ),

              // Hover actions
              if (_isHovered)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Add employee button
                      _buildActionButton(
                        icon: Icons.person_add,
                        tooltip: 'Mitarbeiter hinzufügen',
                        color: DesignConstants.successColor,
                        onPressed: () => _showAddEmployeeDialog(context),
                      ),
                      // Delete button
                      if (widget.showDeleteButton) ...[
                        const SizedBox(width: 4),
                        _buildActionButton(
                          icon: Icons.delete_outline,
                          tooltip: 'Löschen',
                          color: DesignConstants.errorColor,
                          onPressed: () => _confirmDelete(context),
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ),

        // Children below (if any)
        if (hasChildren) ...[
          const SizedBox(height: DesignConstants.spacingMd),

          // Vertical line down from parent
          Container(
            width: 2,
            height: 30,
            color: DesignConstants.primaryColor.withValues(alpha: 0.3),
          ),

          // Horizontal connector (only if multiple children)
          if (children.length > 1)
            Container(
              width: (children.length - 1) * 216,
              height: 2,
              color: DesignConstants.primaryColor.withValues(alpha: 0.3),
            ),

          // Children in horizontal row with scroll
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children.map((child) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DesignConstants.spacingSm,
                    ),
                    child: Column(
                      children: [
                        // Vertical line to child
                        Container(
                          width: 2,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                DesignConstants.primaryColor.withValues(alpha: 0.2),
                                DesignConstants.primaryColor.withValues(alpha: 0.4),
                              ],
                            ),
                          ),
                        ),
                        // Recursive child (no width constraint!)
                        HierarchicalNode(node: child),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String tooltip,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(DesignConstants.borderRadiusRound),
        boxShadow: DesignConstants.shadowSm,
      ),
      child: IconButton(
        icon: Icon(icon, size: 16, color: Colors.white),
        onPressed: onPressed,
        tooltip: tooltip,
        padding: const EdgeInsets.all(4),
        constraints: const BoxConstraints(
          minWidth: 28,
          minHeight: 28,
        ),
      ),
    );
  }

  void _showAddEmployeeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddEmployeeDialog(parentId: widget.node.id),
    );
  }

  void _confirmDelete(BuildContext context) {
    final totalChildren = _countAllChildren(widget.node);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mitarbeiter entfernen'),
        content: Text(
          totalChildren > 0
              ? 'Möchten Sie ${widget.node.name} und alle $totalChildren untergeordneten Mitarbeiter wirklich entfernen?'
              : 'Möchten Sie ${widget.node.name} wirklich entfernen?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final success = await ref
                  .read(organizationChartProvider.notifier)
                  .removeEmployee(widget.node.id);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      success
                          ? 'Mitarbeiter erfolgreich entfernt'
                          : 'Fehler beim Entfernen',
                    ),
                    backgroundColor: success
                        ? DesignConstants.successColor
                        : DesignConstants.errorColor,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: DesignConstants.errorColor,
            ),
            child: const Text('Entfernen'),
          ),
        ],
      ),
    );
  }

  void _showNodeDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.node.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.node.employee != null) ...[
              if (widget.node.employee!.email != null)
                Text('Email: ${widget.node.employee!.email}'),
              if (widget.node.employee!.phone != null)
                Text('Telefon: ${widget.node.employee!.phone}'),
              if (widget.node.employee!.insurancePercentage != null)
                Text('Versicherung: ${widget.node.employee!.insurancePercentage}%'),
              if (widget.node.employee!.realEstatePercentage != null)
                Text('Immobilien: ${widget.node.employee!.realEstatePercentage}%'),
            ],
            if (widget.node.children.isNotEmpty)
              Text('Direkte Mitarbeiter: ${widget.node.children.length}'),
            Text('Gesamt im Team: ${_countAllChildren(widget.node)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Schließen'),
          ),
        ],
      ),
    );
  }

  int _countAllChildren(OrganizationNode node) {
    int count = node.children.length;
    for (var child in node.children) {
      count += _countAllChildren(child);
    }
    return count;
  }
}



