# Contributing to ROM Patcher

Thank you for your interest in contributing to ROM Patcher! This document provides guidelines and instructions for contributing to this project.

## Getting Started

### Fork and Clone the Repository

1. Fork the repository on GitHub by clicking the "Fork" button
2. Clone your forked repository:
   ```bash
   git clone https://github.com/YOUR_USERNAME/dart-rom-patcher.git
   cd dart-rom-patcher
   ```
3. Add the original repository as an upstream remote:
   ```bash
   git remote add upstream https://github.com/SiliconFish42/dart-rom-patcher.git
   ```

### Setting Up Your Development Environment

1. Ensure you have Dart SDK 3.0.0 or higher installed
2. Install dependencies:
   ```bash
   dart pub get
   ```
3. Verify your setup by running tests:
   ```bash
   dart test
   ```

## Branch Naming Conventions

Use the following branch naming conventions:

- `feature/` - For new features
  - Example: `feature/add-xdelta-support`
- `fix/` - For bug fixes
  - Example: `fix/ips-checksum-validation`
- `chore/` - For maintenance tasks
  - Example: `chore/update-dependencies`
- `docs/` - For documentation changes
  - Example: `docs/update-api-documentation`
- `test/` - For adding or improving tests
  - Example: `test/add-ups-edge-cases`

## Commit Message Style

This project follows [Conventional Commits](https://www.conventionalcommits.org/) specification:

### Format
```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

### Types
- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation only changes
- `style`: Changes that do not affect the meaning of the code
- `refactor`: A code change that neither fixes a bug nor adds a feature
- `perf`: A code change that improves performance
- `test`: Adding missing tests or correcting existing tests
- `chore`: Changes to the build process or auxiliary tools

### Examples
```
feat: add support for XDelta patch format

fix(ips): correct checksum validation for large files

docs: update API documentation with examples

test: add edge case tests for corrupted patch files

chore: update dependencies to latest versions
```

## Development Workflow

### 1. Create a Feature Branch

```bash
git checkout -b feature/your-feature-name
```

### 2. Make Your Changes

- Write clear, readable code
- Add comprehensive tests for new functionality
- Update documentation as needed
- Follow the existing code style

### 3. Run Quality Checks

Before submitting a pull request, ensure your code passes all quality checks:

#### Code Formatting
```bash
dart format .
```

#### Static Analysis
```bash
dart analyze
```

#### Running Tests
```bash
dart test
```

#### Running Tests with Coverage
```bash
dart test --coverage=coverage
genhtml coverage/ -o coverage/html
```

### 4. Commit Your Changes

```bash
git add .
git commit -m "feat: add your feature description"
```

### 5. Push to Your Fork

```bash
git push origin feature/your-feature-name
```

### 6. Create a Pull Request

1. Go to your fork on GitHub
2. Click "New Pull Request"
3. Select your feature branch
4. Fill out the pull request template
5. Submit the pull request

## Code Quality Standards

### Dart Code Style

- Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `dart format` to automatically format your code
- Ensure `dart analyze` passes without warnings

### Testing Requirements

- All new features must include unit tests
- Bug fixes must include regression tests
- Aim for at least 90% code coverage
- Tests should be descriptive and test both success and failure cases

### Documentation Standards

- All public APIs must have Dartdoc comments
- Include usage examples in documentation
- Update README.md for user-facing changes
- Update CHANGELOG.md for all changes

### Performance Considerations

- Test with large ROM files (100MB+) to ensure performance
- Avoid unnecessary memory allocations
- Profile critical code paths

## Pull Request Process

### Before Submitting

1. **Tests**: Ensure all tests pass
2. **Formatting**: Run `dart format .`
3. **Analysis**: Run `dart analyze` and fix any issues
4. **Documentation**: Update relevant documentation
5. **Changelog**: Add entry to CHANGELOG.md if needed

### Pull Request Checklist

- [ ] Code follows the project's style guidelines
- [ ] Tests have been added/updated and all pass
- [ ] Documentation has been updated
- [ ] CHANGELOG.md has been updated (if applicable)
- [ ] Commit messages follow conventional commits format
- [ ] Branch name follows naming conventions

## Review Process

1. **Automated Checks**: GitHub Actions will run tests and analysis
2. **Code Review**: At least one maintainer must approve
3. **Discussion**: Address any feedback or questions
4. **Merge**: Once approved, your PR will be merged

## Getting Help

If you need help with your contribution:

1. Check existing issues and pull requests
2. Ask questions in the issue tracker
3. Join discussions in pull request comments

## Recognition

Contributors will be recognized in:
- The project's README.md
- Release notes
- GitHub contributors page

Thank you for contributing to ROM Patcher! 
