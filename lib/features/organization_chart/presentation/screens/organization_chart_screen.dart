import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trialog/features/organization_chart/presentation/state/organization_chart_providers.dart';
import 'package:trialog/features/organization_chart/presentation/widgets/organization_chart_view.dart';
import 'package:trialog/shared/components/error_view.dart';
import 'package:trialog/shared/components/loading_indicator.dart';

/// Organization chart screen
class OrganizationChartScreen extends ConsumerWidget {
  const OrganizationChartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(organizationChartProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trialog Organigramm'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(organizationChartProvider.notifier).refresh();
            },
            tooltip: 'Aktualisieren',
          ),
        ],
      ),
      body: _buildBody(context, ref, state),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    state,
  ) {
    if (state.isLoading) {
      return const LoadingIndicator();
    }

    if (state.error != null) {
      return ErrorView(
        message: state.error!,
        onRetry: () {
          ref.read(organizationChartProvider.notifier).refresh();
        },
      );
    }

    if (state.rootNode == null) {
      return const ErrorView(
        message: 'Keine Organisationsstruktur verfügbar',
      );
    }

    return OrganizationChartView(
      rootNode: state.rootNode!,
    );
  }
}
