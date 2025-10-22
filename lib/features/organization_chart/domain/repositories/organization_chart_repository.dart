import 'package:trialog/features/organization_chart/domain/entities/organization_node.dart';
import 'package:trialog/shared/models/result.dart';

/// Repository interface for organization chart data
abstract class OrganizationChartRepository {
  /// Get the complete organization chart structure
  Future<Result<OrganizationNode>> getOrganizationChart();

  /// Get a specific node by ID
  Future<Result<OrganizationNode>> getNodeById(String nodeId);

  /// Update organization chart structure
  Future<Result<void>> updateOrganizationChart(OrganizationNode rootNode);
}
