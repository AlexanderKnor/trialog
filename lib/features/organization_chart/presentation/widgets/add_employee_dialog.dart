import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trialog/core/constants/design_constants.dart';
import 'package:trialog/core/utils/validators.dart';
import 'package:trialog/features/organization_chart/domain/entities/employee.dart';
import 'package:trialog/features/organization_chart/domain/entities/organization_node.dart';
import 'package:trialog/features/organization_chart/presentation/state/organization_chart_providers.dart';

/// Dialog for adding a new employee
class AddEmployeeDialog extends ConsumerStatefulWidget {
  final String parentId;

  const AddEmployeeDialog({
    super.key,
    required this.parentId,
  });

  @override
  ConsumerState<AddEmployeeDialog> createState() => _AddEmployeeDialogState();
}

class _AddEmployeeDialogState extends ConsumerState<AddEmployeeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _insuranceController = TextEditingController();
  final _realEstateController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _insuranceController.dispose();
    _realEstateController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    final employee = Employee(
      id: 'emp-${DateTime.now().millisecondsSinceEpoch}',
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim().isEmpty
          ? null
          : _emailController.text.trim(),
      phone: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      insurancePercentage: _insuranceController.text.trim().isEmpty
          ? null
          : double.tryParse(_insuranceController.text.trim()),
      realEstatePercentage: _realEstateController.text.trim().isEmpty
          ? null
          : double.tryParse(_realEstateController.text.trim()),
    );

    final success = await ref.read(organizationChartProvider.notifier).addEmployee(
          parentId: widget.parentId,
          employee: employee,
          nodeType: NodeType.employee,
        );

    if (mounted) {
      setState(() => _isLoading = false);

      if (success) {
        Navigator.of(context).pop(true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Mitarbeiter erfolgreich hinzugefügt'),
            backgroundColor: DesignConstants.successColor,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Fehler beim Hinzufügen des Mitarbeiters'),
            backgroundColor: DesignConstants.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Neuer Mitarbeiter'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // First Name
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(
                  labelText: 'Vorname *',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (!Validators.isNotEmpty(value)) {
                    return 'Bitte Vorname eingeben';
                  }
                  return null;
                },
                enabled: !_isLoading,
              ),
              const SizedBox(height: DesignConstants.spacingMd),

              // Last Name
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Nachname *',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  if (!Validators.isNotEmpty(value)) {
                    return 'Bitte Nachname eingeben';
                  }
                  return null;
                },
                enabled: !_isLoading,
              ),
              const SizedBox(height: DesignConstants.spacingMd),

              // Insurance Percentage
              TextFormField(
                controller: _insuranceController,
                decoration: const InputDecoration(
                  labelText: 'Versicherung (%)',
                  prefixIcon: Icon(Icons.shield),
                  suffixText: '%',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final number = double.tryParse(value);
                    if (number == null) {
                      return 'Ungültige Zahl';
                    }
                    if (number < 0 || number > 100) {
                      return 'Wert muss zwischen 0 und 100 liegen';
                    }
                  }
                  return null;
                },
                enabled: !_isLoading,
              ),
              const SizedBox(height: DesignConstants.spacingMd),

              // Real Estate Percentage
              TextFormField(
                controller: _realEstateController,
                decoration: const InputDecoration(
                  labelText: 'Immobilien (%)',
                  prefixIcon: Icon(Icons.house),
                  suffixText: '%',
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final number = double.tryParse(value);
                    if (number == null) {
                      return 'Ungültige Zahl';
                    }
                    if (number < 0 || number > 100) {
                      return 'Wert muss zwischen 0 und 100 liegen';
                    }
                  }
                  return null;
                },
                enabled: !_isLoading,
              ),
              const SizedBox(height: DesignConstants.spacingMd),

              // Email (Optional)
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-Mail (optional)',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value != null &&
                      value.isNotEmpty &&
                      !Validators.isValidEmail(value)) {
                    return 'Ungültige E-Mail-Adresse';
                  }
                  return null;
                },
                enabled: !_isLoading,
              ),
              const SizedBox(height: DesignConstants.spacingMd),

              // Phone (Optional)
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefon (optional)',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                enabled: !_isLoading,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _handleSubmit,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Hinzufügen'),
        ),
      ],
    );
  }
}
