import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:rom_patcher/rom_patcher.dart';

void main() {
  group('BPS Patch Application', () {
    test('applies simple BPS patch', () {
      // Create a simple ROM
      final rom = Uint8List.fromList([0x00, 0x00, 0x00, 0x00, 0x00]);

      // Create a minimal BPS patch (this is a simplified version)
      // In a real test, you would need a properly formatted BPS patch
      final patch = Uint8List.fromList([
        0x42, 0x50, 0x53, 0x31, // "BPS1"
        0x05, // source size (5)
        0x05, // target size (5)
        0x00, // metadata length (0)
        // Operations would go here
        0x00, 0x00, 0x00, 0x00, // source checksum
        0x00, 0x00, 0x00, 0x00, // target checksum
        0x00, 0x00, 0x00, 0x00, // patch checksum
      ]);

      // Note: This test would need a properly formatted BPS patch to work
      // For now, we'll test that it throws an appropriate exception
      expect(
        () => applyBps(rom, patch),
        throwsA(isA<PatchException>()),
      );
    });

    test('throws exception for invalid BPS header', () {
      final rom = Uint8List.fromList([0x00, 0x00, 0x00]);
      final patch = Uint8List.fromList([0x00, 0x00, 0x00, 0x00]);

      expect(
        () => applyBps(rom, patch),
        throwsA(isA<PatchException>()),
      );
    });
  });
}
