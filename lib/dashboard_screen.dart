import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Home tab: matches the dark “study dashboard” mockup.
class HomeDashboardPage extends StatefulWidget {
  const HomeDashboardPage({super.key});

  @override
  State<HomeDashboardPage> createState() => _HomeDashboardPageState();
}

class _HomeDashboardPageState extends State<HomeDashboardPage> {
  int _selectedCategory = 0;

  static const _categories = [
    _CategoryChipData('All', Icons.grid_view_rounded, Color(0xFF2F6BFF)),
    _CategoryChipData('CATs', Icons.assignment_outlined, Color(0xFFFF8A34)),
    _CategoryChipData('Exams', Icons.edit_note_rounded, Color(0xFF8B5CFF)),
    _CategoryChipData('Notes', Icons.description_outlined, Color(0xFF2ED47A)),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          const _AmbientBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _TopBar(textTheme: textTheme),
                  const SizedBox(height: 16),
                  const _HeroCard(),
                  const SizedBox(height: 28),
                  Text(
                    'Dashboard',
                    style: GoogleFonts.inter(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Find your academic edge.',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.55),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    height: 44,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _categories.length,
                      separatorBuilder: (context, _) =>
                          const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final c = _categories[index];
                        final selected = _selectedCategory == index;
                        return _CategoryChip(
                          data: c,
                          selected: selected,
                          onTap: () =>
                              setState(() => _selectedCategory = index),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 18),
                  const _SearchRow(),
                  const SizedBox(height: 10),
                  _FilterRow(textTheme: textTheme),
                  const SizedBox(height: 22),
                  const _TrendingBanner(),
                  const SizedBox(height: 26),
                  Center(
                    child: Text(
                      'RECENT UPLOADS',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF6FA8FF),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const _RecentUploadsGrid(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AmbientBackground extends StatelessWidget {
  const _AmbientBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF070B18),
            Color(0xFF03040A),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            right: -60,
            child: _glow(const Color(0xFF5B3DFF), 180),
          ),
          Positioned(
            top: 40,
            left: -40,
            child: _glow(const Color(0xFF1E6BFF), 160),
          ),
          Positioned(
            bottom: 120,
            right: -20,
            child: _glow(const Color(0xFF00C896).withValues(alpha: 0.25), 140),
          ),
        ],
      ),
    );
  }

  static Widget _glow(Color color, double size) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.45),
              blurRadius: 90,
              spreadRadius: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.textTheme});

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFF3D5AEF).withValues(alpha: 0.7),
              width: 1.4,
            ),
            color: const Color(0xFF0F1733).withValues(alpha: 0.6),
          ),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: Color(0xFF6FA8FF),
            size: 22,
          ),
        ),
      ],
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 22, 16, 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF111B36),
            Color(0xFF0B1022),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF243A7A).withValues(alpha: 0.55),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2B4DFF).withValues(alpha: 0.18),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Study Smarter,\nPerform Better!',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    height: 1.25,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Access quality notes, CATs & past exams in one place.',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    height: 1.4,
                    color: Colors.white.withValues(alpha: 0.62),
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF2F6BFF),
                        Color(0xFF7B3DFF),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4B6BFF).withValues(alpha: 0.45),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Start Learning',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          const _HeroIllustration(),
        ],
      ),
    );
  }
}

