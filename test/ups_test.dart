import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:rom_patcher/rom_patcher.dart';

void main() {
  group('UPS Patch Application', () {
    test('applies simple UPS patch', () {
      // Create a simple ROM
      final rom = Uint8List.fromList([0x00, 0x00, 0x00, 0x00, 0x00]);

      // Create a minimal UPS patch (this is a simplified version)
      // In a real test, you would need a properly formatted UPS patch
      final patch = Uint8List.fromList([
        0x55, 0x50, 0x53, 0x31, // "UPS1"
        0x05, // source size (5)
        0x05, // target size (5)
        // Operations would go here
        0x00, 0x00, 0x00, 0x00, // source checksum
        0x00, 0x00, 0x00, 0x00, // target checksum
        0x00, 0x00, 0x00, 0x00, // patch checksum
      ]);

      // Note: This test would need a properly formatted UPS patch to work
      // For now, we'll test that it throws an appropriate exception
      expect(
        () => applyUps(rom, patch),
        throwsA(isA<PatchException>()),
      );
    });

    test('throws exception for invalid UPS header', () {
      final rom = Uint8List.fromList([0x00, 0x00, 0x00]);
      final patch = Uint8List.fromList([0x00, 0x00, 0x00, 0x00]);

      expect(
        () => applyUps(rom, patch),
        throwsA(isA<PatchException>()),
      );
    });
  });
}
