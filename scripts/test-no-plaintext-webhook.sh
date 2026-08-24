#!/usr/bin/env bash
set -euo pipefail

script_directory=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
scanner="$script_directory/check-no-plaintext-webhook.sh"
fixture_directory=$(mktemp -d)
trap 'rm -rf "$fixture_directory"' EXIT

negative_fixture="$fixture_directory/negative.yml"
cat > "$negative_fixture" <<'EOF'
steps:
  - task: ado-discord-webhook@1
    inputs:
      webhookKey: 'https://discord.com/api/webhooks/fake/non-functional-fixture'
EOF

if "$scanner" "$negative_fixture" >"$fixture_directory/negative.stdout" 2>"$fixture_directory/negative.stderr"; then
  echo "Expected the value-shaped webhook fixture to fail" >&2
  exit 1
fi

if ! grep -Fxq "Plaintext webhook URL violation at $negative_fixture:4" "$fixture_directory/negative.stderr"; then
  echo "Expected a redacted violation location for the negative fixture" >&2
  exit 1
fi

if [[ -s "$fixture_directory/negative.stdout" ]] || grep -Fq 'fake/non-functional-fixture' "$fixture_directory/negative.stderr"; then
  echo "Scanner output was not redacted" >&2
  exit 1
fi

reference_fixture="$fixture_directory/reference.yml"
cat > "$reference_fixture" <<'EOF'
steps:
  - task: ado-discord-webhook@1
    inputs:
      webhookKey: '$(TWITCHYSHARP_DISCORD_WEBHOOK_URL)'
EOF

if ! "$scanner" "$reference_fixture" >"$fixture_directory/reference.stdout" 2>"$fixture_directory/reference.stderr"; then
  echo "Expected the secret-variable reference fixture to pass" >&2
  exit 1
fi

if [[ -s "$fixture_directory/reference.stdout" || -s "$fixture_directory/reference.stderr" ]]; then
  echo "Expected no scanner output for the passing fixture" >&2
  exit 1
fi

echo "Plaintext webhook scanner fixtures passed"
