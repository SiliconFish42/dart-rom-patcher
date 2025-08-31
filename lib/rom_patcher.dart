/// A Dart library for applying ROM patch files in IPS, BPS, and UPS formats.
///
/// This library provides functionality similar to the Floating IPS (FLIPS) program
/// and the Rom Patcher JS library, allowing you to apply patches to ROM files
/// in memory without requiring file system access.
///
/// Supported formats:
/// - IPS (International Patching System)
/// - BPS (Binary Patch System)
/// - UPS (Unified Patch System)
///
/// Example usage:
/// ```dart
/// import 'package:rom_patcher/rom_patcher.dart';
///
/// // Apply a patch with auto-detection
/// final patchedRom = applyPatch(originalRom, patchData);
///
/// // Apply a specific format
/// final patchedRom = applyIps(originalRom, ipsPatchData);
/// ```
library rom_patcher;

export 'src/rom_patcher.dart';
export 'src/exceptions.dart';
export 'src/patch_format.dart';
