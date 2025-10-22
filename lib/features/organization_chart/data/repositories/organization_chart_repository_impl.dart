import 'package:dartz/dartz.dart';
import 'package:trialog/core/errors/exceptions.dart';
import 'package:trialog/core/errors/failures.dart';
import 'package:trialog/features/organization_chart/data/data_sources/organization_chart_firestore_data_source.dart';
import 'package:trialog/features/organization_chart/data/models/organization_node_model.dart';
import 'package:trialog/features/organization_chart/domain/entities/organization_node.dart';
import 'package:trialog/features/organization_chart/domain/repositories/organization_chart_repository.dart';
import 'package:trialog/shared/models/result.dart';

/// Implementation of organization chart repository
class OrganizationChartRepositoryImpl implements OrganizationChartRepository {
  final OrganizationChartFirestoreDataSource firestoreDataSource;

  const OrganizationChartRepositoryImpl(this.firestoreDataSource);

  @override
  Future<Result<OrganizationNode>> getOrganizationChart() async {
    try {
      final nodeModel = await firestoreDataSource.getOrganizationChart();
      return Right(nodeModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        code: e.code,
        details: e.details,
      ));
    } catch (e) {
      return Left(UnexpectedFailure(
        message: 'Failed to load organization chart: $e',
      ));
    }
  }

  @override
  Future<Result<OrganizationNode>> getNodeById(String nodeId) async {
    try {
      final nodeModel = await firestoreDataSource.getNodeById(nodeId);

      if (nodeModel == null) {
        return const Left(NotFoundFailure(
          message: 'Organization node not found',
        ));
      }

      return Right(nodeModel.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        code: e.code,
        details: e.details,
      ));
    } catch (e) {
      return Left(UnexpectedFailure(
        message: 'Failed to load organization node: $e',
      ));
    }
  }

  @override
  Future<Result<void>> updateOrganizationChart(OrganizationNode rootNode) async {
    try {
      final nodeModel = OrganizationNodeModel.fromEntity(rootNode);
      await firestoreDataSource.updateOrganizationChart(nodeModel);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(
        message: e.message,
        code: e.code,
        details: e.details,
      ));
    } catch (e) {
      return Left(UnexpectedFailure(
        message: 'Failed to update organization chart: $e',
      ));
    }
  }
}
