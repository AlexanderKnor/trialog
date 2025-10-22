import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trialog/core/utils/logger.dart';
import 'package:trialog/features/organization_chart/domain/entities/employee.dart';
import 'package:trialog/features/organization_chart/domain/entities/organization_node.dart';
import 'package:trialog/features/organization_chart/domain/use_cases/add_employee.dart';
import 'package:trialog/features/organization_chart/domain/use_cases/get_organization_chart.dart';
import 'package:trialog/features/organization_chart/domain/use_cases/remove_employee.dart';
import 'package:trialog/features/organization_chart/presentation/state/organization_chart_state.dart';

/// Organization chart state notifier
class OrganizationChartNotifier extends StateNotifier<OrganizationChartState> {
  final GetOrganizationChart _getOrganizationChart;
  final AddEmployee _addEmployee;
  final RemoveEmployee _removeEmployee;

  OrganizationChartNotifier(
    this._getOrganizationChart,
    this._addEmployee,
    this._removeEmployee,
  ) : super(OrganizationChartState.initial());

  /// Load organization chart
  Future<void> loadOrganizationChart() async {
    state = state.copyWithLoading();

    Logger.info('Loading organization chart', tag: 'OrganizationChart');

    final result = await _getOrganizationChart();

    result.fold(
      (failure) {
        Logger.error(
          'Failed to load organization chart',
          tag: 'OrganizationChart',
          error: failure.message,
        );
        state = state.copyWithError(failure.message);
      },
      (rootNode) {
        Logger.info(
          'Organization chart loaded successfully',
          tag: 'OrganizationChart',
        );
        state = state.copyWithSuccess(rootNode);
      },
    );
  }

  /// Refresh organization chart
  Future<void> refresh() async {
    await loadOrganizationChart();
  }

  /// Add new employee
  Future<bool> addEmployee({
    required String parentId,
    required Employee employee,
    required NodeType nodeType,
  }) async {
    Logger.info('Adding employee: ${employee.fullName}', tag: 'OrganizationChart');

    final result = await _addEmployee(
      parentId: parentId,
      employee: employee,
      nodeType: nodeType,
    );

    return result.fold(
      (failure) {
        Logger.error(
          'Failed to add employee',
          tag: 'OrganizationChart',
          error: failure.message,
        );
        state = state.copyWithError(failure.message);
        return false;
      },
      (updatedRootNode) {
        Logger.info(
          'Employee added successfully',
          tag: 'OrganizationChart',
        );
        state = state.copyWithSuccess(updatedRootNode);
        return true;
      },
    );
  }

  /// Remove employee
  Future<bool> removeEmployee(String nodeId) async {
    Logger.info('Removing employee node: $nodeId', tag: 'OrganizationChart');

    final result = await _removeEmployee(nodeId);

    return result.fold(
      (failure) {
        Logger.error(
          'Failed to remove employee',
          tag: 'OrganizationChart',
          error: failure.message,
        );
        state = state.copyWithError(failure.message);
        return false;
      },
      (updatedRootNode) {
        Logger.info(
          'Employee removed successfully',
          tag: 'OrganizationChart',
        );
        state = state.copyWithSuccess(updatedRootNode);
        return true;
      },
    );
  }
}
