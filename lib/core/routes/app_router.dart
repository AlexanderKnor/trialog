import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trialog/features/organization_chart/presentation/screens/organization_chart_screen.dart';

/// Application router configuration
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const OrganizationChartScreen(),
      ),
      GoRoute(
        path: '/organigramm',
        name: 'organigramm',
        builder: (context, state) => const OrganizationChartScreen(),
      ),
      // TODO: Add additional feature routes here
    ],
    errorBuilder: (context, state) => _ErrorPage(error: state.error),
  );
}


/// Error page
class _ErrorPage extends StatelessWidget {
  final Exception? error;

  const _ErrorPage({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Page not found',
              style: TextStyle(fontSize: 20),
            ),
            if (error != null) ...[
              const SizedBox(height: 8),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
