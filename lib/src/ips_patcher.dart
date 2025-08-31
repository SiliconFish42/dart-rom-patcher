import 'dart:typed_data';
import 'exceptions.dart';

/// IPS (International Patching System) patch format implementation.
///
/// IPS is a simple patch format that applies byte-level changes to ROM files.
/// It consists of:
/// - Header: "PATCH" (5 bytes)
/// - Records: Each record contains offset (3 bytes), size (2 bytes), and data
/// - Footer: "EOF" (3 bytes)
class IpsPatcher {
  static const int _headerSize = 5;
  static const int _footerSize = 3;
  static const int _recordHeaderSize = 5; // 3 bytes offset + 2 bytes size
  static const int _maxRecordSize = 65535; // 2^16 - 1

  /// Applies an IPS patch to a ROM.
  ///
  /// [rom] is the original ROM data.
  /// [patch] is the IPS patch data.
  ///
  /// Returns the patched ROM data.
  ///
  /// Throws [PatchException] if the patch is invalid or application fails.
  static Uint8List applyPatch(Uint8List rom, Uint8List patch) {
    if (patch.length < _headerSize + _footerSize) {
      throw const PatchException(
        PatchErrorCode.fileTooSmall,
        'IPS patch file is too small',
      );
    }

    // Validate header
    if (!_isValidHeader(patch)) {
      throw const PatchException(
        PatchErrorCode.invalidHeader,
        'Invalid IPS header',
      );
    }

    // Validate footer
    if (!_isValidFooter(patch)) {
      throw const PatchException(
        PatchErrorCode.corruptedPatch,
        'Invalid IPS footer',
      );
    }

    // Create a copy of the ROM to avoid modifying the original
    Uint8List result = Uint8List.fromList(rom);

    int offset = _headerSize;

    while (offset < patch.length - _footerSize) {
      if (offset + _recordHeaderSize > patch.length) {
        throw const PatchException(
          PatchErrorCode.truncatedPatch,
          'IPS patch is truncated',
        );
      }

      // Read record header
      final recordOffset = _read24Bit(patch, offset);
      final recordSize = _read16Bit(patch, offset + 3);
      offset += _recordHeaderSize;

      // Check for EOF marker (offset = 0x454F46 = "EOF")
      if (recordOffset == 0x454F46) {
        break;
      }

      // Validate record size
      if (recordSize > _maxRecordSize) {
        throw PatchException(
          PatchErrorCode.corruptedPatch,
          'IPS record size too large: $recordSize',
        );
      }

      // Handle RLE (Run Length Encoding) record
      if (recordSize == 0) {
        if (offset + 2 > patch.length) {
          throw const PatchException(
            PatchErrorCode.truncatedPatch,
            'IPS RLE record is truncated',
          );
        }

        final rleSize = _read16Bit(patch, offset);
        final rleValue = patch[offset + 2];
        offset += 3;

        // Apply RLE data
        result = _applyRleRecord(result, recordOffset, rleSize, rleValue);
      } else {
        // Handle normal data record
        if (offset + recordSize > patch.length) {
          throw const PatchException(
            PatchErrorCode.truncatedPatch,
            'IPS data record is truncated',
          );
        }

        // Ensure ROM is large enough
        if (recordOffset + recordSize > result.length) {
          // Extend ROM if necessary
          final newLength = recordOffset + recordSize;
          final extended = Uint8List(newLength);
          extended.setRange(0, result.length, result);
          result = extended;
        }

        // Apply data
        result.setRange(recordOffset, recordOffset + recordSize, patch, offset);
        offset += recordSize;
      }
    }

    return result;
  }

  /// Validates the IPS header.
  static bool _isValidHeader(Uint8List patch) {
    if (patch.length < _headerSize) return false;

    return patch[0] == 0x50 && // P
        patch[1] == 0x41 && // A
        patch[2] == 0x54 && // T
        patch[3] == 0x43 && // C
        patch[4] == 0x48; // H
  }

  /// Validates the IPS footer.
  static bool _isValidFooter(Uint8List patch) {
    if (patch.length < _footerSize) return false;

    final footerStart = patch.length - _footerSize;
    return patch[footerStart] == 0x45 && // E
        patch[footerStart + 1] == 0x4F && // O
        patch[footerStart + 2] == 0x46; // F
  }

  /// Reads a 24-bit big-endian integer from the patch.
  static int _read24Bit(Uint8List data, int offset) {
    return (data[offset] << 16) | (data[offset + 1] << 8) | data[offset + 2];
  }

  /// Reads a 16-bit big-endian integer from the patch.
  static int _read16Bit(Uint8List data, int offset) {
    return (data[offset] << 8) | data[offset + 1];
  }

  /// Applies an RLE (Run Length Encoding) record.
  static Uint8List _applyRleRecord(
      Uint8List rom, int offset, int size, int value) {
    // Ensure ROM is large enough
    if (offset + size > rom.length) {
      // Extend ROM if necessary
      final newLength = offset + size;
      final extended = Uint8List(newLength);
      extended.setRange(0, rom.length, rom);
      rom = extended;
    }

    // Fill with the repeated value
    for (int i = 0; i < size; i++) {
      rom[offset + i] = value;
    }

    return rom;
  }
}
