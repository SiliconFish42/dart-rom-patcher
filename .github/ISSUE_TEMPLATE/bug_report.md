---
name: Bug report
about: Create a report to help us improve ROM Patcher
title: '[BUG] '
labels: ['bug']
assignees: ['SiliconFish42']
---

## Bug Description

A clear and concise description of what the bug is.

## Steps to Reproduce

1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

## Expected Behavior

A clear and concise description of what you expected to happen.

## Actual Behavior

A clear and concise description of what actually happened.

## Environment Information

- **Dart Version**: [e.g., 3.2.0]
- **Platform**: [e.g., Windows, macOS, Linux]
- **ROM Patcher Version**: [e.g., 0.1.0]

## Additional Context

### ROM Information
- **ROM Size**: [e.g., 2MB, 32MB]
- **ROM Format**: [e.g., .sfc, .smc, .nes]
- **ROM Source**: [e.g., original cartridge, downloaded]

### Patch Information
- **Patch Format**: [e.g., IPS, BPS, UPS]
- **Patch Size**: [e.g., 1KB, 50KB]
- **Patch Source**: [e.g., created with FLIPS, downloaded]

### Error Details
If applicable, include:
- Full error message
- Stack trace
- Error code from `PatchErrorCode` enum

## Code Example

```dart
import 'package:rom_patcher/rom_patcher.dart';

// Your code that reproduces the bug
final romData = Uint8List.fromList([/* your ROM data */]);
final patchData = Uint8List.fromList([/* your patch data */]);

try {
  final patchedRom = applyPatch(romData, patchData);
} on PatchException catch (e) {
  print('Error: ${e.message}');
  print('Error code: ${e.code}');
}
```

## Files

If applicable, please attach:
- Sample ROM file (if small and legal to share)
- Sample patch file
- Screenshots or logs

## Checklist

- [ ] I have searched existing issues to avoid duplicates
- [ ] I have provided all the requested information
- [ ] I can reproduce this issue consistently
- [ ] This is a bug in ROM Patcher, not in my code or environment

## Additional Notes

Add any other context about the problem here.
