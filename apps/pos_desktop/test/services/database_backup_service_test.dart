import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_desktop/services/database_backup_service.dart';
import 'package:path/path.dart' as p;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('ritagestion_backup_test');
    
    // Mock getApplicationDocumentsDirectory via Channel
    const channel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        if (methodCall.method == 'getApplicationDocumentsDirectory') {
          return tempDir.path;
        }
        return null;
      },
    );
  });

  tearDown(() async {
    const channel = MethodChannel('plugins.flutter.io/path_provider');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      null,
    );
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('performBackup fails if source database file does not exist', () async {
    final result = await DatabaseBackupService.instance.performBackup();
    expect(result, isNull);
  });

  test('performBackup copies database file to backup directory with timestamp', () async {
    // Create mock source database file
    final srcPath = p.join(tempDir.path, 'ritagestion.db');
    final srcFile = File(srcPath);
    await srcFile.writeAsString('mock sqlite database content');

    final result = await DatabaseBackupService.instance.performBackup();
    expect(result, isNotNull);
    
    final backupFile = File(result!);
    expect(await backupFile.exists(), isTrue);
    expect(await backupFile.readAsString(), equals('mock sqlite database content'));

    // Check directory name and filename structure
    expect(p.basename(p.dirname(result)), equals('Backups'));
    expect(p.basename(p.dirname(p.dirname(result))), equals('Ritagestion'));
    expect(p.basename(result), startsWith('backup_'));
    expect(p.basename(result), endsWith('.db'));
  });
}
