# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2024-01-XX

### Added

- Initial release of ROM Patcher library
- Support for IPS (International Patching System) patch format
- Support for BPS (Binary Patch System) patch format  
- Support for UPS (Unified Patch System) patch format
- Auto-detection of patch format from file signature
- Memory-based patch application (no file system required)
- Comprehensive error handling with descriptive error codes
- CRC32 checksum validation for BPS and UPS formats
- ROM size extension support for IPS patches
- Run Length Encoding (RLE) support for IPS patches
- Variable-length encoding support for BPS and UPS patches
- Comprehensive unit tests for all patch formats
- Example usage code and documentation
- Utility functions for patch validation and format detection

### Features

- `applyPatch()` - Main entry point with auto-detection
- `applyIps()` - Apply IPS patches
- `applyBps()` - Apply BPS patches  
- `applyUps()` - Apply UPS patches
- `PatchUtils.detectFormat()` - Auto-detect patch format
- `PatchUtils.validateHeader()` - Validate patch headers
- `PatchUtils.getMinimumSize()` - Get minimum patch size
- `PatchException` - Comprehensive error handling
- `PatchFormat` enum - Supported patch formats
- `PatchErrorCode` enum - Error codes for different failure types