class _HeroIllustration extends StatelessWidget {
  const _HeroIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 120,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            top: 0,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFD447).withValues(alpha: 0.95),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD447).withValues(alpha: 0.65),
                    blurRadius: 18,
                  ),
                ],
              ),
              child: const Icon(Icons.lightbulb_rounded, color: Colors.white),
            ),
          ),
          Positioned(
            bottom: 18,
            child: Transform.rotate(
              angle: -0.08,
              child: _bookLayer(const Color(0xFF2F6BFF), width: 72),
            ),
          ),
          Positioned(
            bottom: 10,
            child: Transform.rotate(
              angle: 0.05,
              child: _bookLayer(const Color(0xFF8B5CFF), width: 78),
            ),
          ),
          Positioned(
            bottom: 2,
            child: _bookLayer(const Color(0xFF2ED47A), width: 84),
          ),
          Positioned(
            bottom: 52,
            child: Icon(
              Icons.school_rounded,
              size: 36,
              color: Colors.white.withValues(alpha: 0.95),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _bookLayer(Color spine, {required double width}) {
    return Container(
      width: width,
      height: 22,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: LinearGradient(
          colors: [
            spine,
            spine.withValues(alpha: 0.75),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );
  }
}

class _CategoryChipData {
  const _CategoryChipData(this.label, this.icon, this.color);

  final String label;
  final IconData icon;
  final Color color;
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.data,
    required this.selected,
    required this.onTap,
  });

  final _CategoryChipData data;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: data.color.withValues(alpha: selected ? 1 : 0.88),
            border: Border.all(
              color: selected
                  ? Colors.white.withValues(alpha: 0.35)
                  : Colors.transparent,
              width: 1.2,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: data.color.withValues(alpha: 0.45),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(data.icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                data.label,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchRow extends StatelessWidget {
  const _SearchRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF12172A),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  color: Colors.white.withValues(alpha: 0.45),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                    cursorColor: const Color(0xFF39FF9A),
                    decoration: InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: 'Search Unit Code...',
                      hintStyle: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.35),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF39FF9A),
                Color(0xFF00D67A),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF39FF9A).withValues(alpha: 0.45),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.search_rounded, color: Color(0xFF042014)),
        ),
      ],
    );
  }
}

class _FilterRow extends StatelessWidget {
  const _FilterRow({required this.textTheme});

  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.tune_rounded,
          size: 18,
          color: Colors.white.withValues(alpha: 0.45),
        ),
        const SizedBox(width: 6),
        Text(
          'Filter',
          style: GoogleFonts.inter(
            fontSize: 13,
            color: Colors.white.withValues(alpha: 0.5),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _TrendingBanner extends StatelessWidget {
  const _TrendingBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 14, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F2A1F),
            Color(0xFF07140F),
          ],
        ),
        border: Border.all(
          color: const Color(0xFF2ED47A).withValues(alpha: 0.45),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2ED47A).withValues(alpha: 0.12),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🔥 Trending Now',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF5BFF9E),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'End of Semester Revision Pack',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Get top CATs & Exam questions.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.55),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF1FAF6A),
                        Color(0xFF0E7A47),
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View All',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const _MiniBookStack(),
        ],
      ),
    );
  }
}

class _MiniBookStack extends StatelessWidget {
  const _MiniBookStack();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 72,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            bottom: 0,
            child: _book(const Color(0xFF2F6BFF), 56),
          ),
          Positioned(
            bottom: 8,
            child: _book(const Color(0xFFFF8A34), 50),
          ),
          Positioned(
            bottom: 16,
            child: _book(const Color(0xFF8B5CFF), 44),
          ),
        ],
      ),
    );
  }

  static Widget _book(Color c, double w) {
    return Container(
      width: w,
      height: 14,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: c,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
    );
  }
}

class _RecentUploadsGrid extends StatelessWidget {
  const _RecentUploadsGrid();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Expanded(
          child: _UploadCard(
            title: 'DATA COMMUNICATION',
            titleColor: Color(0xFFFFFFFF),
            gradientColors: [
              Color(0xFF0B1F3F),
              Color(0xFF102E66),
              Color(0xFF0A1630),
            ],
            accentGlow: Color(0xFF4B7BFF),
            unit: 'DCCU 201',
            year: '2025',
            type: 'NOTES',
            typeColor: Color(0xFF2ED47A),
            views: '1.2k',
            likes: '340',
            comments: '28',
            pattern: _CardPattern.network,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _UploadCard(
            title: 'ASSEMBLY LANGUAGE',
            titleColor: Color(0xFFFF4B6B),
            gradientColors: [
              Color(0xFF1A0A12),
              Color(0xFF3A0F18),
              Color(0xFF0D0508),
            ],
            accentGlow: Color(0xFFFF4B6B),
            unit: 'ACMP 271',
            year: '2025',
            type: 'EXAM',
            typeColor: Color(0xFF8B5CFF),
            views: '980',
            likes: '210',
            comments: '19',
            pattern: _CardPattern.code,
          ),
        ),
      ],
    );
  }
}

