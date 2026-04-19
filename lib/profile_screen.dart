import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widgets/study_smart_top_bar.dart';

/// Profile tab: avatar, stats, academic info, access, theme, links, log out.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  /// 0 Light, 1 Dark, 2 Black
  int _themeMode = 1;

  static const _bg = Color(0xFF0B0E14);
  static const _card = Color(0xFF12182A);
  static const _blue = Color(0xFF3B82F6);
  static const _mint = Color(0xFF00FF88);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const StudySmartTopBar(),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Profile',
                    style: GoogleFonts.inter(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Material(
                    color: const Color(0xFFFF8A34),
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(10),
                      child: const SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.tune_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: _blue,
                      ),
                      child: CircleAvatar(
                        radius: 56,
                        backgroundColor: const Color(0xFF1E293B),
                        child: Icon(
                          Icons.person_rounded,
                          size: 72,
                          color: Colors.white.withValues(alpha: 0.45),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 4,
                      bottom: 4,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _mint,
                          border: Border.all(color: _bg, width: 3),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.35),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.edit_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Cona Kipchoge',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '@conakip',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.45),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Computer Science University of Nairobi',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: const [
                  Expanded(
                    child: _StatMiniCard(
                      icon: Icons.cloud_outlined,
                      value: '1',
                      label: 'Contributions',
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _StatMiniCard(
                      icon: Icons.bolt_rounded,
                      value: '0',
                      label: 'Stars',
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _StatMiniCard(
                      icon: Icons.local_fire_department_rounded,
                      value: '7',
                      label: 'Day Streak',
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _StatMiniCard(
                      icon: null,
                      value: '2450',
                      label: 'XP Points',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: _card,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Academic Personalization',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.school_outlined,
                          size: 20,
                          color: Colors.white.withValues(alpha: 0.35),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const _AcademicRow(
                      label: 'Program',
                      value: 'Bachelor of Computer Science',
                    ),
                    const SizedBox(height: 12),
                    const _AcademicRow(label: 'Year', value: 'Year 1'),
                    const SizedBox(height: 12),
                    const _AcademicRow(label: 'Semester', value: 'Sem 1'),
                    const SizedBox(height: 14),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          backgroundColor: _blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Edit Details',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'Access Status',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: const [
                  Expanded(
                    child: _AccessCard(
                      title: 'Get Access',
                      icon: Icons.public_rounded,
                      iconColor: _mint,
                      badge: 'ACTIVE',
                      badgeActive: true,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _AccessCard(
                      title: 'Ad-Watch',
                      icon: Icons.diamond_outlined,
                      iconColor: Color(0xFFFF8A34),
                      badge: 'INACTIVE',
                      badgeActive: false,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: _AccessCard(
                      title: 'Contributor',
                      icon: Icons.diamond_outlined,
                      iconColor: _blue,
                      badge: 'ACTIVE',
                      badgeActive: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Text(
                'Theme Mode',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: const Color(0xFF0A0F18),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.06),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _ThemeChip(
                        label: 'Light',
                        selected: _themeMode == 0,
                        onTap: () => setState(() => _themeMode = 0),
                      ),
                    ),
                    Expanded(
                      child: _ThemeChip(
                        label: 'Dark',
                        selected: _themeMode == 1,
                        onTap: () => setState(() => _themeMode = 1),
                      ),
                    ),
                    Expanded(
                      child: _ThemeChip(
                        label: 'Black',
                        selected: _themeMode == 2,
                        onTap: () => setState(() => _themeMode = 2),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 8,
                children: [
                  _FooterLink(label: 'Help & Support', onTap: () {}),
                  Text(
                    '|',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.25),
                    ),
                  ),
                  _FooterLink(label: 'Privacy Policy', onTap: () {}),
                  Text(
                    '|',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.25),
                    ),
                  ),
                  _FooterLink(label: 'Change Password', onTap: () {}),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFDC2626),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    'Log Out',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatMiniCard extends StatelessWidget {
  const _StatMiniCard({
    required this.value,
    required this.label,
    this.icon,
  });

  final String value;
  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF12182A),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        children: [
          if (icon != null)
            Icon(icon, size: 18, color: Colors.white.withValues(alpha: 0.55))
          else
            const SizedBox(height: 18),
          if (icon != null) const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: GoogleFonts.inter(
              fontSize: 9,
              height: 1.2,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.42),
            ),
          ),
        ],
      ),
    );
  }
}

class _AcademicRow extends StatelessWidget {
  const _AcademicRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 88,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.white.withValues(alpha: 0.45),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _AccessCard extends StatelessWidget {
  const _AccessCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.badge,
    required this.badgeActive,
  });

  final String title;
  final IconData icon;
  final Color iconColor;
  final String badge;
  final bool badgeActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFF12182A),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 26),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: badgeActive
                  ? const Color(0xFF00FF88).withValues(alpha: 0.18)
                  : const Color(0xFFDC2626).withValues(alpha: 0.2),
            ),
            child: Text(
              badge,
              style: GoogleFonts.inter(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.4,
                color: badgeActive
                    ? const Color(0xFF00FF88)
                    : const Color(0xFFFF6B6B),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeChip extends StatelessWidget {
  const _ThemeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: selected ? const Color(0xFF00FF88) : Colors.transparent,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: selected
                  ? const Color(0xFF042814)
                  : Colors.white.withValues(alpha: 0.45),
            ),
          ),
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF6FA8FF),
          decoration: TextDecoration.underline,
          decorationColor: const Color(0xFF6FA8FF).withValues(alpha: 0.5),
        ),
      ),
    );
  }
}
