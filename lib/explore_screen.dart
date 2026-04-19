import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widgets/study_smart_top_bar.dart';

/// Explore tab: carousel, campus stats, popular courses, faculties grid.
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final PageController _carouselController = PageController(viewportFraction: 0.92);
  int _carouselPage = 0;

  static const _bg = Color(0xFF0A0A1B);
  static const _neonGreen = Color(0xFF00FF88);
  static const _purple = Color(0xFF7B61FF);

  @override
  void dispose() {
    _carouselController.dispose();
    super.dispose();
  }

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
              const SizedBox(height: 20),
              Text(
                '📌 STUDY TIP',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.45),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: PageView(
                  controller: _carouselController,
                  onPageChanged: (i) => setState(() => _carouselPage = i),
                  children: const [
                    _StudyTipCarouselCard(),
                    _StatsCarouselCard(),
                    _DidYouKnowCarouselCard(),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _CarouselDots(
                count: 3,
                index: _carouselPage,
                activeColor: _carouselPage == 1
                    ? _purple
                    : _carouselPage == 2
                        ? _purple
                        : _neonGreen,
              ),
              const SizedBox(height: 28),
              Text(
                '📊 CAMPUS STATS',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.45),
                ),
              ),
              const SizedBox(height: 10),
              const _CampusStatsCard(),
              const SizedBox(height: 28),
              Text(
                '⭐ MOST POPULAR TODAY',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFFFD447),
                ),
              ),
              const SizedBox(height: 12),
              const _PopularCourseTile(
                code: 'PHYS 120',
                title: 'General Physics',
                views: '312',
                secondary: '45',
              ),
              const SizedBox(height: 10),
              const _PopularCourseTile(
                code: 'ECON 100',
                title: 'Introduction to Economics',
                views: '280',
                secondary: '38',
              ),
              const SizedBox(height: 10),
              const _PopularCourseTile(
                code: 'CHEM 110',
                title: 'General Chemistry',
                views: '256',
                secondary: '31',
              ),
              const SizedBox(height: 28),
              Text(
                '🏫 FACULTIES',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.45),
                ),
              ),
              const SizedBox(height: 12),
              const _FacultiesGrid(),
            ],
          ),
        ),
      ),
    );
  }
}

class _StudyTipCarouselCard extends StatelessWidget {
  const _StudyTipCarouselCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F2A24),
              Color(0xFF0A1814),
            ],
          ),
          border: Border.all(
            color: const Color(0xFF00FF88).withValues(alpha: 0.25),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '📌 Study Tip',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF00FF88),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFF00FF88).withValues(alpha: 0.2),
                  ),
                  child: Text(
                    'Study Tip',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF00FF88),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Text(
                'The Feynman Technique: explain a concept in simple words as if teaching a 12-year-old.',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  height: 1.45,
                  color: Colors.white.withValues(alpha: 0.92),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsCarouselCard extends StatelessWidget {
  const _StatsCarouselCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 12, 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2A1F4A),
              Color(0xFF151028),
            ],
          ),
          border: Border.all(
            color: const Color(0xFF7B61FF).withValues(alpha: 0.35),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bar_chart_rounded,
                    size: 18, color: const Color(0xFFB8A5FF)),
                const SizedBox(width: 6),
                Text(
                  'STATS',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    color: const Color(0xFFB8A5FF),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '3,200+ Students Study Here',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Join the fastest growing campus study network.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          height: 1.35,
                          color: Colors.white.withValues(alpha: 0.65),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xFF7B61FF).withValues(alpha: 0.45),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Join Now',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward_rounded,
                              size: 14, color: Colors.white),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DidYouKnowCarouselCard extends StatelessWidget {
  const _DidYouKnowCarouselCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xFF12182A),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Center(
          child: Text(
            'Your brain generates about 20 watts of electricity — enough to power a dim light bulb.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              height: 1.45,
              fontWeight: FontWeight.w500,
              color: Colors.white.withValues(alpha: 0.88),
            ),
          ),
        ),
      ),
    );
  }
}

