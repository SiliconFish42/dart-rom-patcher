import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:rom_patcher/rom_patcher.dart';

void main() {
  group('IPS Patch Application', () {
    test('applies simple IPS patch', () {
      // Create a simple ROM
      final rom = Uint8List.fromList([0x00, 0x00, 0x00, 0x00, 0x00]);

      // Create a simple IPS patch that changes byte 2 to 0xFF
      final patch = Uint8List.fromList([
        0x50, 0x41, 0x54, 0x43, 0x48, // "PATCH"
        0x00, 0x00, 0x02, // offset 2
        0x00, 0x01, // size 1
        0xFF, // data
        0x45, 0x4F, 0x46, // "EOF"
      ]);

      final result = applyIps(rom, patch);

      expect(result.length, equals(5));
      expect(result[2], equals(0xFF));
      expect(result[0], equals(0x00));
      expect(result[1], equals(0x00));
      expect(result[3], equals(0x00));
      expect(result[4], equals(0x00));
    });

    test('applies IPS patch with RLE', () {
      // Create a simple ROM
      final rom = Uint8List.fromList([0x00, 0x00, 0x00, 0x00, 0x00]);

      // Create an IPS patch with RLE that fills 3 bytes with 0xAA
      final patch = Uint8List.fromList([
        0x50, 0x41, 0x54, 0x43, 0x48, // "PATCH"
        0x00, 0x00, 0x01, // offset 1
        0x00, 0x00, // size 0 (RLE)
        0x00, 0x03, // RLE size 3
        0xAA, // RLE value
        0x45, 0x4F, 0x46, // "EOF"
      ]);

      final result = applyIps(rom, patch);

      expect(result.length, equals(5));
      expect(result[1], equals(0xAA));
      expect(result[2], equals(0xAA));
      expect(result[3], equals(0xAA));
    });

    test('extends ROM size when needed', () {
      // Create a small ROM
      final rom = Uint8List.fromList([0x00, 0x00]);

      // Create an IPS patch that writes beyond the ROM size
      final patch = Uint8List.fromList([
        0x50, 0x41, 0x54, 0x43, 0x48, // "PATCH"
        0x00, 0x00, 0x05, // offset 5
        0x00, 0x02, // size 2
        0xFF, 0xEE, // data
        0x45, 0x4F, 0x46, // "EOF"
      ]);

      final result = applyIps(rom, patch);

      expect(result.length, equals(7));
      expect(result[5], equals(0xFF));
      expect(result[6], equals(0xEE));
    });

    test('throws exception for invalid IPS header', () {
      final rom = Uint8List.fromList([0x00, 0x00, 0x00]);
      final patch = Uint8List.fromList([0x00, 0x00, 0x00, 0x00, 0x00]);

      expect(
        () => applyIps(rom, patch),
        throwsA(isA<PatchException>()),
      );
    });

    test('throws exception for invalid IPS footer', () {
      final rom = Uint8List.fromList([0x00, 0x00, 0x00]);
      final patch = Uint8List.fromList([
        0x50, 0x41, 0x54, 0x43, 0x48, // "PATCH"
        0x00, 0x00, 0x00, // offset
        0x00, 0x00, // size
        0x00, 0x00, 0x00, // invalid footer
      ]);

      expect(
        () => applyIps(rom, patch),
        throwsA(isA<PatchException>()),
      );
    });
  });
}
