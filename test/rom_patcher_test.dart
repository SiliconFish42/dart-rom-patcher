import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:rom_patcher/rom_patcher.dart';

void main() {
  group('Patch Format Detection', () {
    test('detects IPS format', () {
      final patch = Uint8List.fromList([
        0x50, 0x41, 0x54, 0x43, 0x48, // "PATCH"
        0x00, 0x00, 0x00, // offset
        0x00, 0x00, // size
        0x45, 0x4F, 0x46, // "EOF"
      ]);

      expect(PatchUtils.detectFormat(patch), equals(PatchFormat.ips));
    });

    test('detects BPS format', () {
      final patch = Uint8List.fromList([
        0x42, 0x50, 0x53, 0x31, // "BPS1"
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      ]);

      expect(PatchUtils.detectFormat(patch), equals(PatchFormat.bps));
    });

    test('detects UPS format', () {
      final patch = Uint8List.fromList([
        0x55, 0x50, 0x53, 0x31, // "UPS1"
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      ]);

      expect(PatchUtils.detectFormat(patch), equals(PatchFormat.ups));
    });

    test('throws exception for unknown format', () {
      final patch = Uint8List.fromList([0x00, 0x00, 0x00, 0x00]);

      expect(
        () => PatchUtils.detectFormat(patch),
        throwsA(isA<PatchException>()),
      );
    });

    test('throws exception for too small patch', () {
      final patch = Uint8List.fromList([0x00, 0x00]);

      expect(
        () => PatchUtils.detectFormat(patch),
        throwsA(isA<PatchException>()),
      );
    });
  });

  group('Main API', () {
    test('applyPatch with auto-detection', () {
      final rom = Uint8List.fromList([0x00, 0x00, 0x00, 0x00, 0x00]);

      // Create a simple IPS patch
      final patch = Uint8List.fromList([
        0x50, 0x41, 0x54, 0x43, 0x48, // "PATCH"
        0x00, 0x00, 0x02, // offset 2
        0x00, 0x01, // size 1
        0xFF, // data
        0x45, 0x4F, 0x46, // "EOF"
      ]);

      final result = applyPatch(rom, patch);

      expect(result.length, equals(5));
      expect(result[2], equals(0xFF));
    });

    test('applyPatch with specified format', () {
      final rom = Uint8List.fromList([0x00, 0x00, 0x00, 0x00, 0x00]);

      // Create a simple IPS patch
      final patch = Uint8List.fromList([
        0x50, 0x41, 0x54, 0x43, 0x48, // "PATCH"
        0x00, 0x00, 0x02, // offset 2
        0x00, 0x01, // size 1
        0xFF, // data
        0x45, 0x4F, 0x46, // "EOF"
      ]);

      final result = applyPatch(rom, patch, format: PatchFormat.ips);

      expect(result.length, equals(5));
      expect(result[2], equals(0xFF));
    });
  });

  group('PatchUtils', () {
    test('validateHeader for IPS', () {
      final validPatch = Uint8List.fromList([0x50, 0x41, 0x54, 0x43, 0x48]);
      final invalidPatch = Uint8List.fromList([0x00, 0x00, 0x00, 0x00, 0x00]);

      expect(PatchUtils.validateHeader(validPatch, PatchFormat.ips), isTrue);
      expect(PatchUtils.validateHeader(invalidPatch, PatchFormat.ips), isFalse);
    });

    test('validateHeader for BPS', () {
      final validPatch = Uint8List.fromList([0x42, 0x50, 0x53, 0x31]);
      final invalidPatch = Uint8List.fromList([0x00, 0x00, 0x00, 0x00]);

      expect(PatchUtils.validateHeader(validPatch, PatchFormat.bps), isTrue);
      expect(PatchUtils.validateHeader(invalidPatch, PatchFormat.bps), isFalse);
    });

    test('validateHeader for UPS', () {
      final validPatch = Uint8List.fromList([0x55, 0x50, 0x53, 0x31]);
      final invalidPatch = Uint8List.fromList([0x00, 0x00, 0x00, 0x00]);

      expect(PatchUtils.validateHeader(validPatch, PatchFormat.ups), isTrue);
      expect(PatchUtils.validateHeader(invalidPatch, PatchFormat.ups), isFalse);
    });

    test('getMinimumSize', () {
      expect(PatchUtils.getMinimumSize(PatchFormat.ips), equals(8));
      expect(PatchUtils.getMinimumSize(PatchFormat.bps), equals(16));
      expect(PatchUtils.getMinimumSize(PatchFormat.ups), equals(16));
    });
  });

  group('PatchException', () {
    test('creates exception with message', () {
      final exception = PatchException(
        PatchErrorCode.invalidHeader,
        'Test message',
      );

      expect(exception.code, equals(PatchErrorCode.invalidHeader));
      expect(exception.message, equals('Test message'));
      expect(exception.details, isNull);
    });

    test('creates exception with details', () {
      final exception = PatchException(
        PatchErrorCode.checksumMismatch,
        'Test message',
        details: 'Additional details',
      );

      expect(exception.code, equals(PatchErrorCode.checksumMismatch));
      expect(exception.message, equals('Test message'));
      expect(exception.details, equals('Additional details'));
    });

    test('toString includes message and details', () {
      final exception = PatchException(
        PatchErrorCode.invalidHeader,
        'Test message',
        details: 'Additional details',
      );

      expect(exception.toString(), contains('Test message'));
      expect(exception.toString(), contains('Additional details'));
    });
  });
}
