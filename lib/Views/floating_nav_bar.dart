import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FloatingNavPill extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const FloatingNavPill({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // --- NEO PALETTE ---
    final Color navBg = Colors.white;
    final Color borderBlack = const Color(0xFF111111);
    final Color activeItemBg = const Color(0xFF111111); // Active = Solid Black
    final Color activeItemIcon = const Color(0xFFD4FF5E); // Active Icon = Lime Green
    final Color inactiveItemIcon = Colors.grey[400]!;

    return Container(
      margin: const EdgeInsets.only(bottom: 24, left: 16, right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: navBg,
        borderRadius: BorderRadius.circular(50), // Fully rounded pill
        border: Border.all(color: borderBlack, width: 3), // THICK BORDER
        // 🔥 HARD SHADOW (Neo-Brutalism Signature)
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 0,
            offset: Offset(0, 6), // Hard shadow underneath
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // --- LEFT SIDE ---
          _NavItem(
            assetPath: 'assets/images/house-blank.png',
            isActive: currentIndex == 0,
            activeBg: activeItemBg,
            activeIconColor: activeItemIcon,
            inactiveIconColor: inactiveItemIcon,
            onTap: () => onTap(0),
          ),

          const SizedBox(width: 8),

          _NavItem(
            assetPath: 'assets/images/charts.png',
            isActive: currentIndex == 1,
            activeBg: activeItemBg,
            activeIconColor: activeItemIcon,
            inactiveIconColor: inactiveItemIcon,
            onTap: () => onTap(1),
          ),

          // --- THE GAP FOR THE FAB ---
          // Adjusted slightly to ensure the FAB fits the "Brutalist" spacing
          const SizedBox(width: 80),

          // --- RIGHT SIDE ---
          _NavItem(
            assetPath: 'assets/images/transactions.png',
            isActive: currentIndex == 2,
            activeBg: activeItemBg,
            activeIconColor: activeItemIcon,
            inactiveIconColor: inactiveItemIcon,
            onTap: () => onTap(2),
          ),

          const SizedBox(width: 8),

          _NavItem(
            assetPath: 'assets/images/gears.png',
            isActive: currentIndex == 3,
            activeBg: activeItemBg,
            activeIconColor: activeItemIcon,
            inactiveIconColor: inactiveItemIcon,
            onTap: () => onTap(3),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String assetPath;
  final bool isActive;
  final Color activeBg;
  final Color activeIconColor;
  final Color inactiveIconColor;
  final VoidCallback onTap;

  const _NavItem({
    required this.assetPath,
    required this.isActive,
    required this.activeBg,
    required this.activeIconColor,
    required this.inactiveIconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOutBack, // Bouncy effect
        width: 50,
        height: 50,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive ? activeBg : Colors.transparent,
          shape: BoxShape.circle,
          // Optional: Add a border to the active circle too?
          // border: isActive ? Border.all(color: Colors.black, width: 2) : null,
        ),
        child: Image.asset(
          assetPath,
          // Logic: If active, use the POP color (Lime). If inactive, use Grey.
          color: isActive ? activeIconColor : inactiveIconColor,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}