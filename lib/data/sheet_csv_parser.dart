import 'package:csv/csv.dart';

import '../config/remote_config.dart';
import '../models/library_doc.dart';

/// Parses the materials sheet CSV into [LibraryDoc] rows.
///
/// **Expected header row** (any order; matched by name):
/// `unit_code`, `title`, `type`, `year`, `views`, `drive_link`
///
/// If headers are missing, falls back to columns A–F in order above.
class SheetCsvParser {
  SheetCsvParser._();

  static List<LibraryDoc> parse(String csvText) {
    final rows = const CsvToListConverter(
      shouldParseNumbers: false,
    ).convert(csvText);
    if (rows.isEmpty) return [];

    final header = rows.first.map((c) => c.toString().trim().toLowerCase()).toList();

    int col(String key) {
      final i = header.indexWhere(
        (h) => h.replaceAll(' ', '_') == key || h.contains(key),
      );
      return i;
    }

    var iUnit = col('unit');
    var iTitle = col('title');
    var iType = col('type');
    var iYear = col('year');
    var iViews = col('views');
    var iLink = col('drive');

    if (iUnit < 0) iUnit = 0;
    if (iTitle < 0) iTitle = 1;
    if (iType < 0) iType = 2;
    if (iYear < 0) iYear = 3;
    if (iViews < 0) iViews = 4;
    if (iLink < 0) iLink = 5;

    final maxIdx = [iUnit, iTitle, iType, iYear, iViews, iLink].reduce(
      (a, b) => a > b ? a : b,
    );

    final out = <LibraryDoc>[];
    for (var r = 1; r < rows.length; r++) {
      final row = rows[r];
      if (row.length <= maxIdx) continue;
      String cell(int i) =>
          i < row.length ? row[i].toString().trim() : '';

      final unit = cell(iUnit);
      final title = cell(iTitle);
      if (unit.isEmpty && title.isEmpty) continue;

      final typeStr = cell(iType);
      final link = cell(iLink);
      out.add(
        LibraryDoc(
          kind: LibraryDoc.kindFromString(typeStr.isEmpty ? 'NOTES' : typeStr),
          code: unit.isEmpty ? '—' : unit,
          title: title.isEmpty ? unit : title,
          year: cell(iYear).isEmpty ? '—' : cell(iYear),
          stat: cell(iViews).isEmpty ? '0' : cell(iViews),
          driveLink: link.isEmpty ? null : link,
        ),
      );
    }
    return out;
  }

  /// CSV export URL (works when sheet is viewable by link without login).
  static Uri materialsExportUri() {
    final id = RemoteConfig.spreadsheetId;
    final sheet = Uri.encodeQueryComponent(RemoteConfig.materialsSheetName);
    return Uri.parse(
      'https://docs.google.com/spreadsheets/d/$id/gviz/tq?tqx=out:csv&sheet=$sheet',
    );
  }
}
