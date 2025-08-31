import 'dart:typed_data';
import 'dart:math' as math;
import '../exceptions.dart';

/// UPS (Unified Patch System) patch format implementation.
///
/// UPS is similar to BPS but with some differences:
/// - Uses XOR-based patching
/// - Includes source and target file sizes
/// - Has CRC32 checksums for validation
/// - Uses variable-length encoding for offsets and sizes
class UpsPatcher {
  static const int _headerSize = 4; // "UPS1"
  static const int _footerSize = 12; // 3 CRC32 checksums

  /// Applies a UPS patch to a ROM.
  ///
  /// [rom] is the original ROM data.
  /// [patch] is the UPS patch data.
  ///
  /// Returns the patched ROM data.
  ///
  /// Throws [PatchException] if the patch is invalid or application fails.
  static Uint8List applyPatch(Uint8List rom, Uint8List patch) {
    if (patch.length < _headerSize + _footerSize) {
      throw const PatchException(
        PatchErrorCode.fileTooSmall,
        'UPS patch file is too small',
      );
    }

    // Validate header
    if (!_isValidHeader(patch)) {
      throw const PatchException(
        PatchErrorCode.invalidHeader,
        'Invalid UPS header',
      );
    }

    int offset = _headerSize;

    // Read source and target file sizes
    final sourceSize = _readVlq(patch, offset);
    offset = sourceSize.offset;

    final targetSize = _readVlq(patch, offset);
    offset = targetSize.offset;

    // Validate source size matches ROM size
    if (sourceSize.value != rom.length) {
      throw PatchException(
        PatchErrorCode.romTooSmall,
        'Source size mismatch: expected ${sourceSize.value}, got ${rom.length}',
      );
    }

    // Create target ROM
    final target = Uint8List(targetSize.value);

    // Copy source to target first
    final copyLength = math.min(rom.length, target.length);
    target.setRange(0, copyLength, rom);

    // Apply patch operations
    int relativeOffset = 0;

    while (offset < patch.length - _footerSize) {
      final skip = _readVlq(patch, offset);
      offset = skip.offset;
      relativeOffset += skip.value;

      // Read XOR data until we hit a zero byte
      final xorData = <int>[];
      while (offset < patch.length - _footerSize) {
        final byte = patch[offset++];
        if (byte == 0) {
          break;
        }
        xorData.add(byte);
      }

      // Apply XOR data
      for (int i = 0; i < xorData.length; i++) {
        if (relativeOffset + i < target.length) {
          target[relativeOffset + i] ^= xorData[i];
        }
      }

      relativeOffset += xorData.length;
    }

    // Validate checksums
    _validateChecksums(rom, target, patch);

    return target;
  }

  /// Validates the UPS header.
  static bool _isValidHeader(Uint8List patch) {
    if (patch.length < _headerSize) {
      return false;
    }

    return patch[0] == 0x55 && // U
        patch[1] == 0x50 && // P
        patch[2] == 0x53 && // S
        patch[3] == 0x31; // 1
  }

  /// Reads a variable-length quantity (VLQ) from the patch.
  static ({int value, int offset}) _readVlq(Uint8List data, int offset) {
    int value = 0;
    int shift = 0;

    while (offset < data.length) {
      final byte = data[offset++];
      value |= (byte & 0x7F) << shift;

      if ((byte & 0x80) == 0) {
        break;
      }

      shift += 7;
    }

    return (value: value, offset: offset);
  }

  /// Validates CRC32 checksums in the UPS footer.
  static void _validateChecksums(
    Uint8List source,
    Uint8List target,
    Uint8List patch,
  ) {
    final footerStart = patch.length - _footerSize;

    // Read checksums from footer
    final sourceChecksum = _read32Bit(patch, footerStart);
    final targetChecksum = _read32Bit(patch, footerStart + 4);
    final patchChecksum = _read32Bit(patch, footerStart + 8);

    // Calculate actual checksums
    final actualSourceChecksum = _calculateCrc32(source);
    final actualTargetChecksum = _calculateCrc32(target);
    final actualPatchChecksum = _calculateCrc32(
      patch.sublist(0, patch.length - 4),
    );

    // Validate checksums
    if (sourceChecksum != actualSourceChecksum) {
      throw PatchException(
        PatchErrorCode.checksumMismatch,
        'Source checksum mismatch: expected ${sourceChecksum.toRadixString(16)}, got ${actualSourceChecksum.toRadixString(16)}',
      );
    }

    if (targetChecksum != actualTargetChecksum) {
      throw PatchException(
        PatchErrorCode.checksumMismatch,
        'Target checksum mismatch: expected ${targetChecksum.toRadixString(16)}, got ${actualTargetChecksum.toRadixString(16)}',
      );
    }

    if (patchChecksum != actualPatchChecksum) {
      throw PatchException(
        PatchErrorCode.checksumMismatch,
        'Patch checksum mismatch: expected ${patchChecksum.toRadixString(16)}, got ${actualPatchChecksum.toRadixString(16)}',
      );
    }
  }

  /// Reads a 32-bit little-endian integer from the patch.
  static int _read32Bit(Uint8List data, int offset) {
    return data[offset] |
        (data[offset + 1] << 8) |
        (data[offset + 2] << 16) |
        (data[offset + 3] << 24);
  }

  /// Calculates CRC32 checksum for the given data.
  static int _calculateCrc32(Uint8List data) {
    // Simple CRC32 implementation
    const int polynomial = 0xEDB88320;
    int crc = 0xFFFFFFFF;

    for (final byte in data) {
      crc ^= byte;
      for (int i = 0; i < 8; i++) {
        if ((crc & 1) != 0) {
          crc = (crc >> 1) ^ polynomial;
        } else {
          crc >>= 1;
        }
      }
    }

    return crc ^ 0xFFFFFFFF;
  }
}
