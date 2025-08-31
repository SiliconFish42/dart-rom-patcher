# Development Guide

This guide provides detailed information for developers contributing to ROM Patcher.

## Project Structure

```
dart-rom-patcher/
├── lib/
│   ├── rom_patcher.dart          # Main library entry point
│   └── src/
│       ├── detection.dart        # Patch format detection
│       ├── exceptions.dart        # Custom exceptions
│       ├── ips_patcher.dart       # IPS patch implementation
│       ├── patch_format.dart      # Patch format enums
│       └── patchers/
│           ├── bps.dart          # BPS patch implementation
│           ├── ips.dart          # IPS patch implementation
│           └── ups.dart          # UPS patch implementation
├── test/
│   ├── bps_test.dart             # BPS tests
│   ├── ips_test.dart             # IPS tests
│   ├── rom_patcher_test.dart     # Main library tests
│   └── ups_test.dart             # UPS tests
├── example/
│   └── main.dart                 # Example usage
└── .github/                      # GitHub configuration
```

## Development Setup

### Prerequisites

- Dart SDK 3.0.0 or higher
- Git
- A code editor (VS Code recommended)

### Local Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/SiliconFish42/dart-rom-patcher.git
   cd dart-rom-patcher
   ```

2. Install dependencies:
   ```bash
   dart pub get
   ```

3. Verify setup:
   ```bash
   dart test
   dart analyze
   dart format .
   ```

## Development Workflow

### 1. Understanding the Codebase

#### Core Concepts

- **Patch Formats**: IPS, BPS, and UPS are different binary patch formats
- **Memory-Based**: All operations work with `Uint8List` objects in memory
- **Error Handling**: Comprehensive error codes and descriptive messages
- **Performance**: Optimized for large ROMs (100MB+)

#### Key Files

- `lib/rom_patcher.dart`: Main API entry point
- `lib/src/patch_format.dart`: Enum definitions for patch formats
- `lib/src/exceptions.dart`: Custom exception classes
- `lib/src/detection.dart`: Auto-detection logic

### 2. Adding New Features

#### Adding a New Patch Format

1. **Create the patcher implementation**:
   ```dart
   // lib/src/patchers/new_format.dart
   class NewFormatPatcher {
     static Uint8List apply(Uint8List rom, Uint8List patch) {
       // Implementation
     }
   }
   ```

2. **Add format detection**:
   ```dart
   // lib/src/detection.dart
   PatchFormat detectFormat(Uint8List patch) {
     if (isNewFormat(patch)) return PatchFormat.newFormat;
     // ... existing detection
   }
   ```

3. **Update the main API**:
   ```dart
   // lib/rom_patcher.dart
   Uint8List applyNewFormat(Uint8List rom, Uint8List patch) {
     return NewFormatPatcher.apply(rom, patch);
   }
   ```

4. **Add tests**:
   ```dart
   // test/new_format_test.dart
   void main() {
     group('NewFormatPatcher', () {
       test('should apply patch correctly', () {
         // Test implementation
       });
     });
   }
   ```

#### Adding New Error Codes

1. **Update the enum**:
   ```dart
   // lib/src/exceptions.dart
   enum PatchErrorCode {
     // ... existing codes
     newError,
   }
   ```

2. **Add descriptive messages**:
   ```dart
   String _getErrorMessage(PatchErrorCode code) {
     switch (code) {
       // ... existing cases
       case PatchErrorCode.newError:
         return 'Description of the new error';
     }
   }
   ```

### 3. Testing Guidelines

#### Test Structure

- **Unit Tests**: Test individual functions and classes
- **Integration Tests**: Test complete patch application workflows
- **Performance Tests**: Test with large files (100MB+)
- **Edge Case Tests**: Test error conditions and boundary cases

#### Test Data

- Use small, synthetic ROMs for unit tests
- Use real ROMs (with permission) for integration tests
- Create test patches using tools like FLIPS

#### Performance Testing

```dart
test('should handle large ROMs efficiently', () {
  final largeRom = Uint8List(100 * 1024 * 1024); // 100MB
  final patch = createTestPatch();
  
  final stopwatch = Stopwatch()..start();
  final result = applyPatch(largeRom, patch);
  stopwatch.stop();
  
  expect(stopwatch.elapsedMilliseconds, lessThan(5000)); // 5 seconds max
});
```

### 4. Code Quality Standards

#### Dart Style

- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `dart format` to maintain consistent formatting
- Use `dart analyze` to catch potential issues

#### Documentation

- All public APIs must have Dartdoc comments
- Include usage examples in documentation
- Document error conditions and edge cases

```dart
/// Applies a patch to a ROM with auto-detection of patch format.
///
/// This function automatically detects the patch format from the patch file
/// signature and applies it to the provided ROM data.
///
/// Example:
/// ```dart
/// final patchedRom = applyPatch(romData, patchData);
/// ```
///
/// Throws a [PatchException] if the patch is invalid or application fails.
/// Common error codes include:
/// - [PatchErrorCode.invalidHeader]: Invalid patch file header
/// - [PatchErrorCode.checksumMismatch]: Checksum validation failed
/// - [PatchErrorCode.fileTooSmall]: Patch file is too small
Uint8List applyPatch(Uint8List rom, Uint8List patch) {
  // Implementation
}
```

#### Error Handling

- Use specific error codes for different failure types
- Provide descriptive error messages
- Include context information when possible

```dart
if (patch.length < minimumSize) {
  throw PatchException(
    PatchErrorCode.fileTooSmall,
    'Patch file is too small: ${patch.length} bytes (minimum: $minimumSize)',
    details: {'actual_size': patch.length, 'minimum_size': minimumSize},
  );
}
```

### 5. Performance Considerations

#### Memory Usage

- Avoid unnecessary memory allocations
- Use `Uint8List` for binary data
- Consider streaming for very large files

#### Optimization Techniques

- Use efficient algorithms for patch application
- Minimize copying of large data structures
- Profile critical code paths

#### Large File Handling

- Test with ROMs of various sizes (1MB to 500MB)
- Monitor memory usage during processing
- Implement timeouts for long-running operations

### 6. Debugging

#### Common Issues

1. **Patch Format Detection Fails**:
   - Check patch file signature
   - Verify patch file integrity
   - Test with known good patches

2. **Memory Issues**:
   - Monitor memory usage with large files
   - Check for memory leaks
   - Use Dart DevTools for profiling

3. **Performance Problems**:
   - Profile with large ROMs
   - Check for inefficient algorithms
   - Monitor CPU usage

#### Debugging Tools

- **Dart DevTools**: For profiling and debugging
- **VS Code Debugger**: For step-through debugging
- **Logging**: Use `log` instead of `print`

```dart
import 'dart:developer' as developer;

