import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trialog/core/constants/design_constants.dart';
import 'package:trialog/features/organization_chart/domain/entities/organization_node.dart';
import 'package:trialog/features/organization_chart/presentation/widgets/hierarchical_node.dart';
import 'package:trialog/features/organization_chart/presentation/widgets/organization_node_card.dart';
import 'package:trialog/features/organization_chart/presentation/widgets/connector_layer.dart';
import 'package:trialog/features/organization_chart/presentation/widgets/add_employee_dialog.dart';
import 'package:trialog/features/organization_chart/presentation/widgets/hover_action_overlay.dart';

/// Organization chart view with elegant curved connectors
class OrganizationChartView extends ConsumerStatefulWidget {
  final OrganizationNode rootNode;

  const OrganizationChartView({
    super.key,
    required this.rootNode,
  });

  @override
  ConsumerState<OrganizationChartView> createState() => _OrganizationChartViewState();
}

class _OrganizationChartViewState extends ConsumerState<OrganizationChartView> {
  final GlobalKey _stackKey = GlobalKey();
  final GlobalKey _companyCardKey = GlobalKey();
  final List<GlobalKey> _topLevelEmployeeKeys = [];

  // Measured positions for connector lines
  Offset? _companyBottomCenter;
  final List<Offset> _employeeTopCenters = [];
  bool _positionsMeasured = false;

  @override
  void initState() {
    super.initState();
    _initializeEmployeeKeys();
  }

  @override
  void didUpdateWidget(OrganizationChartView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newEmployeeCount = widget.rootNode.children
        .where((child) => child.type != NodeType.ceo)
        .length;
    final oldEmployeeCount = oldWidget.rootNode.children
        .where((child) => child.type != NodeType.ceo)
        .length;

    // Re-initialize keys if employee count changed
    if (newEmployeeCount != oldEmployeeCount) {
      _initializeEmployeeKeys();
    }

    // ALWAYS reset position measurement when widget updates
    // This ensures lines are redrawn after add/remove operations
    _positionsMeasured = false;
  }

  void _initializeEmployeeKeys() {
    final employeeCount = widget.rootNode.children
        .where((child) => child.type != NodeType.ceo)
        .length;

    _topLevelEmployeeKeys.clear();
    for (int i = 0; i < employeeCount; i++) {
      _topLevelEmployeeKeys.add(GlobalKey());
    }
  }

