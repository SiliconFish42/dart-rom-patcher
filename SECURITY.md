# Security Policy

## Supported Versions

Use this section to tell people about which versions of your project are currently being supported with security updates.

| Version | Supported          |
| ------- | ------------------ |
| 0.1.x   | :white_check_mark: |

## Reporting a Vulnerability

We take the security of ROM Patcher seriously. If you believe you have found a security vulnerability, please report it to us as described below.

### Reporting Process

**Please do NOT report security vulnerabilities through public GitHub issues.**

Instead, please report them via email to <siliconfish42@protonmail.com>.

### What to Include

When reporting a security vulnerability, please include:

1. **Description**: A clear description of the vulnerability
2. **Impact**: The potential impact of the vulnerability
3. **Steps to Reproduce**: Detailed steps to reproduce the issue
4. **Proof of Concept**: If possible, include a minimal code example
5. **Affected Versions**: Which versions of ROM Patcher are affected
6. **Suggested Fix**: If you have suggestions for fixing the issue

### Example Report

```
Subject: Security Vulnerability Report - ROM Patcher

Description:
[Describe the vulnerability]

Impact:
[Describe the potential impact]

Steps to Reproduce:
1. [Step 1]
2. [Step 2]
3. [Step 3]

Proof of Concept:
[Include code example if applicable]

Affected Versions:
[List affected versions]

Suggested Fix:
[If you have suggestions]
```

### Response Timeline

- **Initial Response**: Within 48 hours
- **Status Update**: Within 1 week
- **Resolution**: Depends on complexity, typically 2-4 weeks

### Disclosure Policy

- We will acknowledge receipt of your vulnerability report within 48 hours
- We will provide regular updates on the status of the vulnerability
- Once the vulnerability is confirmed and fixed, we will:
  - Release a security update
  - Update the CHANGELOG.md with security information
  - Credit the reporter (unless they prefer to remain anonymous)

### Responsible Disclosure

We ask that you:

- Give us reasonable time to respond and fix the issue
- Avoid public disclosure until we've had a chance to address the vulnerability
- Work with us to coordinate any public disclosure

### Security Best Practices

When using ROM Patcher:

1. **Validate Input**: Always validate ROM and patch files before processing
2. **Check File Integrity**: Verify checksums when possible
3. **Use Latest Version**: Keep ROM Patcher updated to the latest version
4. **Handle Errors**: Implement proper error handling for patch operations
5. **Memory Safety**: Be aware of memory usage when processing large files

### Security Considerations

ROM Patcher processes binary files and should be used with caution:

- **File Validation**: Always validate that files are legitimate ROMs and patches
- **Memory Usage**: Large ROMs can consume significant memory
- **Error Handling**: Implement proper error handling to prevent crashes
- **Sandboxing**: Consider running in a sandboxed environment when processing untrusted files

### Contact Information

For security-related issues:

- Email: <siliconfish42@protonmail.com>

For general support and non-security issues:

- GitHub Issues: <https://github.com/SiliconFish42/dart-rom-patcher/issues>
- Discussions: <https://github.com/SiliconFish42/dart-rom-patcher/discussions>

Thank you for helping keep ROM Patcher secure!
