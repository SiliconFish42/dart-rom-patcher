import 'dart:typed_data';
import '../exceptions.dart';

/// BPS (Binary Patch System) patch format implementation.
///
/// BPS is a more advanced patch format that includes:
/// - Source and target file sizes
/// - CRC32 checksums for validation
/// - Variable-length encoding for offsets and sizes
/// - Multiple operation types (source read, target read, source copy, target copy)
class BpsPatcher {
  static const int _headerSize = 4; // "BPS1"
  static const int _footerSize = 12; // 3 CRC32 checksums

  /// Applies a BPS patch to a ROM.
  ///
  /// [rom] is the original ROM data.
  /// [patch] is the BPS patch data.
  ///
  /// Returns the patched ROM data.
  ///
  /// Throws [PatchException] if the patch is invalid or application fails.
  static Uint8List applyPatch(Uint8List rom, Uint8List patch) {
    if (patch.length < _headerSize + _footerSize) {
      throw const PatchException(
        PatchErrorCode.fileTooSmall,
        'BPS patch file is too small',
      );
    }

    // Validate header
    if (!_isValidHeader(patch)) {
      throw const PatchException(
        PatchErrorCode.invalidHeader,
        'Invalid BPS header',
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

    // Read metadata length
    final metadataLength = _readVlq(patch, offset);
    offset = metadataLength.offset;

    // Skip metadata
    offset += metadataLength.value;

    // Apply patch operations
    int sourceRelativeOffset = 0;
    int targetRelativeOffset = 0;

    while (offset < patch.length - _footerSize) {
      final operation = _readVlq(patch, offset);
      offset = operation.offset;

      final length = (operation.value >> 2) + 1;
      final type = operation.value & 3;

      switch (type) {
        case 0: // Source read
          _copyFromSource(
              rom, target, sourceRelativeOffset, targetRelativeOffset, length);
          sourceRelativeOffset += length;
          targetRelativeOffset += length;
          break;

        case 1: // Target read
          _copyFromTarget(target, targetRelativeOffset, length);
          targetRelativeOffset += length;
          break;

        case 2: // Source copy
          final data = _readVlq(patch, offset);
          offset = data.offset;
          final copyOffset = _decodeOffset(data.value);
          _copyFromSource(
              rom, target, copyOffset, targetRelativeOffset, length);
          targetRelativeOffset += length;
          break;

        case 3: // Target copy
          final data = _readVlq(patch, offset);
          offset = data.offset;
          final copyOffset = _decodeOffset(data.value);
          _copyFromTarget(target, targetRelativeOffset, length, copyOffset);
          targetRelativeOffset += length;
          break;
      }
    }

    // Validate checksums
    _validateChecksums(rom, target, patch);

    return target;
  }

  /// Validates the BPS header.
  static bool _isValidHeader(Uint8List patch) {
    if (patch.length < _headerSize) {
      return false;
    }

    return patch[0] == 0x42 && // B
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

  /// Decodes an offset from a VLQ value.
  static int _decodeOffset(int value) {
    return (value & 1) == 0 ? value >> 1 : -(value >> 1);
  }

  /// Copies data from source to target.
  static void _copyFromSource(
    Uint8List source,
    Uint8List target,
    int sourceOffset,
    int targetOffset,
    int length,
  ) {
    for (int i = 0; i < length; i++) {
      if (sourceOffset + i < source.length &&
          targetOffset + i < target.length) {
        target[targetOffset + i] = source[sourceOffset + i];
      }
    }
  }

  /// Copies data within target (for target read/copy operations).
  static void _copyFromTarget(
    Uint8List target,
    int targetOffset,
    int length, [
    int? copyOffset,
  ]) {
    if (copyOffset != null) {
      // Target copy: copy from another location in target
      for (int i = 0; i < length; i++) {
        if (copyOffset + i < target.length &&
            targetOffset + i < target.length) {
          target[targetOffset + i] = target[copyOffset + i];
        }
      }
    } else {
      // Target read: this is a placeholder for data that will be written later
      // In a real implementation, this would read from the patch data
      // For now, we'll leave the data as-is (zeros)
    }
  }

  /// Validates CRC32 checksums in the BPS footer.
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
