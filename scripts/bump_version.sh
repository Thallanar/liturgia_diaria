#!/usr/bin/env bash
set -e

# =============================================================================
# bump_version.sh — Atualiza a versão do app no pubspec.yaml
#
# Uso: ./scripts/bump_version.sh [major|minor|patch]
#
#   major  — mudança incompatível / reestruturação grande  (1.0.0 → 2.0.0)
#   minor  — nova funcionalidade, sem quebrar API           (1.0.0 → 1.1.0)
#   patch  — correção de bug, ajuste pequeno               (1.0.0 → 1.0.1)
#
# O build number (+N) é sempre incrementado automaticamente.
# =============================================================================

PUBSPEC="pubspec.yaml"
BUMP_TYPE="${1:-patch}"

if [[ ! "$BUMP_TYPE" =~ ^(major|minor|patch)$ ]]; then
  echo "Uso: $0 [major|minor|patch]"
  echo ""
  echo "  major  — mudança incompatível (ex: 1.0.0 -> 2.0.0)"
  echo "  minor  — nova funcionalidade  (ex: 1.0.0 -> 1.1.0)"
  echo "  patch  — correção de bug      (ex: 1.0.0 -> 1.0.1)"
  exit 1
fi

# Extrai a linha "version: X.Y.Z+B"
CURRENT=$(grep '^version:' "$PUBSPEC" | sed 's/version: //' | tr -d '[:space:]')

if [[ -z "$CURRENT" ]]; then
  echo "Erro: campo 'version' não encontrado em $PUBSPEC"
  exit 1
fi

VERSION=$(echo "$CURRENT" | cut -d'+' -f1)
BUILD=$(echo "$CURRENT" | cut -d'+' -f2)

MAJOR=$(echo "$VERSION" | cut -d'.' -f1)
MINOR=$(echo "$VERSION" | cut -d'.' -f2)
PATCH=$(echo "$VERSION" | cut -d'.' -f3)

case "$BUMP_TYPE" in
  major)
    MAJOR=$((MAJOR + 1))
    MINOR=0
    PATCH=0
    ;;
  minor)
    MINOR=$((MINOR + 1))
    PATCH=0
    ;;
  patch)
    PATCH=$((PATCH + 1))
    ;;
esac

NEW_BUILD=$((BUILD + 1))
NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}+${NEW_BUILD}"

# Atualiza o pubspec.yaml
sed -i "s/^version: .*/version: ${NEW_VERSION}/" "$PUBSPEC"

echo "Versão atualizada: ${CURRENT} → ${NEW_VERSION}"

# Exporta para uso no GitHub Actions, se disponível
if [[ -n "$GITHUB_OUTPUT" ]]; then
  echo "new_version=${MAJOR}.${MINOR}.${PATCH}" >> "$GITHUB_OUTPUT"
  echo "new_tag=v${MAJOR}.${MINOR}.${PATCH}" >> "$GITHUB_OUTPUT"
fi
