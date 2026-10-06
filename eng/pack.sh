#!/usr/bin/env bash
# Pack every published project with the Polyhydra overlay.
# Usage: eng/pack.sh <version> <output-dir>
set -euo pipefail
version="${1:?version required}"
out="${2:?output dir required}"
root="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "$out"
while IFS= read -r proj; do
  [[ -z "$proj" ]] && continue
  dotnet pack "$root/$proj" --configuration Release --output "$out" \
    -p:PolyhydraPackaging=true -p:PolyhydraPackageVersion="$version" \
    -p:ContinuousIntegrationBuild=true -p:UseSharedCompilation=false
done < "$root/eng/packages.txt"
