import 'package:equatable/equatable.dart';

/// Employee entity representing a person in the organization
class Employee extends Equatable {
  final String id;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phone;
  final String? imageUrl;
  final double? insurancePercentage;
  final double? realEstatePercentage;

  const Employee({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phone,
    this.imageUrl,
    this.insurancePercentage,
    this.realEstatePercentage,
  });

  /// Full name of the employee
  String get fullName => '$firstName $lastName';

  /// Initials for display
  String get initials {
    final firstInitial = firstName.isNotEmpty ? firstName[0] : '';
    final lastInitial = lastName.isNotEmpty ? lastName[0] : '';
    return '$firstInitial$lastInitial'.toUpperCase();
  }

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        phone,
        imageUrl,
        insurancePercentage,
        realEstatePercentage,
      ];
}
