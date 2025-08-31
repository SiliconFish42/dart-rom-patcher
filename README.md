# ROM Patcher

A Dart library for applying ROM patch files in IPS, BPS, and UPS formats. This library provides functionality similar to the Floating IPS (FLIPS) program and the Rom Patcher JS library, allowing you to apply patches to ROM files in memory without requiring file system access.

## Features

- **Multiple Patch Formats**: Support for IPS, BPS, and UPS patch formats
- **Auto-Detection**: Automatically detects patch format from file signature
- **Memory-Based**: Works with in-memory `Uint8List` objects, no file system required
- **Validation**: Comprehensive checksum and format validation
- **Performance**: Optimized for large ROMs (up to hundreds of MB)
- **Error Handling**: Descriptive error messages with specific error codes

## Supported Formats

### IPS (International Patching System)

- Simple byte-level patching
- Run Length Encoding (RLE) support
- ROM size extension support
- File signature: "PATCH"

### BPS (Binary Patch System)

- Advanced patching with multiple operation types
- CRC32 checksum validation
- Variable-length encoding for efficient storage
- File signature: "BPS1"

### UPS (Unified Patch System)

- XOR-based patching
- CRC32 checksum validation
- Variable-length encoding
- File signature: "UPS1"

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  rom_patcher: ^0.1.0
```

Then run:

```bash
dart pub get
```

## Usage

### Basic Usage

```dart
import 'package:rom_patcher/rom_patcher.dart';

// Load your ROM and patch data
final romData = await File('original.sfc').readAsBytes();
final patchData = await File('patch.ips').readAsBytes();

// Apply patch with auto-detection
final patchedRom = applyPatch(romData, patchData);

// Save the patched ROM
await File('patched.sfc').writeAsBytes(patchedRom);
```

### Format-Specific Usage

```dart
import 'package:rom_patcher/rom_patcher.dart';

// Apply IPS patch
final ipsPatchedRom = applyIps(romData, ipsPatchData);

// Apply BPS patch
final bpsPatchedRom = applyBps(romData, bpsPatchData);

// Apply UPS patch
final upsPatchedRom = applyUps(romData, upsPatchData);
```

### Manual Format Detection

```dart
import 'package:rom_patcher/rom_patcher.dart';

// Detect patch format
final format = PatchUtils.detectFormat(patchData);
print('Detected format: ${format.name}');

// Validate patch header
final isValid = PatchUtils.validateHeader(patchData, PatchFormat.ips);
if (isValid) {
  final patchedRom = applyPatch(romData, patchData);
}
```

### Error Handling

```dart
import 'package:rom_patcher/rom_patcher.dart';

try {
  final patchedRom = applyPatch(romData, patchData);
  // Success!
} on PatchException catch (e) {
  switch (e.code) {
    case PatchErrorCode.invalidHeader:
      print('Invalid patch header: ${e.message}');
      break;
    case PatchErrorCode.checksumMismatch:
      print('Checksum validation failed: ${e.message}');
      break;
    case PatchErrorCode.fileTooSmall:
      print('Patch file is too small: ${e.message}');
      break;
    default:
      print('Patch error: ${e.message}');
  }
}
```

## API Reference

### Main Functions

#### `applyPatch(Uint8List rom, Uint8List patch, {PatchFormat? format})`

Applies a patch to a ROM with optional format specification.

- **rom**: The original ROM data
- **patch**: The patch data
- **format**: Optional patch format. If null, format will be auto-detected
- **Returns**: The patched ROM data
- **Throws**: `PatchException` if the patch is invalid or application fails

#### `applyIps(Uint8List rom, Uint8List patch)`

Applies an IPS patch to a ROM.

#### `applyBps(Uint8List rom, Uint8List patch)`

Applies a BPS patch to a ROM.

#### `applyUps(Uint8List rom, Uint8List patch)`

Applies a UPS patch to a ROM.

### Utility Functions

#### `PatchUtils.detectFormat(Uint8List patch)`

Detects the format of a patch file from its signature.

#### `PatchUtils.validateHeader(Uint8List patch, PatchFormat format)`

Validates that a patch file has a valid header for the specified format.

#### `PatchUtils.getMinimumSize(PatchFormat format)`

Gets the minimum size required for a valid patch file of the specified format.

### Exception Handling

#### `PatchException`

Exception thrown when patch operations fail.

**Properties:**

- `code`: The error code that identifies the type of error
- `message`: A human-readable error message
- `details`: Optional additional context about the error

#### `PatchErrorCode`

Enumeration of error codes:

- `invalidHeader`: The patch file header is invalid or unrecognized
- `fileTooSmall`: The patch file is too small to contain valid data
- `checksumMismatch`: A checksum or hash validation failed
- `unsupportedFormat`: The patch format is not supported
- `romTooSmall`: The ROM file is too small for the patch
- `corruptedPatch`: The patch file is corrupted or contains invalid data
- `unexpectedError`: An unexpected error occurred during patch application
- `truncatedPatch`: The patch file is truncated or incomplete
- `invalidOffset`: The patch contains invalid offset or size data
- `formatDetectionFailed`: The patch format could not be auto-detected

## Examples

### Flutter App Example

```dart
import 'package:flutter/material.dart';
import 'package:rom_patcher/rom_patcher.dart';

