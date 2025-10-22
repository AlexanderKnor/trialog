import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trialog/core/constants/design_constants.dart';
import 'package:trialog/features/organization_chart/domain/entities/organization_node.dart';
import 'package:trialog/features/organization_chart/presentation/state/organization_chart_providers.dart';
import 'package:trialog/features/organization_chart/presentation/widgets/add_employee_dialog.dart';
import 'package:trialog/features/organization_chart/presentation/widgets/organization_node_card.dart';
import 'package:trialog/features/organization_chart/presentation/widgets/connector_layer.dart';
import 'package:trialog/features/organization_chart/presentation/widgets/hover_action_overlay.dart';

/// Hierarchical node that can have children below it with elegant curved connectors
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
  final GlobalKey _stackKey = GlobalKey();
  final GlobalKey _cardKey = GlobalKey();
  final List<GlobalKey> _childKeys = [];

  // Measured positions for connector lines
  Offset? _parentBottomCenter;
  final List<Offset> _childTopCenters = [];
  bool _positionsMeasured = false;

  @override
  void initState() {
    super.initState();
    _initializeChildKeys();
  }

  @override
  void didUpdateWidget(HierarchicalNode oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Re-initialize keys if children count changed
    if (widget.node.children.length != oldWidget.node.children.length) {
      _initializeChildKeys();
    }

    // ALWAYS reset position measurement when widget updates
    // This ensures lines are redrawn after add/remove operations
    _positionsMeasured = false;
  }

  void _initializeChildKeys() {
    _childKeys.clear();
    for (int i = 0; i < widget.node.children.length; i++) {
      _childKeys.add(GlobalKey());
    }
  }

  @override
  Widget build(BuildContext context) {
    final children = widget.node.children;
    final hasChildren = children.isNotEmpty;

    // Measure positions after layout
    if (hasChildren && !_positionsMeasured) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _measurePositions();
      });
    }

    return Stack(
      key: _stackKey,
      clipBehavior: Clip.none,
      children: [
        // Connector lines (drawn behind everything) - isolated widget for optimal performance
        if (hasChildren && _positionsMeasured && _parentBottomCenter != null)
          Positioned.fill(
            child: ConnectorLayer(
              parentPosition: _parentBottomCenter!,
              childrenPositions: _childTopCenters,
            ),
          ),

        // The actual node hierarchy
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
                // The node card with hover actions (isolated to prevent rebuilds)
                HoverActionOverlay(
                  actions: [
                    HoverAction(
                      icon: Icons.person_add,
                      tooltip: 'Mitarbeiter hinzufügen',
                      color: DesignConstants.successColor,
                      onPressed: () => _showAddEmployeeDialog(context),
                    ),
                    if (widget.showDeleteButton)
                      HoverAction(
                        icon: Icons.delete_outline,
                        tooltip: 'Löschen',
                        color: DesignConstants.errorColor,
                        onPressed: () => _confirmDelete(context),
                      ),
                  ],
                  topLeftWidget: hasChildren
                      ? Container(
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
                        )
                      : null,
                  child: Container(
                    key: _cardKey,
                    child: OrganizationNodeCard(
                      node: widget.node,
                      onTap: () => _showNodeDetails(context),
                    ),
                  ),
                ),

                // Children below (if any)
                if (hasChildren) ...[
                  const SizedBox(height: 60), // Space for curved connectors

                  // Children in horizontal row
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(children.length, (index) {
                      final child = children[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: DesignConstants.spacingMd,
                        ),
                        child: Container(
                          key: _childKeys[index],
                          child: HierarchicalNode(node: child),
                        ),
                      );
                    }),
                  ),
                ],
              ],
            ),
          ],
        );
  }

  /// Measures positions of parent and children for connector lines
  /// Uses localToAncestor to properly handle InteractiveViewer transformations
  void _measurePositions() {
    if (!mounted) return;

    // Get the stack's render box (our coordinate reference)
    final stackBox = _stackKey.currentContext?.findRenderObject() as RenderBox?;
    if (stackBox == null || !stackBox.hasSize) {
      // Stack not ready, retry in next frame
      SchedulerBinding.instance.addPostFrameCallback((_) => _measurePositions());
      return;
    }

    // Get parent card position (bottom center)
    final parentBox = _cardKey.currentContext?.findRenderObject() as RenderBox?;
    if (parentBox == null || !parentBox.hasSize) {
      // Parent not ready, retry in next frame
      SchedulerBinding.instance.addPostFrameCallback((_) => _measurePositions());
      return;
    }

    // Calculate parent's bottom center relative to stack (handles zoom/pan correctly)
    final parentLocalBottomCenter = Offset(
      parentBox.size.width / 2,
      parentBox.size.height,
    );

    // Use localToGlobal with ancestor parameter to properly handle InteractiveViewer
    final parentPositionInStack = parentBox.localToGlobal(
      parentLocalBottomCenter,
      ancestor: stackBox,
    );

    // Get children positions (top center) relative to stack
    final List<Offset> childPositions = [];
    for (final childKey in _childKeys) {
      final childBox = childKey.currentContext?.findRenderObject() as RenderBox?;
      if (childBox == null || !childBox.hasSize) {
        // Some children not ready yet, retry in next frame
        SchedulerBinding.instance.addPostFrameCallback((_) => _measurePositions());
        return;
      }

      // Calculate child's top center relative to stack (handles zoom/pan correctly)
      final childLocalTopCenter = Offset(
        childBox.size.width / 2,
        0,
      );

      // Use localToGlobal with ancestor parameter for proper coordinate conversion
      final childPositionInStack = childBox.localToGlobal(
        childLocalTopCenter,
        ancestor: stackBox,
      );

      childPositions.add(childPositionInStack);
    }

    // Update state with measured positions (all relative to stack)
    if (childPositions.isNotEmpty && mounted) {
      setState(() {
        _parentBottomCenter = parentPositionInStack;
        _childTopCenters.clear();
        _childTopCenters.addAll(childPositions);
        _positionsMeasured = true;
      });
    }
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



