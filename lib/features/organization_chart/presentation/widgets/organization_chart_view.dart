import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trialog/core/constants/design_constants.dart';
import 'package:trialog/features/organization_chart/domain/entities/organization_node.dart';
import 'package:trialog/features/organization_chart/presentation/widgets/hierarchical_node.dart';
import 'package:trialog/features/organization_chart/presentation/widgets/organization_node_card.dart';
import 'package:trialog/features/organization_chart/presentation/widgets/organization_connector_painter.dart';
import 'package:trialog/features/organization_chart/presentation/widgets/add_employee_dialog.dart';

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

  // Hover state for company card
  bool _isCompanyHovered = false;

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
              // Connector lines from company to employees (drawn behind)
              if (employees.isNotEmpty && _positionsMeasured && _companyBottomCenter != null)
                Positioned.fill(
                  child: CustomPaint(
                    painter: OrganizationConnectorPainter(
                      parentPosition: _companyBottomCenter!,
                      childrenPositions: _employeeTopCenters,
                      lineColor: DesignConstants.primaryColor.withValues(alpha: 0.4),
                      strokeWidth: 2.0,
                    ),
                  ),
                ),

              // Main content
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    'Trialog Organisationsstruktur',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: DesignConstants.primaryColor,
                          fontWeight: DesignConstants.fontWeightBold,
                        ),
                  ),
                  const SizedBox(height: DesignConstants.spacingXl),

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

    // Calculate company's bottom center in stack coordinates
    final companyLocalBottomCenter = Offset(
      companyBox.size.width / 2,
      companyBox.size.height,
    );
    final companyGlobalBottomCenter = companyBox.localToGlobal(companyLocalBottomCenter);
    final stackGlobalOrigin = stackBox.localToGlobal(Offset.zero);

    final companyPositionInStack = Offset(
      companyGlobalBottomCenter.dx - stackGlobalOrigin.dx,
      companyGlobalBottomCenter.dy - stackGlobalOrigin.dy,
    );

    // Get employee positions (top center) in stack coordinates
    final List<Offset> employeePositions = [];
    for (final employeeKey in _topLevelEmployeeKeys) {
      final employeeBox = employeeKey.currentContext?.findRenderObject() as RenderBox?;
      if (employeeBox == null || !employeeBox.hasSize) {
        // Some employees not ready yet, retry in next frame
        SchedulerBinding.instance.addPostFrameCallback((_) => _measurePositions());
        return;
      }

      // Calculate employee's top center in stack coordinates
      final employeeLocalTopCenter = Offset(
        employeeBox.size.width / 2,
        0,
      );
      final employeeGlobalTopCenter = employeeBox.localToGlobal(employeeLocalTopCenter);

      final employeePositionInStack = Offset(
        employeeGlobalTopCenter.dx - stackGlobalOrigin.dx,
        employeeGlobalTopCenter.dy - stackGlobalOrigin.dy,
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
        MouseRegion(
          onEnter: (_) => setState(() => _isCompanyHovered = true),
          onExit: (_) => setState(() => _isCompanyHovered = false),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                key: _companyCardKey,
                child: OrganizationNodeCard(node: widget.rootNode, onTap: () {}),
              ),
              // Add employee button (top right)
              if (_isCompanyHovered)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: DesignConstants.successColor,
                      borderRadius: BorderRadius.circular(DesignConstants.borderRadiusRound),
                      boxShadow: DesignConstants.shadowSm,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.person_add, size: 16, color: Colors.white),
                      onPressed: () => _showAddEmployeeDialog(context, widget.rootNode.id),
                      tooltip: 'Mitarbeiter unter Trialog hinzufügen',
                      padding: const EdgeInsets.all(4),
                      constraints: const BoxConstraints(
                        minWidth: 28,
                        minHeight: 28,
                      ),
                    ),
                  ),
                ),
            ],
          ),
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