class RomPatcherApp extends StatefulWidget {
  @override
  _RomPatcherAppState createState() => _RomPatcherAppState();
}

class _RomPatcherAppState extends State<RomPatcherApp> {
  Uint8List? romData;
  Uint8List? patchData;
  Uint8List? patchedRom;
  String? errorMessage;

  Future<void> _loadRom() async {
    // Load ROM file
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['sfc', 'smc', 'nes', 'gb', 'gba'],
    );
    
    if (result != null) {
      final file = File(result.files.single.path!);
      romData = await file.readAsBytes();
    }
  }

  Future<void> _loadPatch() async {
    // Load patch file
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['ips', 'bps', 'ups'],
    );
    
    if (result != null) {
      final file = File(result.files.single.path!);
      patchData = await file.readAsBytes();
    }
  }

  void _applyPatch() {
    if (romData == null || patchData == null) return;

    try {
      setState(() {
        errorMessage = null;
        patchedRom = applyPatch(romData!, patchData!);
      });
    } on PatchException catch (e) {
      setState(() {
        errorMessage = 'Patch failed: ${e.message}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ROM Patcher')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _loadRom,
              child: Text('Load ROM'),
            ),
            ElevatedButton(
              onPressed: _loadPatch,
              child: Text('Load Patch'),
            ),
            ElevatedButton(
              onPressed: _applyPatch,
              child: Text('Apply Patch'),
            ),
            if (errorMessage != null)
              Text(errorMessage!, style: TextStyle(color: Colors.red)),
            if (patchedRom != null)
              Text('Patch applied successfully!'),
          ],
        ),
      ),
    );
  }
}
```

### Command Line Tool Example

```dart
import 'dart:io';
import 'package:rom_patcher/rom_patcher.dart';

void main(List<String> args) async {
  if (args.length != 3) {
    print('Usage: dart run patcher.dart <rom_file> <patch_file> <output_file>');
    exit(1);
  }

  final romFile = File(args[0]);
  final patchFile = File(args[1]);
  final outputFile = File(args[2]);

  try {
    // Load files
    final romData = await romFile.readAsBytes();
    final patchData = await patchFile.readAsBytes();

    // Detect format
    final format = PatchUtils.detectFormat(patchData);
    print('Detected patch format: ${format.name}');

    // Apply patch
    final patchedRom = applyPatch(romData, patchData);

    // Save result
    await outputFile.writeAsBytes(patchedRom);
    print('Patch applied successfully!');
    print('Output saved to: ${outputFile.path}');
  } on PatchException catch (e) {
    print('Error: ${e.message}');
    exit(1);
  } on FileSystemException catch (e) {
    print('File error: ${e.message}');
    exit(1);
  }
}
```

## Performance Considerations

- The library is optimized for large ROMs and avoids unnecessary memory copying
- IPS patches are the fastest to apply due to their simple format
- BPS and UPS patches include checksum validation which adds some overhead
- Memory usage is proportional to the target ROM size

## Limitations

- BPS and UPS patches require properly formatted patch files with valid checksums
- The current implementation includes basic CRC32 validation for BPS/UPS formats
- Some advanced BPS/UPS features may not be fully implemented

## Contributing

We welcome contributions to ROM Patcher! Please see our [Contributing Guidelines](CONTRIBUTING.md) for detailed information on how to get started.

### Quick Start

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Run tests (`dart test`)
5. Format code (`dart format .`)
6. Commit your changes (`git commit -m 'feat: add amazing feature'`)
7. Push to the branch (`git push origin feature/amazing-feature`)
8. Open a Pull Request

### Development

For detailed development information, see our [Development Guide](DEVELOPMENT.md).

### Code of Conduct

This project adheres to the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## Security

Please report security vulnerabilities via email to <siliconfish42@protonmail.com> rather than through public GitHub issues. See our [Security Policy](SECURITY.md) for more details.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Inspired by the Floating IPS (FLIPS) program
- Based on the Rom Patcher JS library
- Thanks to the ROM hacking community for the patch format specifications
