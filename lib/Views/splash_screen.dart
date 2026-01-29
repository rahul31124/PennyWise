import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  final Color _bg = const Color(0xFFFFFDF5);
  final Color _black = const Color(0xFF111111);
  final Color _lime = const Color(0xFFD4FF5E);

  late AnimationController _mainController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  late AnimationController _rotateController;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
        CurvedAnimation(parent: _mainController, curve: Curves.easeOutExpo)
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _mainController, curve: Curves.easeOut)
    );

    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();

    _mainController.forward();

    Timer(const Duration(seconds: 3), _navigateToNext);
  }

  Future<void> _navigateToNext() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedCurrency = prefs.getString('currency_code');

    if (mounted) {
      if (savedCurrency != null && savedCurrency.isNotEmpty) {
        context.go('/');
      } else {
        context.go('/currency_selection');
      }
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: Stack(
        children: [
          Center(
            child: AnimatedBuilder(
              animation: _mainController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: FractionallySizedBox(
                      widthFactor: 0.65,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "PENNY",
                              style: GoogleFonts.syne(
                                fontSize: 64,
                                fontWeight: FontWeight.w900,
                                color: _black,
                                height: 0.8,
                                letterSpacing: -2.0,
                              ),
                            ),
                            Transform.rotate(
                              angle: -0.05,
                              child: Container(
                                margin: const EdgeInsets.only(top: 8),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                                decoration: BoxDecoration(
                                  color: _lime,
                                  border: Border.all(color: _black, width: 4),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _black,
                                      offset: const Offset(4, 4),
                                      blurRadius: 0,
                                    )
                                  ],
                                ),
                                child: Text(
                                  "WISE",
                                  style: GoogleFonts.syne(
                                    fontSize: 64,
                                    fontWeight: FontWeight.w900,
                                    color: _black,
                                    height: 1.0,
                                    letterSpacing: -2.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 50,
            child: Center(
              child: AnimatedBuilder(
                animation: _rotateController,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _rotateController.value * 2 * math.pi,
                    child: Icon(
                      Icons.star,
                      color: _black,
                      size: 24,
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 24,
            child: Center(
              child: Text(
                "EST. 2024",
                style: GoogleFonts.spaceMono(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400]
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}