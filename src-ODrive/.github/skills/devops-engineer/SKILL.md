---
name: odrive-devops-engineer
description: DevOps skill for ODrive firmware and tools deployment. Use when working with CI/CD workflows, GitHub Actions, code deployment, release management, or pushing code changes through automated pipelines. Includes firmware builds, documentation publishing, and release automation.
---

# ODrive DevOps Engineer Skill

This skill helps DevOps engineers manage CI/CD workflows, releases, and automated deployment pipelines for the ODrive motor control firmware and tools.

## When to use this skill

Use this skill when you need to:
- Work with GitHub Actions workflows
- Trigger CI/CD pipelines for firmware builds
- Push code changes and create pull requests
- Manage releases and versioning
- Deploy documentation to production
- Configure build matrices for multi-platform testing
- Debug workflow failures
- Set up or modify release channels
- Automate firmware builds across board variants
- Manage secrets and deployment credentials

## Project Structure

```
ODrive/
├── .github/
│   ├── workflows/
│   │   ├── firmware.yaml          # Main firmware CI/CD pipeline
│   │   └── documentation.yml      # Documentation build & publish
│   ├── actions/
│   │   └── upload-release/        # Custom release upload action
│   └── skills/
│       └── devops-engineer/       # This skill
├── Firmware/
│   ├── tup.config.default        # Build configuration template
│   ├── Tupfile.lua               # Build system rules
│   └── Board/                    # Board-specific configs
└── tools/
    ├── setup.py                  # Python package setup
    └── run_tests.py              # Test harness
```

## GitHub Workflows

### Firmware CI/CD Pipeline (`firmware.yaml`)

**Triggers:**
- Pull requests to `master` or `devel` branches
- Pushes to `master` or `devel` branches
- Tags matching `fw-v*` pattern

**Key Features:**
- Multi-platform builds (Ubuntu, Windows, macOS)
- Multi-board variant matrix (v3.2 through v3.6 variants)
- Debug and release builds
- Automatic release channel detection
- Version extraction from git tags
- Firmware artifact uploads

**Build Matrix:**
```yaml
os: [ubuntu-latest, windows-latest, macOS-latest]
board_version: [v3.2, v3.3, v3.4-24V, v3.4-48V, v3.5-24V, v3.5-48V, v3.6-24V, v3.6-56V]
debug: [true, false]
```

**Release Channels:**
- `master`: Production releases (tags: `fw-v0.5.x`)
- `devel`: Development builds
- `none`: Non-release builds

### Documentation Pipeline (`documentation.yml`)

**Triggers:**
- Pushes to branches matching `docs-v**` pattern
- Changes to `docs/**` or `.github/**` paths

**Key Features:**
- Sphinx-based HTML documentation generation
- Automatic deployment to DigitalOcean Spaces
- Version extraction from branch name
- Python dependency caching

## Common DevOps Tasks

### 1. Pushing Code Changes

**Creating a branch and pushing:**
```powershell
# Create feature branch
git checkout -b feature/my-new-feature

# Stage changes
git add .

# Commit with descriptive message
git commit -m "Add new feature: description"

# Push to remote
git push -u origin feature/my-new-feature
```

**Creating a pull request:**
```powershell
# Via GitHub CLI
gh pr create --title "Feature: Description" --body "Details of changes"

# Or use GitHub web UI after pushing
```

### 2. Triggering Firmware Builds

Firmware builds trigger automatically on:
- PR creation/updates to `master` or `devel`
- Direct pushes to `master` or `devel`
- Tag creation matching `fw-v*`

**Manual trigger (if configured):**
```powershell
# Using GitHub CLI
gh workflow run firmware.yaml --ref master
```

### 3. Creating a Firmware Release

```powershell
# Tag the release
git tag -a fw-v0.5.6 -m "Release version 0.5.6"

# Push tag to trigger release workflow
git push origin fw-v0.5.6
```

This automatically:
- Builds firmware for all board variants
- Sets release channel to "master"
- Uploads artifacts to release system

### 4. Publishing Documentation

```powershell
# Create docs branch
git checkout -b docs-v0.5.6

# Make documentation changes in docs/ folder
# ...

# Commit and push
git add docs/
git commit -m "Update documentation for v0.5.6"
git push origin docs-v0.5.6
```

### 5. Checking Workflow Status

