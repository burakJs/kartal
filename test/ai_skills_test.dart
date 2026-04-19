import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Keeps `ai/**/*.md|mdc` from mentioning `context.*` members that do not exist
/// in the matching kartal `lib` source file.
void main() {
  test('AI skill docs reference context APIs present in lib sources', () {
    final repoRoot = Directory.current;
    final aiDir = Directory('${repoRoot.path}/ai');
    expect(aiDir.existsSync(), isTrue, reason: 'ai/ directory missing');

    final aiText = _collectTextFiles(aiDir);
    expect(aiText, isNotEmpty);

    const contextFiles = <String, String>{
      'padding': 'lib/src/private/sub_extension/context/context_padding_extension.dart',
      'sized': 'lib/src/private/sub_extension/context/context_size_extension.dart',
      'border': 'lib/src/private/sub_extension/context/context_border_extension.dart',
      'device': 'lib/src/private/sub_extension/context/context_device_extension.dart',
      'general': 'lib/src/private/sub_extension/context/context_general_extension.dart',
      'route': 'lib/src/private/sub_extension/context/context_navigator_extension.dart',
      'popupManager': 'lib/src/private/sub_extension/context/context_popup_extension.dart',
    };

    final contextMember = RegExp(
      r'context\.(padding|sized|border|device|general|popupManager|route)\.(\w+)',
    );

    final seen = <String>{};
    for (final match in contextMember.allMatches(aiText)) {
      final group = match.group(1)!;
      final member = match.group(2)!;
      final key = '$group.$member';
      if (!seen.add(key)) continue;

      final relativePath = contextFiles[group];
      expect(relativePath, isNotNull, reason: 'Unknown context group: $group');

      final file = File('${repoRoot.path}/$relativePath');
      expect(file.existsSync(), isTrue, reason: '$relativePath missing');
      final source = file.readAsStringSync();
      expect(
        _hasMemberDefinition(source, member),
        isTrue,
        reason: '$member missing in $relativePath',
      );
    }
  });

  test('AI skill docs reference other kartal symbols that exist under lib/', () {
    final repoRoot = Directory.current;
    final aiDir = Directory('${repoRoot.path}/ai');
    final aiText = _collectTextFiles(aiDir);

    final libDir = Directory('${repoRoot.path}/lib');
    final libCorpus = _collectDartFiles(libDir);

    const needles = <String>[
      'MapsUtility.openAppleMapsWithQuery',
      'openGoogleMapsWithQuery',
      'openGoogleWebMapsWithQuery',
      'getLinkPreviewData',
      'CustomLogger.showError',
      'BundleDecoder',
      'crackBundle',
      'IAssetModel',
      'DeviceUtility.instance',
      'HttpResult.fromStatusCode',
      'PopupManager',
      'showLoader',
      'hideLoader',
      'FutureExtension',
      'toBuild',
      'timeoutOrNull',
      'safeJsonEncodeCompute',
      'makeSafeCustom',
      'indexOrNull',
      'isNotNullOrNoEmpty',
      'StringValidatorMixin',
      'launchWebsiteCustom',
      'launchMaps',
      'SpaceSizedHeightBox',
      'SpaceSizedWidthBox',
    ];

    for (final needle in needles) {
      expect(
        aiText.contains(needle),
        isTrue,
        reason: 'Expected `$needle` to appear in ai/ docs so this test guards it',
      );
      expect(
        libCorpus.contains(needle),
        isTrue,
        reason: '`$needle` documented in ai/ but not found under lib/',
      );
    }
  });
}

String _collectTextFiles(Directory root) {
  final buffer = StringBuffer();
  if (!root.existsSync()) return buffer.toString();
  for (final entity in root.listSync(recursive: true, followLinks: false)) {
    if (entity is! File) continue;
    final path = entity.path;
    if (path.endsWith('.md') || path.endsWith('.mdc')) {
      buffer.writeln(entity.readAsStringSync());
    }
  }
  return buffer.toString();
}

String _collectDartFiles(Directory root) {
  final buffer = StringBuffer();
  if (!root.existsSync()) return buffer.toString();
  for (final entity in root.listSync(recursive: true, followLinks: false)) {
    if (entity is! File) continue;
    if (entity.path.endsWith('.dart')) {
      buffer.writeln(entity.readAsStringSync());
    }
  }
  return buffer.toString();
}

bool _hasMemberDefinition(String source, String member) {
  final escaped = RegExp.escape(member);
  // Getters: `Type get name` or `get name`
  if (RegExp(r'\bget\s+' + escaped + r'\b').hasMatch(source)) return true;
  // Methods may break generics across lines: `name<T>(` or `name(`.
  if (RegExp(r'\b' + escaped + r'\s*<').hasMatch(source)) return true;
  if (RegExp(r'\b' + escaped + r'\s*\(').hasMatch(source)) return true;
  return false;
}
