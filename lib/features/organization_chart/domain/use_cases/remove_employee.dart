import 'package:dartz/dartz.dart';
import 'package:trialog/features/organization_chart/domain/entities/organization_node.dart';
import 'package:trialog/features/organization_chart/domain/repositories/organization_chart_repository.dart';
import 'package:trialog/shared/models/result.dart';

/// Use case for removing an employee from the organization
class RemoveEmployee {
  final OrganizationChartRepository repository;

  const RemoveEmployee(this.repository);

  /// Execute the use case
  /// [nodeId] is the ID of the node to remove
  Future<Result<OrganizationNode>> call(String nodeId) async {
    // Get current organization chart
    final chartResult = await repository.getOrganizationChart();

    return chartResult.fold(
      (failure) => chartResult,
      (rootNode) async {
        // Remove node from tree
        final updatedRoot = _removeNode(rootNode, nodeId);

        // Update organization chart
        final updateResult = await repository.updateOrganizationChart(updatedRoot);

        return updateResult.fold(
          (failure) => Left(failure),
          (_) async => await repository.getOrganizationChart(),
        );
      },
    );
  }

  /// Recursively find and remove node
  OrganizationNode _removeNode(OrganizationNode current, String nodeId) {
    // Filter out the node to remove from children
    final filteredChildren = current.children
        .where((child) => child.id != nodeId)
        .map((child) => _removeNode(child, nodeId))
        .toList();

    return current.copyWith(children: filteredChildren);
  }
}