class _CarouselDots extends StatelessWidget {
  const _CarouselDots({
    required this.count,
    required this.index,
    required this.activeColor,
  });

  final int count;
  final int index;
  final Color activeColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 18 : 6,
          height: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: active
                ? activeColor
                : Colors.white.withValues(alpha: 0.2),
          ),
        );
      }),
    );
  }
}

class _CampusStatsCard extends StatelessWidget {
  const _CampusStatsCard();

  @override
  Widget build(BuildContext context) {
    final divider = VerticalDivider(
      width: 1,
      thickness: 1,
      color: Colors.white.withValues(alpha: 0.08),
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF12182A),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _StatColumn(value: '6', label: 'Faculties'),
            ),
            divider,
            Expanded(
              child: _StatColumn(value: '11', label: 'Programs'),
            ),
            divider,
            Expanded(
              child: _StatColumn(value: '49', label: 'Materials'),
            ),
            divider,
            Expanded(
              child: _StatColumn(value: '3.2K', label: 'Students'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 11,
            color: Colors.white.withValues(alpha: 0.45),
          ),
        ),
      ],
    );
  }
}

class _PopularCourseTile extends StatelessWidget {
  const _PopularCourseTile({
    required this.code,
    required this.title,
    required this.views,
    required this.secondary,
  });

  final String code;
  final String title;
  final String views;
  final String secondary;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: const Color(0xFF12182A),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.06),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF00C4A7).withValues(alpha: 0.5),
                    width: 1.2,
                  ),
                  color: const Color(0xFF0F1F1C),
                ),
                child: Icon(
                  Icons.menu_book_outlined,
                  color: Colors.white.withValues(alpha: 0.35),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      code,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF00FF88),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '🔖 $views views   🔖 $secondary',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.45),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white.withValues(alpha: 0.35),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FacultiesGrid extends StatelessWidget {
  const _FacultiesGrid();

  static const _items = <_FacultyData>[
    _FacultyData(
      'Science',
      4,
      Color(0xFF0F2A28),
      Color(0xFF1A4D45),
      Icons.biotech_rounded,
      Color(0xFF2ED4A8),
    ),
    _FacultyData(
      'Arts & Humanities',
      3,
      Color(0xFF2A1518),
      Color(0xFF4A2028),
      Icons.palette_rounded,
      Color(0xFFFF6B7A),
    ),
    _FacultyData(
      'Engineering',
      5,
      Color(0xFF101A2E),
      Color(0xFF152545),
      Icons.precision_manufacturing_rounded,
      Color(0xFF5B8CFF),
    ),
    _FacultyData(
      'Law',
      2,
      Color(0xFF1A1530),
      Color(0xFF2A1F4A),
      Icons.balance_rounded,
      Color(0xFFB8A5FF),
    ),
    _FacultyData(
      'Business',
      4,
      Color(0xFF2A2210),
      Color(0xFF3D3015),
      Icons.business_center_rounded,
      Color(0xFFFFC857),
    ),
    _FacultyData(
      'Health Sciences',
      3,
      Color(0xFF2A1028),
      Color(0xFF401838),
      Icons.local_hospital_rounded,
      Color(0xFFFF6BB3),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemCount: _items.length,
      itemBuilder: (context, i) => _FacultyCard(data: _items[i]),
    );
  }
}

class _FacultyData {
  const _FacultyData(
    this.name,
    this.programs,
    this.bgTop,
    this.bgBottom,
    this.icon,
    this.iconColor,
  );

  final String name;
  final int programs;
  final Color bgTop;
  final Color bgBottom;
  final IconData icon;
  final Color iconColor;
}

class _FacultyCard extends StatelessWidget {
  const _FacultyCard({required this.data});

  final _FacultyData data;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [data.bgTop, data.bgBottom],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.06),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black.withValues(alpha: 0.25),
                ),
                child: Icon(data.icon, color: data.iconColor, size: 24),
              ),
              const Spacer(),
              Text(
                data.name,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${data.programs} programs',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.bottomRight,
                child: Icon(
                  Icons.bookmark_border_rounded,
                  size: 20,
                  color: Colors.white.withValues(alpha: 0.25),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
