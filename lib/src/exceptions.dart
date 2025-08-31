/// Exception thrown when patch operations fail.
class PatchException implements Exception {
  /// The error code that identifies the type of error.
  final PatchErrorCode code;

  /// A human-readable error message.
  final String message;

  /// Optional additional context about the error.
  final String? details;

  const PatchException(
    this.code,
    this.message, {
    this.details,
  });

  @override
  String toString() {
    final buffer = StringBuffer('PatchException: $message');
    if (details != null) {
      buffer.write(' ($details)');
    }
    return buffer.toString();
  }
}

/// Error codes for different types of patch operation failures.
enum PatchErrorCode {
  /// The patch file header is invalid or unrecognized.
  invalidHeader,

  /// The patch file is too small to contain valid data.
  fileTooSmall,

  /// A checksum or hash validation failed.
  checksumMismatch,

  /// The patch format is not supported.
  unsupportedFormat,

  /// The ROM file is too small for the patch.
  romTooSmall,

  /// The patch file is corrupted or contains invalid data.
  corruptedPatch,

  /// An unexpected error occurred during patch application.
  unexpectedError,

  /// The patch file is truncated or incomplete.
  truncatedPatch,

  /// The patch contains invalid offset or size data.
  invalidOffset,

  /// The patch format could not be auto-detected.
  formatDetectionFailed,
}
