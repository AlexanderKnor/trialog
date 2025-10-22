import 'package:equatable/equatable.dart';
import 'package:trialog/features/organization_chart/domain/entities/employee.dart';

/// Organization node type
enum NodeType {
  company,
  ceo,
  department,
  team,
  employee,
}

/// Organization chart node representing a hierarchical element
class OrganizationNode extends Equatable {
  final String id;
  final String name;
  final NodeType type;
  final Employee? employee;
  final List<OrganizationNode> children;
  final String? parentId;
  final int level;

  const OrganizationNode({
    required this.id,
    required this.name,
    required this.type,
    this.employee,
    this.children = const [],
    this.parentId,
    required this.level,
  });

  /// Check if node is a leaf (has no children)
  bool get isLeaf => children.isEmpty;

  /// Check if node is the root (has no parent)
  bool get isRoot => parentId == null;

  /// Check if node has employee information
  bool get hasEmployee => employee != null;

  /// Copy with new values
  OrganizationNode copyWith({
    String? id,
    String? name,
    NodeType? type,
    Employee? employee,
    List<OrganizationNode>? children,
    String? parentId,
    int? level,
  }) {
    return OrganizationNode(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      employee: employee ?? this.employee,
      children: children ?? this.children,
      parentId: parentId ?? this.parentId,
      level: level ?? this.level,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        employee,
        children,
        parentId,
        level,
      ];
}
