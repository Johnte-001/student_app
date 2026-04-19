/// Material type stored in the Sheet `type` column (case-insensitive).
enum LibraryDocKind { exam, notes, cat }

class LibraryDoc {
  const LibraryDoc({
    required this.kind,
    required this.code,
    required this.title,
    required this.year,
    required this.stat,
    this.driveLink,
  });

  final LibraryDocKind kind;
  final String code;
  final String title;
  final String year;
  final String stat;
  final String? driveLink;

  static LibraryDocKind kindFromString(String raw) {
    final s = raw.trim().toUpperCase();
    if (s.contains('EXAM')) return LibraryDocKind.exam;
    if (s.contains('CAT')) return LibraryDocKind.cat;
    return LibraryDocKind.notes;
  }
}