void debugPatchApplication(Uint8List rom, Uint8List patch) {
  developer.log(
    'Applying patch',
    name: 'ROM Patcher',
    error: {
      'rom_size': rom.length,
      'patch_size': patch.length,
      'format': detectFormat(patch).name,
    },
  );
}
```

### 7. Release Process

#### Pre-release Checklist

- [ ] All tests pass
- [ ] Code analysis passes
- [ ] Documentation is updated
- [ ] CHANGELOG.md is updated
- [ ] Version is bumped in pubspec.yaml
- [ ] Performance tests pass

#### Release Steps

1. **Create a release branch**:
   ```bash
   git checkout -b release/v1.2.0
   ```

2. **Update version**:
   ```bash
   # Update pubspec.yaml version
   # Update CHANGELOG.md
   ```

3. **Run final checks**:
   ```bash
   dart test
   dart analyze
   dart format .
   dart doc
   ```

4. **Create release**:
   ```bash
   git tag v1.2.0
   git push origin v1.2.0
   ```

### 8. Contributing to Documentation

#### API Documentation

- Keep documentation up to date with code changes
- Include practical examples
- Document error conditions and edge cases

#### README Updates

- Update installation instructions
- Add new usage examples
- Update feature lists

#### CHANGELOG Updates

- Follow [Keep a Changelog](https://keepachangelog.com/) format
- Include all user-facing changes
- Group changes by type (Added, Changed, Fixed, etc.)

## Getting Help

- **Issues**: Use GitHub issues for bug reports and feature requests
- **Discussions**: Use GitHub Discussions for questions and ideas
- **Code Review**: All changes require code review before merging

## Resources

- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- [Dart Testing](https://dart.dev/guides/testing)
- [Dart Documentation](https://dart.dev/guides)
