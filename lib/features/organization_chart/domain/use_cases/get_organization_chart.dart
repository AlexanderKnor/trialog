import 'package:trialog/features/organization_chart/domain/entities/organization_node.dart';
import 'package:trialog/features/organization_chart/domain/repositories/organization_chart_repository.dart';
import 'package:trialog/shared/models/result.dart';

/// Use case for retrieving the organization chart
class GetOrganizationChart {
  final OrganizationChartRepository repository;

  const GetOrganizationChart(this.repository);

  /// Execute the use case
  Future<Result<OrganizationNode>> call() async {
    return await repository.getOrganizationChart();
  }
}
