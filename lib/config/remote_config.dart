/// IDs from your Google Sheet and Drive folders.
///
/// **Sheet:** share as "Anyone with the link can **view**" for public CSV sync,
/// or sign in with Google for private sheets (same account needs access).
///
/// **Drive materials folder:** share with people who upload (Editor), or use a
/// Google Cloud [OAuth client](https://console.cloud.google.com/apis/credentials)
/// and add SHA-1 (Android) / iOS URL scheme from the OAuth client JSON.
///
/// Sheet tab name: first tab should be `Materials` **or** rename [materialsSheetName].
class RemoteConfig {
  RemoteConfig._();

  /// From `https://docs.google.com/spreadsheets/d/THIS_PART/edit`
  static const spreadsheetId = '1EZ92eJeANJXIf5VUfjhn7whOQDk7U151';

  /// Folder for uploaded study files ([App project, UI](https://drive.google.com/drive/folders/1XLfYJOdY1dlvKI-sLdh0eXZIgsNFM9sy)).
  static const driveFolderMaterialsId =
      '1XLfYJOdY1dlvKI-sLdh0eXZIgsNFM9sy';

  /// Other app data ([Data](https://drive.google.com/drive/folders/15aML-4ffWywc4avSioBOd7nEah81Z9OT)).
  static const driveFolderDataId = '15aML-4ffWywc4avSioBOd7nEah81Z9OT';

  /// Tab name in the spreadsheet (row 1 = headers).
  static const materialsSheetName = 'Materials';

  /// A:F = unit_code, title, type, year, views, drive_link (extend if needed).
  static const materialsRange = 'Materials!A:F';

  /// Log other uploads: column A = file name, B = Drive link (create a **Data** tab).
  static const dataLogRange = 'Data!A:B';
}
