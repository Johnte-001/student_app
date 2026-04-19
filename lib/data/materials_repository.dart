import 'dart:typed_data';

import 'package:extension_google_sign_in_as_googleapis_auth/extension_google_sign_in_as_googleapis_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:http/http.dart' as http;

import '../config/remote_config.dart';
import '../models/library_doc.dart';
import 'sheet_csv_parser.dart';

/// Loads materials from Google Sheets and uploads files to Drive + appends rows.
class MaterialsRepository {
  MaterialsRepository({
    this.disableNetwork = false,
  });

  final bool disableNetwork;

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: const [
      'https://www.googleapis.com/auth/spreadsheets',
      'https://www.googleapis.com/auth/drive.file',
    ],
  );

  static final List<LibraryDoc> _fallback = [
    LibraryDoc(
      kind: LibraryDocKind.notes,
      code: 'COMS 111',
      title: 'Communication Skills',
      year: '2024',
      stat: '134',
    ),
    LibraryDoc(
      kind: LibraryDocKind.cat,
      code: 'BMED 212',
      title: 'Pathophysiology',
      year: '2025',
      stat: '267',
    ),
    LibraryDoc(
      kind: LibraryDocKind.exam,
      code: 'ECON 100',
      title: 'Introduction to Economics',
      year: '2024',
      stat: '321',
    ),
    LibraryDoc(
      kind: LibraryDocKind.notes,
      code: 'BMED 215',
      title: 'Biology of HIV/AIDS',
      year: '2025',
      stat: '145',
    ),
    LibraryDoc(
      kind: LibraryDocKind.exam,
      code: 'PHYS 120',
      title: 'General Physics',
      year: '2025',
      stat: '312',
    ),
    LibraryDoc(
      kind: LibraryDocKind.notes,
      code: 'CHEM 110',
      title: 'General Chemistry',
      year: '2024',
      stat: '198',
    ),
    LibraryDoc(
      kind: LibraryDocKind.cat,
      code: 'MATH 101',
      title: 'Calculus I',
      year: '2025',
      stat: '412',
    ),
    LibraryDoc(
      kind: LibraryDocKind.exam,
      code: 'STAT 200',
      title: 'Introduction to Statistics',
      year: '2024',
      stat: '289',
    ),
  ];

  /// Public CSV (no sign-in). Fails for private sheets → use [loadMaterials] fallback.
  Future<List<LibraryDoc>> fetchMaterialsPublicCsv() async {
    if (disableNetwork) return List.from(_fallback);
    final uri = SheetCsvParser.materialsExportUri();
    final res = await http.get(uri).timeout(const Duration(seconds: 12));
    if (res.statusCode != 200) {
      throw Exception('Sheet HTTP ${res.statusCode}');
    }
    final list = SheetCsvParser.parse(res.body);
    if (list.isEmpty) return List.from(_fallback);
    return list;
  }

  /// Tries public CSV; on any error returns embedded demo data so the app stays usable.
  Future<List<LibraryDoc>> loadMaterials() async {
    try {
      return await fetchMaterialsPublicCsv();
    } catch (_) {
      return List.from(_fallback);
    }
  }

  Future<GoogleSignInAccount?> signIn() => _googleSignIn.signIn();

  Future<void> signOut() => _googleSignIn.signOut();

  GoogleSignInAccount? get currentUser => _googleSignIn.currentUser;

  /// Upload bytes to the **materials** Drive folder, then append a row to the sheet.
  ///
  /// [extraFolderId] optional override (e.g. [RemoteConfig.driveFolderDataId] for other data).
  Future<String> uploadFileAndRegisterRow({
    required Uint8List bytes,
    required String fileName,
    required String unitCode,
    required String title,
    required LibraryDocKind kind,
    required String year,
    String? extraFolderId,
  }) async {
    var user = _googleSignIn.currentUser;
    user ??= await _googleSignIn.signIn();
    if (user == null) {
      throw Exception('Sign in cancelled');
    }

    final client = await _googleSignIn.authenticatedClient();
    if (client == null) {
      throw Exception('Could not obtain Google auth client');
    }

    try {
      final driveApi = ga.DriveApi(client);
      final folderId = extraFolderId ?? RemoteConfig.driveFolderMaterialsId;

      final media = ga.Media(
        Stream.value(List<int>.from(bytes)),
        bytes.length,
      );

      final file = ga.File()
        ..name = fileName
        ..parents = [folderId];

      final created = await driveApi.files.create(
        file,
        uploadMedia: media,
      );

      final id = created.id;
      final link = created.webViewLink ??
          created.webContentLink ??
          'https://drive.google.com/file/d/$id/view';

      final typeLabel = switch (kind) {
        LibraryDocKind.exam => 'EXAM',
        LibraryDocKind.cat => 'CAT',
        LibraryDocKind.notes => 'NOTES',
      };

      final sheetsApi = sheets.SheetsApi(client);
      final row = sheets.ValueRange(
        values: [
          [unitCode, title, typeLabel, year, '0', link],
        ],
      );

      await sheetsApi.spreadsheets.values.append(
        row,
        RemoteConfig.spreadsheetId,
        RemoteConfig.materialsRange,
        valueInputOption: 'USER_ENTERED',
        insertDataOption: 'INSERT_ROWS',
      );

      return link;
    } finally {
      client.close();
    }
  }

  /// Upload to the [RemoteConfig.driveFolderDataId] folder and append `file_name`, `link` on tab **Data**.
  Future<String> uploadOtherDataFile({
    required Uint8List bytes,
    required String fileName,
  }) async {
    var user = _googleSignIn.currentUser;
    user ??= await _googleSignIn.signIn();
    if (user == null) {
      throw Exception('Sign in cancelled');
    }

    final client = await _googleSignIn.authenticatedClient();
    if (client == null) {
      throw Exception('Could not obtain Google auth client');
    }

    try {
      final driveApi = ga.DriveApi(client);
      final media = ga.Media(
        Stream.value(List<int>.from(bytes)),
        bytes.length,
      );
      final file = ga.File()
        ..name = fileName
        ..parents = [RemoteConfig.driveFolderDataId];

      final created = await driveApi.files.create(
        file,
        uploadMedia: media,
      );

      final id = created.id;
      final link = created.webViewLink ??
          created.webContentLink ??
          'https://drive.google.com/file/d/$id/view';

      final sheetsApi = sheets.SheetsApi(client);
      final row = sheets.ValueRange(
        values: [
          [fileName, link],
        ],
      );

      await sheetsApi.spreadsheets.values.append(
        row,
        RemoteConfig.spreadsheetId,
        RemoteConfig.dataLogRange,
        valueInputOption: 'USER_ENTERED',
        insertDataOption: 'INSERT_ROWS',
      );

      return link;
    } finally {
      client.close();
    }
  }
}
