import 'package:dartz/dartz.dart';
import 'package:trialog/features/organization_chart/domain/entities/employee.dart';
import 'package:trialog/features/organization_chart/domain/entities/organization_node.dart';
import 'package:trialog/features/organization_chart/domain/repositories/organization_chart_repository.dart';
import 'package:trialog/shared/models/result.dart';

/// Use case for adding a new employee to the organization
class AddEmployee {
  final OrganizationChartRepository repository;

  const AddEmployee(this.repository);

  /// Execute the use case
  /// [parentId] is the ID of the parent node (e.g., "company-root" for Trialog)
  /// [employee] is the employee to add
  /// [position] is the job position/title
  Future<Result<OrganizationNode>> call({
    required String parentId,
    required Employee employee,
    required NodeType nodeType,
  }) async {
    // Create new organization node for the employee
    final newNode = OrganizationNode(
      id: 'emp-${DateTime.now().millisecondsSinceEpoch}',
      name: employee.fullName,
      type: nodeType,
      employee: employee,
      parentId: parentId,
      level: 1, // Under company root
    );

    // Get current organization chart
    final chartResult = await repository.getOrganizationChart();

    return chartResult.fold(
      (failure) => chartResult,
      (rootNode) async {
        // Add new node to the parent
        final updatedRoot = _addNodeToParent(rootNode, parentId, newNode);

        // Update organization chart
        final updateResult = await repository.updateOrganizationChart(updatedRoot);

        return updateResult.fold(
          (failure) => Left(failure),
          (_) async => await repository.getOrganizationChart(),
        );
      },
    );
  }

  /// Recursively find parent and add new node
  OrganizationNode _addNodeToParent(
    OrganizationNode current,
    String parentId,
    OrganizationNode newNode,
  ) {
    if (current.id == parentId) {
      // Found parent, add new node to children
      return current.copyWith(
        children: [...current.children, newNode],
      );
    }

    // Recursively search in children
    final updatedChildren = current.children.map((child) {
      return _addNodeToParent(child, parentId, newNode);
    }).toList();

    return current.copyWith(children: updatedChildren);
  }
}
