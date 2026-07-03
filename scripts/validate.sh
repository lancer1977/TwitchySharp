#!/usr/bin/env bash
set -euo pipefail

dotnet test TwitchySharp.sln --configuration Release

echo "TwitchySharp validation passed"