```powershell
# List recent workflow runs
gh run list --workflow=firmware.yaml --limit 10

# View specific run details
gh run view <run-id>

# Watch a running workflow
gh run watch <run-id>

# Download artifacts
gh run download <run-id>
```

### 6. Managing Secrets

Secrets are configured in GitHub repository settings:

**Required secrets:**
- `DIGITALOCEAN_ACCESS_KEY`: For docs deployment
- `DIGITALOCEAN_SECRET_KEY`: For docs deployment

**Adding secrets via CLI:**
```powershell
gh secret set DIGITALOCEAN_ACCESS_KEY
gh secret set DIGITALOCEAN_SECRET_KEY
```

## Workflow Debugging

### Common Issues

**1. Build Failures:**
```powershell
# Check workflow logs
gh run view <run-id> --log

# Look for specific job
gh run view <run-id> --job=<job-id> --log
```

**2. Dependency Issues:**
- Check prerequisite installation steps in workflow
- Verify package versions in requirements
- Check cache keys if using caching

**3. Matrix Build Failures:**
- Review failed matrix combinations
- Check board-specific configuration files
- Verify GCC ARM toolchain availability

### Workflow File Locations

- Main firmware CI: [.github/workflows/firmware.yaml](.github/workflows/firmware.yaml)
- Documentation CI: [.github/workflows/documentation.yml](.github/workflows/documentation.yml)
- Custom actions: `.github/actions/`

## Git Best Practices for DevOps

### Branch Strategy
- `master`: Stable production code
- `devel`: Development branch for integration
- `feature/*`: Feature development branches
- `bugfix/*`: Bug fix branches
- `docs-v*`: Documentation release branches

### Commit Message Format
```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:** feat, fix, docs, style, refactor, test, chore

**Example:**
```
feat(firmware): Add velocity ramping for smoother motion

Implements exponential velocity ramping to reduce mechanical 
shock during rapid acceleration changes.

Closes #123
```

### Pull Request Workflow

1. Create feature branch from `devel`
2. Make changes and commit
3. Push branch to remote
4. Create PR targeting `devel`
5. Wait for CI checks to pass
6. Request code review
7. Address review feedback
8. Merge after approval

## Prerequisites

**Tools Required:**
- Git (version control)
- GitHub CLI (`gh`) - recommended for workflow management
- PowerShell or Bash
- Python 3.x (for testing)
- Tup build system (for local firmware builds)
- GCC ARM toolchain (for local firmware builds)

**Installation:**
```powershell
# GitHub CLI
winget install GitHub.cli

# Verify installation
gh --version
git --version
```

## Safety Guidelines

⚠️ **IMPORTANT:**
- Always work on feature branches, never directly on `master`
- Test locally before pushing
- Review CI results before merging PRs
- Never commit secrets or credentials to repository
- Use signed commits for releases
- Tag releases only from `master` branch
- Verify workflow changes in fork before mainline PR

## Useful Scripts

Scripts location: `.github/skills/devops-engineer/scripts/`

### Available Scripts

1. **push_with_checks.ps1** - Push code with pre-flight checks
2. **trigger_workflow.ps1** - Manually trigger workflow runs
3. **check_workflow_status.ps1** - Monitor workflow execution

(Scripts to be implemented based on team needs)

## Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Tup Build System](https://gittup.org/tup/)
- [ODrive Developer Guide](../../docs/developer-guide.rst)
- [Git Workflow Guide](https://www.atlassian.com/git/tutorials/comparing-workflows)
- [Semantic Versioning](https://semver.org/)

## Testing Changes

Before pushing workflow changes:

1. **Fork Testing:**
   ```powershell
   # Fork the repo, then test in your fork
   git remote add fork https://github.com/yourusername/ODrive.git
   git push fork feature/workflow-changes
   ```

2. **Local Simulation:**
   ```powershell
   # Use act to run workflows locally
   act -l  # List jobs
   act pull_request  # Simulate PR workflow
   ```

3. **Dry Run:**
   - Comment out deployment steps
   - Add echo/print statements for debugging
   - Test on non-production branches first

## Getting Help

- Check workflow logs: `gh run view <run-id> --log`
- Review Actions tab in GitHub web UI
- Check [ODrive forums](https://discourse.odriverobotics.com/)
- Read GitHub Actions status: https://www.githubstatus.com/
