import 'package:trialog/features/organization_chart/domain/entities/employee.dart';

/// Employee data model
class EmployeeModel extends Employee {
  const EmployeeModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    super.email,
    super.phone,
    super.imageUrl,
    super.insurancePercentage,
    super.realEstatePercentage,
  });

  /// Create from JSON
  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      imageUrl: json['imageUrl'] as String?,
      insurancePercentage: json['insurancePercentage'] as double?,
      realEstatePercentage: json['realEstatePercentage'] as double?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'imageUrl': imageUrl,
      'insurancePercentage': insurancePercentage,
      'realEstatePercentage': realEstatePercentage,
    };
  }

  /// Create from entity
  factory EmployeeModel.fromEntity(Employee employee) {
    return EmployeeModel(
      id: employee.id,
      firstName: employee.firstName,
      lastName: employee.lastName,
      email: employee.email,
      phone: employee.phone,
      imageUrl: employee.imageUrl,
      insurancePercentage: employee.insurancePercentage,
      realEstatePercentage: employee.realEstatePercentage,
    );
  }

  /// Convert to entity
  Employee toEntity() {
    return Employee(
      id: id,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
      imageUrl: imageUrl,
      insurancePercentage: insurancePercentage,
      realEstatePercentage: realEstatePercentage,
    );
  }
}
