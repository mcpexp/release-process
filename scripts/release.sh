#!/bin/bash
# Release automation script
# Steps:
# 1. Bump version
# 2. Generate changelog
# 3. Create git tag
# 4. Push to remote

set -e

VERSION="${1:-patch}"
echo "Releasing version: $VERSION"

# Bump version using npm (if package.json exists)
if [ -f "package.json" ]; then
    npm version "$VERSION"
else
    echo "No package.json found, skipping version bump."
fi

# Generate changelog (if using conventional commits)
if command -v conventional-changelog &> /dev/null; then
    conventional-changelog -p angular -i CHANGELOG.md -s
else
    echo "conventional-changelog not installed, skipping changelog generation."
fi

# Create git tag
TAG="v$(git describe --tags --abbrev=0 2>/dev/null || echo '0.0.0' | awk -F. -v OFS=. '{$NF++;print}')"
git tag -a "$TAG" -m "Release $TAG"

# Push changes and tags
git push origin main --tags
echo "Release $TAG completed!"