enum _CardPattern { network, code }

class _UploadCard extends StatelessWidget {
  const _UploadCard({
    required this.title,
    required this.titleColor,
    required this.gradientColors,
    required this.accentGlow,
    required this.unit,
    required this.year,
    required this.type,
    required this.typeColor,
    required this.views,
    required this.likes,
    required this.comments,
    required this.pattern,
  });

  final String title;
  final Color titleColor;
  final List<Color> gradientColors;
  final Color accentGlow;
  final String unit;
  final String year;
  final String type;
  final Color typeColor;
  final String views;
  final String likes;
  final String comments;
  final _CardPattern pattern;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0xFF0C1020),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
        boxShadow: [
          BoxShadow(
            color: accentGlow.withValues(alpha: 0.12),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AspectRatio(
            aspectRatio: 0.92,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradientColors,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: CustomPaint(
                    painter: pattern == _CardPattern.network
                        ? _NetworkPatternPainter(
                            accent: accentGlow.withValues(alpha: 0.35),
                          )
                        : _CodePatternPainter(
                            accent: accentGlow.withValues(alpha: 0.25),
                          ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                        letterSpacing: 0.3,
                        color: titleColor,
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.65),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 8,
                  right: 8,
                  bottom: 8,
                  child: Row(
                    children: [
                      _TagChip(text: unit, color: const Color(0xFFFF5FA8)),
                      const SizedBox(width: 6),
                      _TagChip(text: year, color: const Color(0xFFFFD447)),
                      const SizedBox(width: 6),
                      _TagChip(text: type, color: typeColor),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _Stat(icon: Icons.visibility_outlined, value: views),
                _Stat(icon: Icons.thumb_up_alt_outlined, value: likes),
                _Stat(icon: Icons.chat_bubble_outline_rounded, value: comments),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: color,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.inter(
            fontSize: 9,
            fontWeight: FontWeight.w700,
            color: Colors.black.withValues(alpha: 0.82),
          ),
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.icon, required this.value});

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: Colors.white.withValues(alpha: 0.45),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.white.withValues(alpha: 0.65),
          ),
        ),
      ],
    );
  }
}

class _NetworkPatternPainter extends CustomPainter {
  _NetworkPatternPainter({required this.accent});

  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = accent
      ..strokeWidth = 1.2;

    final nodes = <Offset>[
      Offset(size.width * 0.2, size.height * 0.25),
      Offset(size.width * 0.75, size.height * 0.2),
      Offset(size.width * 0.55, size.height * 0.55),
      Offset(size.width * 0.25, size.height * 0.7),
    ];

    for (var i = 0; i < nodes.length; i++) {
      for (var j = i + 1; j < nodes.length; j++) {
        canvas.drawLine(nodes[i], nodes[j], paint);
      }
    }
    for (final n in nodes) {
      canvas.drawCircle(n, 3.5, Paint()..color = Colors.white.withValues(alpha: 0.35));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _CodePatternPainter extends CustomPainter {
  _CodePatternPainter({required this.accent});

  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..color = accent;
    final rnd = size.width * 0.04;
    for (var y = 12.0; y < size.height - 20; y += 14) {
      final w = size.width * (0.35 + (y % 40) / 120);
      final r = RRect.fromLTRBR(10, y, 10 + w, y + 6, Radius.circular(rnd));
      canvas.drawRRect(r, p);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
