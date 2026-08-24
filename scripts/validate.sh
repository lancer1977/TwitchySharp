#!/usr/bin/env bash
set -euo pipefail

./scripts/test-no-plaintext-webhook.sh
./scripts/check-no-plaintext-webhook.sh .pipelines/TwitchySharp.yml
dotnet test TwitchySharp.sln --configuration Release

echo "TwitchySharp validation passed"
