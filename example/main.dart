import 'dart:typed_data';
import 'package:rom_patcher/rom_patcher.dart';

/// Example usage of the Dart ROM Patcher library.
void main() async {
  print('Dart ROM Patcher Example');
  print('=======================');

  // Create sample ROM data
  final romData = Uint8List.fromList([
    0x00,
    0x01,
    0x02,
    0x03,
    0x04,
    0x05,
    0x06,
    0x07,
    0x08,
    0x09,
    0x0A,
    0x0B,
    0x0C,
    0x0D,
    0x0E,
    0x0F,
  ]);

  print(
      'Original ROM data: ${romData.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}');

  // Example 1: Create and apply an IPS patch
  await _exampleIpsPatch(romData);

  // Example 2: Demonstrate format detection
  await _exampleFormatDetection();

  // Example 3: Demonstrate error handling
  await _exampleErrorHandling();
}

/// Example of creating and applying an IPS patch.
Future<void> _exampleIpsPatch(Uint8List romData) async {
  print('\n--- IPS Patch Example ---');

  // Create a simple IPS patch that changes some bytes
  final ipsPatch = Uint8List.fromList([
    0x50, 0x41, 0x54, 0x43, 0x48, // "PATCH"
    0x00, 0x00, 0x02, // offset 2
    0x00, 0x02, // size 2
    0xFF, 0xEE, // new data
    0x00, 0x00, 0x05, // offset 5
    0x00, 0x01, // size 1
    0xAA, // new data
    0x45, 0x4F, 0x46, // "EOF"
  ]);

  try {
    // Apply the patch
    final patchedRom = applyIps(romData, ipsPatch);

    print('IPS patch applied successfully!');
    print(
        'Patched ROM data: ${patchedRom.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}');

    // Verify the changes
    print('Byte 2 changed from 0x02 to 0x${patchedRom[2].toRadixString(16)}');
    print('Byte 3 changed from 0x03 to 0x${patchedRom[3].toRadixString(16)}');
    print('Byte 5 changed from 0x05 to 0x${patchedRom[5].toRadixString(16)}');
  } on PatchException catch (e) {
    print('IPS patch failed: ${e.message}');
  }
}

/// Example of format detection.
Future<void> _exampleFormatDetection() async {
  print('\n--- Format Detection Example ---');

  // Create patches for different formats
  final ipsPatch =
      Uint8List.fromList([0x50, 0x41, 0x54, 0x43, 0x48]); // "PATCH"
  final bpsPatch = Uint8List.fromList([0x42, 0x50, 0x53, 0x31]); // "BPS1"
  final upsPatch = Uint8List.fromList([0x55, 0x50, 0x53, 0x31]); // "UPS1"

  // Detect formats
  try {
    final ipsFormat = PatchUtils.detectFormat(ipsPatch);
    print('IPS patch detected: ${ipsFormat.name}');

    final bpsFormat = PatchUtils.detectFormat(bpsPatch);
    print('BPS patch detected: ${bpsFormat.name}');

    final upsFormat = PatchUtils.detectFormat(upsPatch);
    print('UPS patch detected: ${upsFormat.name}');
  } on PatchException catch (e) {
    print('Format detection failed: ${e.message}');
  }

  // Validate headers
  print('\nHeader validation:');
  print(
      'IPS header valid: ${PatchUtils.validateHeader(ipsPatch, PatchFormat.ips)}');
  print(
      'BPS header valid: ${PatchUtils.validateHeader(bpsPatch, PatchFormat.bps)}');
  print(
      'UPS header valid: ${PatchUtils.validateHeader(upsPatch, PatchFormat.ups)}');

  // Get minimum sizes
  print('\nMinimum patch sizes:');
  print('IPS: ${PatchUtils.getMinimumSize(PatchFormat.ips)} bytes');
  print('BPS: ${PatchUtils.getMinimumSize(PatchFormat.bps)} bytes');
  print('UPS: ${PatchUtils.getMinimumSize(PatchFormat.ups)} bytes');
}

/// Example of error handling.
Future<void> _exampleErrorHandling() async {
  print('\n--- Error Handling Example ---');

  final romData = Uint8List.fromList([0x00, 0x01, 0x02, 0x03]);

  // Test with invalid patch
  final invalidPatch = Uint8List.fromList([0x00, 0x00, 0x00, 0x00]);

  try {
    final result = applyPatch(romData, invalidPatch);
    print('Unexpected success: $result');
  } on PatchException catch (e) {
    print('Caught expected error:');
    print('  Code: ${e.code}');
    print('  Message: ${e.message}');
    if (e.details != null) {
      print('  Details: ${e.details}');
    }
  }

  // Test with too small patch
  final smallPatch = Uint8List.fromList([0x00, 0x00]);

  try {
    final result = applyPatch(romData, smallPatch);
    print('Unexpected success: $result');
  } on PatchException catch (e) {
    print('Caught expected error:');
    print('  Code: ${e.code}');
    print('  Message: ${e.message}');
  }
}
