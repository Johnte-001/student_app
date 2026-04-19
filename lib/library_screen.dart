import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'data/materials_repository.dart';
import 'models/library_doc.dart';
import 'widgets/study_smart_top_bar.dart';

/// Library tab: promos, search, browse/downloads, tips, chips, document grid.
class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key, required this.repository});

  final MaterialsRepository repository;

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  static const _bg = Color(0xFF0A0A1B);
  static const _mint = Color(0xFF00FF88);
  static const _purple = Color(0xFF8B5CFF);

  final PageController _promoController = PageController(viewportFraction: 0.94);
  final PageController _tipController = PageController(viewportFraction: 0.94);
  late final TextEditingController _searchController;

  int _promoPage = 0;
  int _tipPage = 0;
  int _browseMode = 0; // 0 Browse, 1 Downloads
  /// 0 = all docs, 1 = exams, 2 = CATs, 3 = notes
  int _chipFilter = 0;

  List<LibraryDoc> _loadedDocs = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController()
      ..addListener(() => setState(() {}));
    _refreshMaterials();
  }

  Future<void> _refreshMaterials() async {
    setState(() => _loading = true);
    final list = await widget.repository.loadMaterials();
    if (!mounted) return;
    setState(() {
      _loadedDocs = list;
      _loading = false;
    });
  }

  int _countKind(LibraryDocKind k) =>
      _loadedDocs.where((d) => d.kind == k).length;

  @override
  void dispose() {
    _searchController.dispose();
    _promoController.dispose();
    _tipController.dispose();
    super.dispose();
  }

  List<LibraryDoc> get _chipFiltered {
    switch (_chipFilter) {
      case 0:
        return _loadedDocs;
      case 1:
        return _loadedDocs.where((d) => d.kind == LibraryDocKind.exam).toList();
      case 2:
        return _loadedDocs.where((d) => d.kind == LibraryDocKind.cat).toList();
      case 3:
        return _loadedDocs.where((d) => d.kind == LibraryDocKind.notes).toList();
      default:
        return _loadedDocs;
    }
  }

  List<LibraryDoc> get _visibleDocs {
    final q = _searchController.text.trim().toLowerCase();
    final base = _chipFiltered;
    if (q.isEmpty) return base;
    return base
        .where(
          (d) =>
              d.code.toLowerCase().contains(q) ||
              d.title.toLowerCase().contains(q),
        )
        .toList();
  }

  int get _docCountLabel => _visibleDocs.length;

  Future<void> _openUploadSheet() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF12182A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _UploadMaterialSheet(
        repository: widget.repository,
        onDone: () {
          Navigator.pop(ctx);
          _refreshMaterials();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openUploadSheet,
        backgroundColor: _mint,
        foregroundColor: const Color(0xFF042814),
        icon: const Icon(Icons.cloud_upload_outlined),
        label: Text(
          'Upload',
          style: GoogleFonts.inter(fontWeight: FontWeight.w800),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 110),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const StudySmartTopBar(),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Library',
                          style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Your study collection.',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: _mint.withValues(alpha: 0.18),
                      border: Border.all(
                        color: _mint.withValues(alpha: 0.45),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.description_outlined,
                          size: 18,
                          color: _mint,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${_loadedDocs.length}',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: _mint,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 188,
                child: PageView(
                  controller: _promoController,
                  onPageChanged: (i) => setState(() => _promoPage = i),
                  children: const [
                    _PromoExamPrepCard(),
                    _PromoPlaceholderCard(
                      title: 'Spring Revision Bundle',
                      subtitle: 'Condensed notes + practice quizzes.',
                    ),
                    _PromoPlaceholderCard(
                      title: 'CAT Master Pack',
                      subtitle: 'Timed assessments with answer keys.',
                    ),
                    _PromoPlaceholderCard(
                      title: 'Faculty Spotlight',
                      subtitle: 'Curated picks from top performers.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _PromoDots(count: 4, index: _promoPage),
              const SizedBox(height: 20),
              _SearchBar(controller: _searchController),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _ModeButton(
                      label: 'Browse',
                      icon: Icons.folder_open_rounded,
                      active: _browseMode == 0,
                      filledAccent: true,
                      onTap: () => setState(() => _browseMode = 0),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ModeButton(
                      label: 'Downloads (4)',
                      icon: Icons.download_rounded,
                      active: _browseMode == 1,
                      filledAccent: false,
                      onTap: () => setState(() => _browseMode = 1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              SizedBox(
                height: 148,
                child: PageView(
                  controller: _tipController,
                  onPageChanged: (i) => setState(() => _tipPage = i),
                  children: const [
                    _TipSlide(
                      title: 'Active Recall Works Best',
                      body:
                          'Quiz yourself instead of re-reading — score 40% higher on retention tests.',
                    ),
                    _TipSlide(
                      title: 'Space Your Sessions',
                      body:
                          'Short daily reviews beat marathon cramming for long-term memory.',
                    ),
                    _TipSlide(
                      title: 'Teach It Back',
                      body:
                          'Explain topics out loud — gaps in your understanding show up instantly.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: _TipDots(count: 3, index: _tipPage),
              ),
              const SizedBox(height: 18),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      label: '${_loadedDocs.length} Docs',
                      color: _mint,
                      icon: Icons.folder_copy_outlined,
                      selected: _chipFilter == 0,
                      onTap: () => setState(() => _chipFilter = 0),
                    ),
                    const SizedBox(width: 10),
                    _FilterChip(
                      label: '${_countKind(LibraryDocKind.exam)} Exams',
                      color: _purple,
                      icon: Icons.edit_note_rounded,
                      selected: _chipFilter == 1,
                      onTap: () => setState(() => _chipFilter = 1),
                    ),
                    const SizedBox(width: 10),
                    _FilterChip(
                      label: '${_countKind(LibraryDocKind.cat)} CATs',
                      color: const Color(0xFFB87333),
                      icon: Icons.assignment_outlined,
                      selected: _chipFilter == 2,
                      onTap: () => setState(() => _chipFilter = 2),
                    ),
                    const SizedBox(width: 10),
                    _FilterChip(
                      label: '${_countKind(LibraryDocKind.notes)} Notes',
                      color: const Color(0xFF4B7BFF),
                      icon: Icons.description_outlined,
                      selected: _chipFilter == 3,
                      onTap: () => setState(() => _chipFilter = 3),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '$_docCountLabel documents',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withValues(alpha: 0.45),
                ),
              ),
              const SizedBox(height: 10),
              if (_loading)
                const Padding(
                  padding: EdgeInsets.all(40),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF00FF88),
                    ),
                  ),
                )
              else if (_visibleDocs.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    'No materials to show. Pull from Google Sheet or upload.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.45),
                    ),
                  ),
                )
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: _visibleDocs.length,
                  itemBuilder: (context, i) =>
                      _LibraryDocCard(doc: _visibleDocs[i]),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PromoExamPrepCard extends StatelessWidget {
  const _PromoExamPrepCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 14, 12, 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF3A1218),
              Color(0xFF12080A),
            ],
          ),
          border: Border.all(
            color: const Color(0xFFFF4B5C).withValues(alpha: 0.35),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: 4,
              top: 8,
              child: CustomPaint(
                size: const Size(96, 96),
                painter: _TargetPainter(),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black.withValues(alpha: 0.35),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.track_changes_rounded,
                        size: 14,
                        color: Colors.red.shade300,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'HOT',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.red.shade200,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Final Exam Prep Kit',
                  style: GoogleFonts.inter(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Past 5 years solved papers included',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.55),
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFFFF3B4A),
                        Colors.red.shade900.withValues(alpha: 0.85),
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.download_rounded,
                          size: 18, color: Colors.white),
                      const SizedBox(width: 6),
                      Text(
                        'Download',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PromoPlaceholderCard extends StatelessWidget {
  const _PromoPlaceholderCard({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [
              const Color(0xFF1A1528),
              const Color(0xFF0A0812),
            ],
          ),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.55),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TargetPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width * 0.45, size.height * 0.48);
    final rings = [0.42, 0.62, 0.82, 1.0];
    for (var i = 0; i < rings.length; i++) {
      final r = size.shortestSide * 0.38 * rings[i];
      canvas.drawCircle(
        center,
        r,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = i == 0 ? 2.5 : 1.5
          ..color = i == 0
              ? const Color(0xFF4DA3FF)
              : Colors.white.withValues(alpha: 0.25 + i * 0.08),
      );
    }
    canvas.drawCircle(
      center,
      5,
      Paint()..color = const Color(0xFFFFD447),
    );
    final dartEnd = Offset(center.dx - 28, center.dy - 22);
    canvas.drawLine(
      center,
      dartEnd,
      Paint()
        ..color = const Color(0xFF4DA3FF)
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(dartEnd, 4, Paint()..color = const Color(0xFF4DA3FF));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PromoDots extends StatelessWidget {
  const _PromoDots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 22 : 6,
          height: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: active
                ? const Color(0xFFFF3B4A)
                : Colors.white.withValues(alpha: 0.2),
          ),
        );
      }),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFF12182A),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            color: Colors.white.withValues(alpha: 0.4),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
              cursorColor: const Color(0xFF00FF88),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintText: 'Search unit code or title...',
                hintStyle: GoogleFonts.inter(
                  color: Colors.white.withValues(alpha: 0.35),
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  const _ModeButton({
    required this.label,
    required this.icon,
    required this.active,
    required this.filledAccent,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  /// Browse: true (solid mint when active). Downloads: false (border mint when active).
  final bool filledAccent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    const green = Color(0xFF00FF88);
    const darkOnGreen = Color(0xFF042814);

    final solidGreen = active && filledAccent;
    final outlinedGreen = active && !filledAccent;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: solidGreen ? green : const Color(0xFF12182A),
            border: Border.all(
              color: outlinedGreen
                  ? green.withValues(alpha: 0.55)
                  : Colors.white.withValues(alpha: 0.08),
              width: outlinedGreen ? 1.6 : 1,
            ),
            boxShadow: solidGreen
                ? [
                    BoxShadow(
                      color: green.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20,
                color: solidGreen
                    ? darkOnGreen
                    : outlinedGreen
                        ? green
                        : Colors.white.withValues(alpha: 0.45),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: solidGreen
                        ? darkOnGreen
                        : outlinedGreen
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.45),
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

class _TipSlide extends StatelessWidget {
  const _TipSlide({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 14, 12, 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F2A28),
              Color(0xFF0A1816),
            ],
          ),
          border: Border.all(
            color: const Color(0xFF00FF88).withValues(alpha: 0.22),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline_rounded,
                        size: 18,
                        color: const Color(0xFF00FF88),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'TIP',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                          color: const Color(0xFF00FF88),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      height: 1.35,
                      color: Colors.white.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFF00FF88).withValues(alpha: 0.22),
                    border: Border.all(
                      color: const Color(0xFF00FF88).withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Try It',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF00FF88),
                        ),
                      ),
                      const SizedBox(width: 2),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 14,
                        color: const Color(0xFF00FF88),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TipDots extends StatelessWidget {
  const _TipDots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 16 : 6,
          height: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: active
                ? const Color(0xFF00FF88)
                : Colors.white.withValues(alpha: 0.2),
          ),
        );
      }),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.color,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final Color color;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: selected ? color.withValues(alpha: 0.12) : const Color(0xFF12182A),
            border: Border.all(
              color: selected ? color : color.withValues(alpha: 0.45),
              width: selected ? 1.8 : 1.1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LibraryDocCard extends StatelessWidget {
  const _LibraryDocCard({required this.doc});

  final LibraryDoc doc;

  Color get _accent {
    switch (doc.kind) {
      case LibraryDocKind.exam:
        return const Color(0xFF2ED47A);
      case LibraryDocKind.notes:
        return const Color(0xFF8B5CFF);
      case LibraryDocKind.cat:
        return const Color(0xFFFF8A34);
    }
  }

  String get _typeLabel {
    switch (doc.kind) {
      case LibraryDocKind.exam:
        return 'EXAM';
      case LibraryDocKind.notes:
        return 'NOTES';
      case LibraryDocKind.cat:
        return 'CAT';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          final link = doc.driveLink;
          if (link == null || link.isEmpty) {
            if (!context.mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('No Drive link in sheet for this item.'),
              ),
            );
            return;
          }
          final uri = Uri.tryParse(link);
          if (uri == null) return;
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xFF12182A),
            border: Border.all(
              color: _accent.withValues(alpha: 0.15),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: _accent.withValues(alpha: 0.2),
                    ),
                    child: Text(
                      _typeLabel,
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: _accent,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.bookmark_border_rounded,
                    size: 18,
                    color: Colors.white.withValues(alpha: 0.25),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Center(
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: _accent.withValues(alpha: 0.12),
                        border: Border.all(
                          color: _accent.withValues(alpha: 0.25),
                        ),
                      ),
                      child: Icon(
                        Icons.insert_drive_file_outlined,
                        size: 36,
                        color: _accent.withValues(alpha: 0.55),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                doc.code,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: _accent,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                doc.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: const Color(0xFF2F6BFF).withValues(alpha: 0.25),
                    ),
                    child: Text(
                      doc.year,
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF8FB4FF),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.visibility_outlined,
                        size: 14,
                        color: Colors.white.withValues(alpha: 0.35),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        doc.stat,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.45),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UploadMaterialSheet extends StatefulWidget {
  const _UploadMaterialSheet({
    required this.repository,
    required this.onDone,
  });

  final MaterialsRepository repository;
  final VoidCallback onDone;

  @override
  State<_UploadMaterialSheet> createState() => _UploadMaterialSheetState();
}

class _UploadMaterialSheetState extends State<_UploadMaterialSheet> {
  final _unit = TextEditingController();
  final _title = TextEditingController();
  final _year = TextEditingController(text: '2025');
  LibraryDocKind _kind = LibraryDocKind.notes;
  bool _dataVault = false;
  Uint8List? _bytes;
  String? _pickedName;
  bool _busy = false;

  @override
  void dispose() {
    _unit.dispose();
    _title.dispose();
    _year.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final r = await FilePicker.platform.pickFiles(withData: true);
    if (r == null || r.files.isEmpty) return;
    final f = r.files.single;
    setState(() {
      _bytes = f.bytes;
      _pickedName = f.name;
    });
  }

  Future<void> _submit() async {
    if (_bytes == null || _pickedName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Choose a file first.')),
      );
      return;
    }
    if (!_dataVault) {
      if (_unit.text.trim().isEmpty || _title.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Unit code and title are required.')),
        );
        return;
      }
    }

    setState(() => _busy = true);
    try {
      if (_dataVault) {
        await widget.repository.uploadOtherDataFile(
          bytes: _bytes!,
          fileName: _pickedName!,
        );
      } else {
        await widget.repository.uploadFileAndRegisterRow(
          bytes: _bytes!,
          fileName: _pickedName!,
          unitCode: _unit.text.trim(),
          title: _title.text.trim(),
          kind: _kind,
          year: _year.text.trim(),
        );
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Uploaded and sheet updated.')),
      );
      widget.onDone();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: pad.bottom + 20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Upload material',
              style: GoogleFonts.inter(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Destination',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.white54,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Study materials'),
                    selected: !_dataVault,
                    onSelected: (v) {
                      if (v) setState(() => _dataVault = false);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Other data'),
                    selected: _dataVault,
                    onSelected: (v) {
                      if (v) setState(() => _dataVault = true);
                    },
                  ),
                ),
              ],
            ),
            if (!_dataVault) ...[
              const SizedBox(height: 12),
              TextField(
                controller: _unit,
                style: GoogleFonts.inter(color: Colors.white),
                decoration: _dec('Unit code (e.g. ECON 100)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _title,
                style: GoogleFonts.inter(color: Colors.white),
                decoration: _dec('Title'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _year,
                style: GoogleFonts.inter(color: Colors.white),
                decoration: _dec('Year'),
              ),
              const SizedBox(height: 10),
              InputDecorator(
                decoration: _dec('Type'),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<LibraryDocKind>(
                    value: _kind,
                    dropdownColor: const Color(0xFF1A2235),
                    style: GoogleFonts.inter(color: Colors.white),
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: LibraryDocKind.notes,
                        child: Text('NOTES'),
                      ),
                      DropdownMenuItem(
                        value: LibraryDocKind.exam,
                        child: Text('EXAM'),
                      ),
                      DropdownMenuItem(
                        value: LibraryDocKind.cat,
                        child: Text('CAT'),
                      ),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _kind = v);
                    },
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: _busy ? null : _pickFile,
              icon: const Icon(Icons.attach_file),
              label: Text(
                _pickedName ?? 'Pick file',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _busy ? null : _submit,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF00FF88),
                foregroundColor: const Color(0xFF042814),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: _busy
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(
                      'Upload & update sheet',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w800),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _dec(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(color: Colors.white38),
      filled: true,
      fillColor: const Color(0xFF0A0F18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
    );
  }
}
