import 'package:trialog/features/organization_chart/data/models/employee_model.dart';
import 'package:trialog/features/organization_chart/domain/entities/organization_node.dart';

/// Organization node data model
class OrganizationNodeModel extends OrganizationNode {
  const OrganizationNodeModel({
    required super.id,
    required super.name,
    required super.type,
    super.employee,
    super.children,
    super.parentId,
    required super.level,
  });

  /// Create from JSON
  factory OrganizationNodeModel.fromJson(Map<String, dynamic> json) {
    return OrganizationNodeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: _nodeTypeFromString(json['type'] as String),
      employee: json['employee'] != null
          ? EmployeeModel.fromJson(json['employee'] as Map<String, dynamic>)
          : null,
      children: (json['children'] as List<dynamic>?)
              ?.map((e) =>
                  OrganizationNodeModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      parentId: json['parentId'] as String?,
      level: json['level'] as int,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': _nodeTypeToString(type),
      'employee': employee != null
          ? EmployeeModel.fromEntity(employee!).toJson()
          : null,
      'children': children
          .map((child) => OrganizationNodeModel.fromEntity(child).toJson())
          .toList(),
      'parentId': parentId,
      'level': level,
    };
  }

  /// Create from entity
  factory OrganizationNodeModel.fromEntity(OrganizationNode node) {
    return OrganizationNodeModel(
      id: node.id,
      name: node.name,
      type: node.type,
      employee: node.employee,
      children: node.children
          .map((child) => OrganizationNodeModel.fromEntity(child))
          .toList(),
      parentId: node.parentId,
      level: node.level,
    );
  }

  /// Convert to entity
  OrganizationNode toEntity() {
    return OrganizationNode(
      id: id,
      name: name,
      type: type,
      employee: employee,
      children: children,
      parentId: parentId,
      level: level,
    );
  }

  /// Convert NodeType to string
  static String _nodeTypeToString(NodeType type) {
    return type.name;
  }

  /// Convert string to NodeType
  static NodeType _nodeTypeFromString(String typeString) {
    return NodeType.values.firstWhere(
      (type) => type.name == typeString,
      orElse: () => NodeType.employee,
    );
  }
}
