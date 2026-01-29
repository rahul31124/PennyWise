import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AddTransactionFab extends StatelessWidget {
  final VoidCallback onPressed;

  const AddTransactionFab({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    // Professional Theme Colors
    final Color primaryYellow = const Color(0xFFFFD54F);
    final Color blackText = const Color(0xFF1C1C1E);

    return SizedBox(
      width: 72, // Big Size
      height: 72,
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: primaryYellow,
        shape: const CircleBorder(),
        elevation: 4,
        child: Icon(
          LucideIcons.plus,
          color: blackText,
          size: 32, // Large Icon
        ),
      ),
    );
  }
}