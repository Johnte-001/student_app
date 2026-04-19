import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Shared header: Study Smart + URL + actions (Explore, Library, etc.).
class StudySmartTopBar extends StatelessWidget {
  const StudySmartTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
          onPressed: () => Navigator.of(context).maybePop(),
          icon: Icon(
            Icons.close_rounded,
            color: Colors.white.withValues(alpha: 0.85),
          ),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 40),
          onPressed: () {},
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                'Study Smart',
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'aneway.replit.dev',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.share_outlined,
            color: Colors.white.withValues(alpha: 0.75),
            size: 22,
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.more_vert_rounded,
            color: Colors.white.withValues(alpha: 0.75),
            size: 22,
          ),
        ),
      ],
    );
  }
}
