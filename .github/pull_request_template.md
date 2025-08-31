## Summary

Brief description of the changes made in this pull request.

## Type of Change

- [ ] **Bug fix** (non-breaking change which fixes an issue)
- [ ] **New feature** (non-breaking change which adds functionality)
- [ ] **Breaking change** (fix or feature that would cause existing functionality to not work as expected)
- [ ] **Documentation update** (changes to documentation only)
- [ ] **Performance improvement** (change that improves performance)
- [ ] **Refactoring** (change that neither fixes a bug nor adds a feature)
- [ ] **Test addition/improvement** (adding or improving tests)

## Related Issues

Closes #[issue number]
Related to #[issue number]

## Changes Made

### Code Changes
- [List of specific code changes]

### Documentation Changes
- [List of documentation updates]

### Test Changes
- [List of test additions/modifications]

## Testing

### Manual Testing
- [ ] Tested with IPS patches
- [ ] Tested with BPS patches
- [ ] Tested with UPS patches
- [ ] Tested with large ROM files (>100MB)
- [ ] Tested error conditions
- [ ] Tested edge cases

### Automated Testing
- [ ] All existing tests pass
- [ ] New tests added for new functionality
- [ ] Test coverage maintained or improved
- [ ] Performance tests pass (if applicable)

## Code Quality

### Pre-submission Checklist
- [ ] Code follows Dart style guidelines
- [ ] `dart format .` has been run
- [ ] `dart analyze` passes without warnings
- [ ] All tests pass locally
- [ ] Documentation updated (if applicable)
- [ ] CHANGELOG.md updated (if applicable)

### Code Review Checklist
- [ ] Code is readable and well-documented
- [ ] Functions and classes have appropriate names
- [ ] Error handling is comprehensive
- [ ] Performance considerations addressed
- [ ] Security considerations addressed (if applicable)

## Performance Impact

- **Memory Usage**: [e.g., no change, slight increase, significant increase]
- **Execution Time**: [e.g., no change, slight improvement, significant improvement]
- **Large File Handling**: [e.g., tested with 100MB+ files]

## Breaking Changes

If this PR includes breaking changes, describe them here and provide migration guidance:

```dart
// Before
final result = oldFunction(data);

// After
final result = newFunction(data);
```

## Screenshots

If applicable, add screenshots to help explain your changes.

## Additional Notes

Any additional information that reviewers should know about this PR.

## Checklist

- [ ] My code follows the style guidelines of this project
- [ ] I have performed a self-review of my own code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes
- [ ] Any dependent changes have been merged and published in downstream modules
- [ ] I have updated the CHANGELOG.md file (if applicable)
- [ ] I have followed the conventional commits format for commit messages
