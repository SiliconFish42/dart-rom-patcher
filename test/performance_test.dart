import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:rom_patcher/rom_patcher.dart';

void main() {
  group('Performance Tests', () {
    test('should handle large ROMs efficiently', () {
      // Create a large ROM (10MB) - typical size for SNES games
      final largeRom = Uint8List(10 * 1024 * 1024);

      // Fill with some pattern data
      for (int i = 0; i < largeRom.length; i++) {
        largeRom[i] = i % 256;
      }

      // Create a simple IPS patch that modifies a small portion
      final patch = Uint8List.fromList([
        0x50, 0x41, 0x54, 0x43, 0x48, // "PATCH"
        0x00, 0x10, 0x00, // offset 0x1000 (4KB into the ROM)
        0x00, 0x10, // size 16 bytes
        0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, // 8 bytes of 0xFF
        0xAA, 0xAA, 0xAA, 0xAA, 0xAA, 0xAA, 0xAA, 0xAA, // 8 bytes of 0xAA
        0x45, 0x4F, 0x46, // "EOF"
      ]);

      final stopwatch = Stopwatch()..start();

      // Apply the patch
      final result = applyPatch(largeRom, patch);

      stopwatch.stop();

      // Verify the patch was applied correctly
      expect(result.length, equals(largeRom.length));
      expect(result[0x1000], equals(0xFF));
      expect(result[0x1007], equals(0xFF));
      expect(result[0x1008], equals(0xAA));
      expect(result[0x100F], equals(0xAA));

      // Verify original data is preserved
      expect(result[0x0FFF], equals(0xFF)); // Original data
      expect(result[0x1010], equals(0x10)); // Original data

      // Performance assertion: should complete within 5 seconds
      expect(stopwatch.elapsedMilliseconds, lessThan(5000),
          reason:
              'Large ROM patch application took ${stopwatch.elapsedMilliseconds}ms, expected < 5000ms');

      print(
          'Large ROM patch application completed in ${stopwatch.elapsedMilliseconds}ms');
    }, tags: ['performance']);

    test('should handle multiple small patches efficiently', () {
      // Create a medium-sized ROM (1MB)
      final rom = Uint8List(1024 * 1024);

      // Fill with pattern data
      for (int i = 0; i < rom.length; i++) {
        rom[i] = i % 256;
      }

      // Create multiple small IPS patches
      final patches = <Uint8List>[];
      for (int i = 0; i < 10; i++) {
        final offset = i * 0x1000; // 4KB intervals
        final patch = Uint8List.fromList([
          0x50, 0x41, 0x54, 0x43, 0x48, // "PATCH"
          (offset >> 16) & 0xFF, (offset >> 8) & 0xFF, offset & 0xFF, // offset
          0x00, 0x01, // size 1 byte
          (i + 1) & 0xFF, // data
          0x45, 0x4F, 0x46, // "EOF"
        ]);
        patches.add(patch);
      }

      final stopwatch = Stopwatch()..start();

      // Apply all patches sequentially
      Uint8List result = rom;
      for (final patch in patches) {
        result = applyPatch(result, patch);
      }

      stopwatch.stop();

      // Verify all patches were applied
      for (int i = 0; i < 10; i++) {
        final offset = i * 0x1000;
        expect(result[offset], equals((i + 1) & 0xFF));
      }

      // Performance assertion: should complete within 2 seconds
      expect(stopwatch.elapsedMilliseconds, lessThan(2000),
          reason:
              'Multiple patch application took ${stopwatch.elapsedMilliseconds}ms, expected < 2000ms');

      print(
          'Multiple patch application completed in ${stopwatch.elapsedMilliseconds}ms');
    }, tags: ['performance']);

    test('should handle memory efficiently with large patches', () {
      // Create a ROM with some data
      final rom = Uint8List(1024 * 1024); // 1MB ROM
      for (int i = 0; i < rom.length; i++) {
        rom[i] = i % 256;
      }

      // Create a patch that modifies a large portion of the ROM (10KB)
      final largePatchData = Uint8List(0x2800); // 10KB of patch data
      for (int i = 0; i < largePatchData.length; i++) {
        largePatchData[i] = (i * 2) % 256;
      }

      // Build the patch correctly
      final patchBytes = <int>[
        0x50, 0x41, 0x54, 0x43, 0x48, // "PATCH"
        0x00, 0x00, 0x00, // offset 0
        (largePatchData.length >> 8) & 0xFF,
        largePatchData.length & 0xFF, // size
        ...largePatchData,
        0x45, 0x4F, 0x46, // "EOF"
      ];

      final patch = Uint8List.fromList(patchBytes);

      final stopwatch = Stopwatch()..start();

      // Apply the large patch
      final result = applyPatch(rom, patch);

      stopwatch.stop();

      // Verify the patch was applied correctly
      expect(result.length, equals(rom.length));
      for (int i = 0; i < largePatchData.length; i++) {
        expect(result[i], equals(largePatchData[i]));
      }

      // Performance assertion: should complete within 3 seconds
      expect(stopwatch.elapsedMilliseconds, lessThan(3000),
          reason:
              'Large patch application took ${stopwatch.elapsedMilliseconds}ms, expected < 3000ms');

      print(
          'Large patch application completed in ${stopwatch.elapsedMilliseconds}ms');
    }, tags: ['performance']);

    test('should handle format detection efficiently', () {
      // Create a large number of patches for format detection
      final patches = <Uint8List>[];

      // Generate 1000 patches of different formats
      for (int i = 0; i < 1000; i++) {
        final format = i % 3;
        Uint8List patch;

        switch (format) {
          case 0: // IPS
            patch = Uint8List.fromList([
              0x50, 0x41, 0x54, 0x43, 0x48, // "PATCH"
              0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
              0x00,
            ]);
            break;
          case 1: // BPS
            patch = Uint8List.fromList([
              0x42, 0x50, 0x53, 0x31, // "BPS1"
              0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
              0x00,
            ]);
            break;
          case 2: // UPS
            patch = Uint8List.fromList([
              0x55, 0x50, 0x53, 0x31, // "UPS1"
              0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
              0x00,
            ]);
            break;
          default:
            patch = Uint8List.fromList([0x00, 0x00, 0x00, 0x00]);
        }
        patches.add(patch);
      }

      final stopwatch = Stopwatch()..start();

      // Detect formats for all patches
      final detectedFormats = <PatchFormat>[];
      for (final patch in patches) {
        try {
          final format = PatchUtils.detectFormat(patch);
          detectedFormats.add(format);
        } catch (e) {
          // Some patches might be invalid, that's expected
        }
      }

      stopwatch.stop();

      // Verify we detected some formats
      expect(detectedFormats.length, greaterThan(0));

      // Performance assertion: should complete within 1 second
      expect(stopwatch.elapsedMilliseconds, lessThan(1000),
          reason:
              'Format detection took ${stopwatch.elapsedMilliseconds}ms, expected < 1000ms');

      print(
          'Format detection for 1000 patches completed in ${stopwatch.elapsedMilliseconds}ms');
    }, tags: ['performance']);
  });
}
