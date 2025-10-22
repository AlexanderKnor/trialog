import 'package:equatable/equatable.dart';
import 'package:trialog/features/organization_chart/domain/entities/organization_node.dart';

/// Organization chart state
class OrganizationChartState extends Equatable {
  final OrganizationNode? rootNode;
  final bool isLoading;
  final String? error;

  const OrganizationChartState({
    this.rootNode,
    this.isLoading = false,
    this.error,
  });

  /// Initial state
  factory OrganizationChartState.initial() {
    return const OrganizationChartState(isLoading: true);
  }

  /// Loading state
  OrganizationChartState copyWithLoading() {
    return const OrganizationChartState(isLoading: true);
  }

  /// Success state
  OrganizationChartState copyWithSuccess(OrganizationNode rootNode) {
    return OrganizationChartState(
      rootNode: rootNode,
      isLoading: false,
    );
  }

  /// Error state
  OrganizationChartState copyWithError(String error) {
    return OrganizationChartState(
      error: error,
      isLoading: false,
    );
  }

  @override
  List<Object?> get props => [rootNode, isLoading, error];
}
