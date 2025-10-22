import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trialog/core/constants/design_constants.dart';
import 'package:trialog/features/organization_chart/domain/entities/organization_node.dart';
import 'package:trialog/features/organization_chart/presentation/widgets/hierarchical_node.dart';
import 'package:trialog/features/organization_chart/presentation/widgets/organization_node_card.dart';

/// Organization chart view
class OrganizationChartView extends ConsumerWidget {
  final OrganizationNode rootNode;

  const OrganizationChartView({
    super.key,
    required this.rootNode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(DesignConstants.spacingXl),
      child: Center(
        child: Column(
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
            _buildTopLevel(context, ref),

            // Employees under Trialog
            _buildEmployeesUnderTrialog(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildTopLevel(BuildContext context, WidgetRef ref) {
    final ceos = rootNode.children
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

        // Center: Trialog Company
        OrganizationNodeCard(node: rootNode, onTap: () {}),

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

  Widget _buildEmployeesUnderTrialog(BuildContext context, WidgetRef ref) {
    final employees = rootNode.children
        .where((child) => child.type != NodeType.ceo)
        .toList();

    if (employees.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        const SizedBox(height: DesignConstants.spacingXl),

        // Vertical line from Trialog
        Container(
          width: 2,
          height: 40,
          color: DesignConstants.primaryColor.withValues(alpha: 0.3),
        ),

        // Employees with hierarchy
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: employees.map((employee) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: DesignConstants.spacingSm,
                ),
                child: Column(
                  children: [
                    // Vertical line to employee
                    Container(
                      width: 2,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            DesignConstants.primaryColor.withValues(alpha: 0.1),
                            DesignConstants.primaryColor.withValues(alpha: 0.3),
                          ],
                        ),
                      ),
                    ),
                    // Employee with recursive children
                    HierarchicalNode(node: employee),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
