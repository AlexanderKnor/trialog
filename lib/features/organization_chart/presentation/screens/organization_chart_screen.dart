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
      backgroundColor: const Color(0xFFF5F5F7), // Apple iOS systemGray6 - subtle premium background
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: Container(
          decoration: BoxDecoration(
            // Premium gradient in Trialog blue
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF142D54), // Slightly lighter
                Color(0xFF10274C), // Trialog Corporate Blue
              ],
            ),
            // Subtle shadow for depth
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 48), // Balance for action button
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'TRIALOG',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2.5,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Organigramm',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.85),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.refresh_rounded),
                    iconSize: 26,
                    color: Colors.white,
                    onPressed: () {
                      ref.read(organizationChartProvider.notifier).refresh();
                    },
                    tooltip: 'Aktualisieren',
                  ),
                ],
              ),
            ),
          ),
        ),
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
