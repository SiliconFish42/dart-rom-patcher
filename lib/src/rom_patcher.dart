import 'dart:typed_data';
import 'exceptions.dart';
import 'patch_format.dart';
import 'detection.dart';
import 'patchers/ips.dart';
import 'patchers/bps.dart';
import 'patchers/ups.dart';

/// Applies a patch to a ROM with automatic format detection.
///
/// [rom] is the original ROM data.
/// [patch] is the patch data.
/// [format] is the patch format. If null, the format will be auto-detected.
///
/// Returns the patched ROM data.
///
/// Throws [PatchException] if the patch is invalid or application fails.
Uint8List applyPatch(
  Uint8List rom,
  Uint8List patch, {
  PatchFormat? format,
}) {
  try {
    // Auto-detect format if not specified
    final detectedFormat = format ?? detectPatchFormat(patch);

    // Apply patch based on format
    switch (detectedFormat) {
      case PatchFormat.ips:
        return IpsPatcher.applyPatch(rom, patch);
      case PatchFormat.bps:
        return BpsPatcher.applyPatch(rom, patch);
      case PatchFormat.ups:
        return UpsPatcher.applyPatch(rom, patch);
    }
  } catch (e) {
    if (e is PatchException) {
      rethrow;
    }
    throw PatchException(
      PatchErrorCode.unexpectedError,
      'Unexpected error during patch application: $e',
    );
  }
}

/// Applies an IPS patch to a ROM.
///
/// [rom] is the original ROM data.
/// [patch] is the IPS patch data.
///
/// Returns the patched ROM data.
///
/// Throws [PatchException] if the patch is invalid or application fails.
Uint8List applyIps(Uint8List rom, Uint8List patch) {
  return IpsPatcher.applyPatch(rom, patch);
}

/// Applies a BPS patch to a ROM.
///
/// [rom] is the original ROM data.
/// [patch] is the BPS patch data.
///
/// Returns the patched ROM data.
///
/// Throws [PatchException] if the patch is invalid or application fails.
Uint8List applyBps(Uint8List rom, Uint8List patch) {
  return BpsPatcher.applyPatch(rom, patch);
}

/// Applies a UPS patch to a ROM.
///
/// [rom] is the original ROM data.
/// [patch] is the UPS patch data.
///
/// Returns the patched ROM data.
///
/// Throws [PatchException] if the patch is invalid or application fails.
Uint8List applyUps(Uint8List rom, Uint8List patch) {
  return UpsPatcher.applyPatch(rom, patch);
}

/// Utility functions for working with patch files.
class PatchUtils {
  /// Detects the format of a patch file.
  ///
  /// [patch] is the patch data.
  ///
  /// Returns the detected patch format.
  ///
  /// Throws [PatchException] if the format cannot be detected.
  static PatchFormat detectFormat(Uint8List patch) {
    return detectPatchFormat(patch);
  }

  /// Validates that a patch file has a valid header for the specified format.
  ///
  /// [patch] is the patch data.
  /// [format] is the expected patch format.
  ///
  /// Returns true if the header is valid, false otherwise.
  static bool validateHeader(Uint8List patch, PatchFormat format) {
    if (patch.length < 4) {
      return false;
    }

    final signature = format.signature;
    if (patch.length < signature.length) {
      return false;
    }

    for (int i = 0; i < signature.length; i++) {
      if (patch[i] != signature[i]) {
        return false;
      }
    }

    return true;
  }

  /// Gets the minimum size required for a valid patch file of the specified format.
  ///
  /// [format] is the patch format.
  ///
  /// Returns the minimum size in bytes.
  static int getMinimumSize(PatchFormat format) {
    switch (format) {
      case PatchFormat.ips:
        return 8; // Header (5) + Footer (3)
      case PatchFormat.bps:
        return 16; // Header (4) + Footer (12)
      case PatchFormat.ups:
        return 16; // Header (4) + Footer (12)
    }
  }
}
