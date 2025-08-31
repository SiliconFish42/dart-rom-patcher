/// Supported patch formats.
enum PatchFormat {
  /// IPS (International Patching System) format.
  ips,

  /// BPS (Binary Patch System) format.
  bps,

  /// UPS (Unified Patch System) format.
  ups,
}

/// Extension methods for PatchFormat enum.
extension PatchFormatExtension on PatchFormat {
  /// The file signature/magic bytes for this format.
  List<int> get signature {
    switch (this) {
      case PatchFormat.ips:
        return [0x50, 0x41, 0x54, 0x43, 0x48]; // "PATCH"
      case PatchFormat.bps:
        return [0x42, 0x50, 0x53, 0x31]; // "BPS1"
      case PatchFormat.ups:
        return [0x55, 0x50, 0x53, 0x31]; // "UPS1"
    }
  }

  /// The name of this format.
  String get name {
    switch (this) {
      case PatchFormat.ips:
        return 'IPS';
      case PatchFormat.bps:
        return 'BPS';
      case PatchFormat.ups:
        return 'UPS';
    }
  }
}
