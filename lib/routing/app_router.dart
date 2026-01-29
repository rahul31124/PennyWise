import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';


import '../Views/analytics_screen.dart';
import '../Views/currency_selection_screen.dart';
import '../Views/dashboard_screen.dart';
import '../Views/add_transaction_modal.dart';
import '../Views/floating_nav_bar.dart';
import '../Views/history_screen.dart';
import '../Views/setting_screen.dart';
import '../Views/splash_screen.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/currency_selection',
        builder: (context, state) => const CurrencySelectionScreen(),
      ),

      ShellRoute(
        builder: (context, state, child) {
          return MainWrapperScreen(child: child);
        },
        routes: [
          GoRoute(path: '/', builder: (context, state) => const DashboardScreen()),
          GoRoute(path: '/analytics', builder: (context, state) => const AnalyticsScreen()),
          GoRoute(path: '/history', builder: (context, state) => const HistoryScreen()),
          GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
        ],
      ),
    ],
  );
});

class MainWrapperScreen extends StatefulWidget {
  final Widget child;
  const MainWrapperScreen({super.key, required this.child});

  @override
  State<MainWrapperScreen> createState() => _MainWrapperScreenState();
}

class _MainWrapperScreenState extends State<MainWrapperScreen> {
  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/analytics')) return 1;
    if (location.startsWith('/history')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0;
  }

  void _onTap(int index) {
    switch (index) {
      case 0: context.go('/'); break;
      case 1: context.go('/analytics'); break;
      case 2: context.go('/history'); break;
      case 3: context.go('/settings'); break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final int currentIndex = _calculateSelectedIndex(context);



    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,

      body: Stack(
        fit: StackFit.expand,
        children: [
          widget.child,

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: FloatingNavPill(
              currentIndex: currentIndex,
              onTap: _onTap,
            ),
          ),

          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: _NeoFab(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => const AddTransactionModal(),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NeoFab extends StatelessWidget {
  final VoidCallback onTap;
  const _NeoFab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: const Color(0xFFD4FF5E),
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFF111111), width: 3),
          // Hard Shadow to match the Pill
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(0, 6),
              blurRadius: 0,
            )
          ],
        ),
        child: const Icon(LucideIcons.plus, color: Colors.black, size: 32),
      ),
    );
  }
}