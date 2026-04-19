import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Floating bottom bar: Home, Library, Explore (accent), Profile.
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onChanged,
  });

  final int currentIndex;
  final ValueChanged<int> onChanged;

  static const _neonGreen = Color(0xFF00FF88);
  static const _inactive = Color(0xFF6B7280);
  static const _blueAccent = Color(0xFF8FB4FF);

  bool _greenTab(int i) => i == 2 || i == 3;

  Color _iconColor(int i) {
    if (currentIndex != i) return _inactive;
    return _greenTab(i) ? _neonGreen : _blueAccent;
  }

  Color _labelColor(int i) {
    if (currentIndex != i) return _inactive;
    return _greenTab(i) ? _neonGreen : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            height: 72,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF0A0F22).withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _Tab(
                  label: 'Home',
                  icon: Icons.home_rounded,
                  selected: currentIndex == 0,
                  iconColor: _iconColor(0),
                  labelColor: _labelColor(0),
                  pillColor: const Color(0xFF15245A),
                  pillBorder: const Color(0xFF3D5AEF).withValues(alpha: 0.45),
                  onTap: () => onChanged(0),
                ),
                _Tab(
                  label: 'Library',
                  icon: Icons.menu_book_rounded,
                  selected: currentIndex == 1,
                  iconColor: _iconColor(1),
                  labelColor: _labelColor(1),
                  pillColor: const Color(0xFF15245A),
                  pillBorder: const Color(0xFF3D5AEF).withValues(alpha: 0.45),
                  onTap: () => onChanged(1),
                ),
                _Tab(
                  label: 'Explore',
                  icon: Icons.travel_explore_rounded,
                  selected: currentIndex == 2,
                  iconColor: _iconColor(2),
                  labelColor: _labelColor(2),
                  pillColor: const Color(0xFF0F2A1F),
                  pillBorder: _neonGreen.withValues(alpha: 0.45),
                  onTap: () => onChanged(2),
                ),
                _Tab(
                  label: 'Profile',
                  icon: Icons.person_outline_rounded,
                  selected: currentIndex == 3,
                  iconColor: _iconColor(3),
                  labelColor: _labelColor(3),
                  pillColor: const Color(0xFF0F2A1F),
                  pillBorder: _neonGreen.withValues(alpha: 0.45),
                  onTap: () => onChanged(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.icon,
    required this.selected,
    required this.iconColor,
    required this.labelColor,
    required this.pillColor,
    required this.pillBorder,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final Color iconColor;
  final Color labelColor;
  final Color pillColor;
  final Color pillBorder;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: selected ? pillColor.withValues(alpha: 0.92) : Colors.transparent,
              border: selected
                  ? Border.all(color: pillBorder, width: 1.1)
                  : Border.all(color: Colors.transparent),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: iconColor, size: 22),
                const SizedBox(height: 2),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: labelColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