  @override
  Widget build(BuildContext context) {
    final employees = widget.rootNode.children
        .where((child) => child.type != NodeType.ceo)
        .toList();

    // Measure positions after layout
    if (employees.isNotEmpty && !_positionsMeasured) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _measurePositions();
      });
    }

    return InteractiveViewer(
      boundaryMargin: const EdgeInsets.all(double.infinity),
      minScale: 0.5,
      maxScale: 2.0,
      scaleFactor: 500.0, // Sehr feine Zoom-Schritte (Standard: 200.0, höher = feiner)
      constrained: false,
      child: Padding(
        padding: const EdgeInsets.all(DesignConstants.spacingXl),
        child: Center(
          child: Stack(
            key: _stackKey,
            clipBehavior: Clip.none,
            children: [
              // Connector lines from company to employees (drawn behind) - isolated widget for optimal performance
              if (employees.isNotEmpty && _positionsMeasured && _companyBottomCenter != null)
                Positioned.fill(
                  child: ConnectorLayer(
                    parentPosition: _companyBottomCenter!,
                    childrenPositions: _employeeTopCenters,
                  ),
                ),

              // Main content
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Top level: CEOs and Company horizontal
                  _buildTopLevel(context),

                  // Employees under Trialog
                  _buildEmployeesUnderTrialog(context, employees),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Measures positions of company card and top-level employees for connector lines
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

    // Get company card position (bottom center)
    final companyBox = _companyCardKey.currentContext?.findRenderObject() as RenderBox?;
    if (companyBox == null || !companyBox.hasSize) {
      // Company card not ready, retry in next frame
      SchedulerBinding.instance.addPostFrameCallback((_) => _measurePositions());
      return;
    }

    // Calculate company's bottom center relative to stack (handles zoom/pan correctly)
    final companyLocalBottomCenter = Offset(
      companyBox.size.width / 2,
      companyBox.size.height,
    );

    // Use localToGlobal with ancestor parameter to properly handle InteractiveViewer
    final companyPositionInStack = companyBox.localToGlobal(
      companyLocalBottomCenter,
      ancestor: stackBox,
    );

    // Get employee positions (top center) relative to stack
    final List<Offset> employeePositions = [];
    for (final employeeKey in _topLevelEmployeeKeys) {
      final employeeBox = employeeKey.currentContext?.findRenderObject() as RenderBox?;
      if (employeeBox == null || !employeeBox.hasSize) {
        // Some employees not ready yet, retry in next frame
        SchedulerBinding.instance.addPostFrameCallback((_) => _measurePositions());
        return;
      }

      // Calculate employee's top center relative to stack (handles zoom/pan correctly)
      final employeeLocalTopCenter = Offset(
        employeeBox.size.width / 2,
        0,
      );

      // Use localToGlobal with ancestor parameter for proper coordinate conversion
      final employeePositionInStack = employeeBox.localToGlobal(
        employeeLocalTopCenter,
        ancestor: stackBox,
      );

      employeePositions.add(employeePositionInStack);
    }

    // Update state with measured positions (all relative to stack)
    if (employeePositions.isNotEmpty && mounted) {
      setState(() {
        _companyBottomCenter = companyPositionInStack;
        _employeeTopCenters.clear();
        _employeeTopCenters.addAll(employeePositions);
        _positionsMeasured = true;
      });
    }
  }

  Widget _buildTopLevel(BuildContext context) {
    final ceos = widget.rootNode.children
        .where((child) => child.type == NodeType.ceo)
        .toList();

    final leftCeo = ceos.isNotEmpty ? ceos[0] : null;
    final rightCeo = ceos.length > 1 ? ceos[1] : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left CEO (Marcel Liebetrau)
        if (leftCeo != null) ...[
          HierarchicalNode(node: leftCeo, showDeleteButton: false),
          const SizedBox(width: DesignConstants.spacingMd),
          Container(
            width: 60,
            height: 2,
            color: DesignConstants.primaryColor.withValues(alpha: 0.5),
          ),
          const SizedBox(width: DesignConstants.spacingMd),
        ],

        // Center: Trialog Company (with key for position measurement and add button)
        HoverActionOverlay(
          childBuilder: (isHovered) => Container(
            key: _companyCardKey,
            child: OrganizationNodeCard(
              node: widget.rootNode,
              onTap: () {},
              isHovered: isHovered,
            ),
          ),
          actions: [
            HoverAction(
              icon: Icons.person_add,
              tooltip: 'Mitarbeiter unter Trialog hinzufügen',
              color: DesignConstants.successColor,
              onPressed: () => _showAddEmployeeDialog(context, widget.rootNode.id),
            ),
          ],
        ),

        // Right CEO (Daniel Lippert)
        if (rightCeo != null) ...[
          const SizedBox(width: DesignConstants.spacingMd),
          Container(
            width: 60,
            height: 2,
            color: DesignConstants.primaryColor.withValues(alpha: 0.5),
          ),
          const SizedBox(width: DesignConstants.spacingMd),
          HierarchicalNode(node: rightCeo, showDeleteButton: false),
        ],
      ],
    );
  }

  Widget _buildEmployeesUnderTrialog(BuildContext context, List<OrganizationNode> employees) {
    if (employees.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: 80), // Space for curved connectors

        // Employees with hierarchy (no static lines, connectors drawn by CustomPaint)
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(employees.length, (index) {
            final employee = employees[index];
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DesignConstants.spacingMd,
              ),
              child: Container(
                key: _topLevelEmployeeKeys[index],
                child: HierarchicalNode(node: employee),
              ),
            );
          }),
        ),
      ],
    );
  }

  void _showAddEmployeeDialog(BuildContext context, String parentId) {
    showDialog(
      context: context,
      builder: (context) => AddEmployeeDialog(parentId: parentId),
    );
  }
}
