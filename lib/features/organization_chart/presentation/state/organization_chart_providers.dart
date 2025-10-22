import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trialog/features/organization_chart/data/data_sources/organization_chart_firestore_data_source.dart';
import 'package:trialog/features/organization_chart/data/repositories/organization_chart_repository_impl.dart';
import 'package:trialog/features/organization_chart/domain/repositories/organization_chart_repository.dart';
import 'package:trialog/features/organization_chart/domain/use_cases/add_employee.dart';
import 'package:trialog/features/organization_chart/domain/use_cases/get_organization_chart.dart';
import 'package:trialog/features/organization_chart/domain/use_cases/remove_employee.dart';
import 'package:trialog/features/organization_chart/presentation/state/organization_chart_notifier.dart';
import 'package:trialog/features/organization_chart/presentation/state/organization_chart_state.dart';

/// Firestore instance provider
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  // Keep alive to prevent re-initialization on hot reload
  ref.keepAlive();
  return FirebaseFirestore.instance;
});

/// Firestore data source provider
final organizationChartFirestoreDataSourceProvider =
    Provider<OrganizationChartFirestoreDataSource>((ref) {
  // Keep alive to maintain Firestore connection
  ref.keepAlive();
  final firestore = ref.watch(firestoreProvider);
  return OrganizationChartFirestoreDataSource(firestore);
});

/// Repository provider
final organizationChartRepositoryProvider =
    Provider<OrganizationChartRepository>((ref) {
  // Keep alive to maintain repository instance
  ref.keepAlive();
  final firestoreDataSource = ref.watch(organizationChartFirestoreDataSourceProvider);
  return OrganizationChartRepositoryImpl(firestoreDataSource);
});

/// Get organization chart use case provider
final getOrganizationChartProvider = Provider<GetOrganizationChart>((ref) {
  final repository = ref.watch(organizationChartRepositoryProvider);
  return GetOrganizationChart(repository);
});

/// Add employee use case provider
final addEmployeeProvider = Provider<AddEmployee>((ref) {
  final repository = ref.watch(organizationChartRepositoryProvider);
  return AddEmployee(repository);
});

/// Remove employee use case provider
final removeEmployeeProvider = Provider<RemoveEmployee>((ref) {
  final repository = ref.watch(organizationChartRepositoryProvider);
  return RemoveEmployee(repository);
});

/// Organization chart state provider
final organizationChartProvider =
    StateNotifierProvider<OrganizationChartNotifier, OrganizationChartState>(
  (ref) {
    final getOrganizationChart = ref.watch(getOrganizationChartProvider);
    final addEmployee = ref.watch(addEmployeeProvider);
    final removeEmployee = ref.watch(removeEmployeeProvider);
    final notifier = OrganizationChartNotifier(
      getOrganizationChart,
      addEmployee,
      removeEmployee,
    );
    notifier.loadOrganizationChart();
    return notifier;
  },
);
