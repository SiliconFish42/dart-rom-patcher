import 'dart:typed_data';
import 'patch_format.dart';
import 'exceptions.dart';

/// Auto-detects the patch format from the file signature.
///
/// Returns the detected format or throws [PatchException] if detection fails.
PatchFormat detectPatchFormat(Uint8List patch) {
  if (patch.length < 5) {
    throw const PatchException(
      PatchErrorCode.fileTooSmall,
      'Patch file is too small to contain a valid header',
    );
  }

  // Check IPS signature: "PATCH"
  if (patch.length >= 5 &&
      patch[0] == 0x50 && // P
      patch[1] == 0x41 && // A
      patch[2] == 0x54 && // T
      patch[3] == 0x43 && // C
      patch[4] == 0x48) {
    // H
    return PatchFormat.ips;
  }

  // Check BPS signature: "BPS1"
  if (patch.length >= 4 &&
      patch[0] == 0x42 && // B
      patch[1] == 0x50 && // P
      patch[2] == 0x53 && // S
      patch[3] == 0x31) {
    // 1
    return PatchFormat.bps;
  }

  // Check UPS signature: "UPS1"
  if (patch.length >= 4 &&
      patch[0] == 0x55 && // U
      patch[1] == 0x50 && // P
      patch[2] == 0x53 && // S
      patch[3] == 0x31) {
    // 1
    return PatchFormat.ups;
  }

  throw const PatchException(
    PatchErrorCode.formatDetectionFailed,
    'Could not detect patch format from file signature',
  );
}
