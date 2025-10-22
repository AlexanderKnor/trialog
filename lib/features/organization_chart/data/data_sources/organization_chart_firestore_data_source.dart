import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trialog/core/errors/exceptions.dart';
import 'package:trialog/features/organization_chart/data/models/employee_model.dart';
import 'package:trialog/features/organization_chart/data/models/organization_node_model.dart';
import 'package:trialog/features/organization_chart/domain/entities/organization_node.dart';

/// Firestore data source for organization chart
/// Persists organization structure to Firebase Firestore
class OrganizationChartFirestoreDataSource {
  final FirebaseFirestore _firestore;
  static const String _collection = 'organization_chart';
  static const String _documentId = 'trialog_org';

  OrganizationChartFirestoreDataSource(this._firestore);

  /// Get the organization chart from Firestore
  Future<OrganizationNodeModel> getOrganizationChart() async {
    try {
      final doc = await _firestore
          .collection(_collection)
          .doc(_documentId)
          .get();

      if (!doc.exists || doc.data() == null) {
        // Return default structure if not exists
        return _createDefaultOrganization();
      }

      return OrganizationNodeModel.fromJson(doc.data()!);
    } catch (e) {
      throw ServerException(
        message: 'Failed to load organization chart from Firestore: $e',
      );
    }
  }

  /// Update the organization chart in Firestore
  Future<void> updateOrganizationChart(OrganizationNodeModel rootNode) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(_documentId)
          .set(rootNode.toJson(), SetOptions(merge: true));
    } catch (e) {
      throw ServerException(
        message: 'Failed to save organization chart to Firestore: $e',
      );
    }
  }

  /// Get a specific node by ID
  Future<OrganizationNodeModel?> getNodeById(String nodeId) async {
    try {
      final chart = await getOrganizationChart();
      return _findNodeById(chart, nodeId);
    } catch (e) {
      throw ServerException(
        message: 'Failed to get node from Firestore: $e',
      );
    }
  }

  /// Recursively find a node by ID
  OrganizationNodeModel? _findNodeById(
    OrganizationNodeModel node,
    String nodeId,
  ) {
    if (node.id == nodeId) {
      return node;
    }

    for (final child in node.children) {
      final found = _findNodeById(
        child as OrganizationNodeModel,
        nodeId,
      );
      if (found != null) {
        return found;
      }
    }

    return null;
  }

  /// Create the default Trialog organization structure
  OrganizationNodeModel _createDefaultOrganization() {
    // CEO Marcel Liebetrau (left)
    final marcelLiebetrau = OrganizationNodeModel(
      id: 'ceo-1',
      name: 'Marcel Liebetrau',
      type: NodeType.ceo,
      level: 1,
      parentId: 'company-root',
      employee: const EmployeeModel(
        id: 'emp-1',
        firstName: 'Marcel',
        lastName: 'Liebetrau',
        email: 'marcel.liebetrau@trialog.com',
      ),
    );

    // CEO Daniel Lippert (right)
    final danielLippert = OrganizationNodeModel(
      id: 'ceo-2',
      name: 'Daniel Lippert',
      type: NodeType.ceo,
      level: 1,
      parentId: 'company-root',
      employee: const EmployeeModel(
        id: 'emp-2',
        firstName: 'Daniel',
        lastName: 'Lippert',
        email: 'daniel.lippert@trialog.com',
      ),
    );

    // Root node: Trialog company (center)
    final rootNode = OrganizationNodeModel(
      id: 'company-root',
      name: 'Trialog',
      type: NodeType.company,
      level: 0,
      children: [
        marcelLiebetrau,
        danielLippert,
      ],
    );

    return rootNode;
  }
}
