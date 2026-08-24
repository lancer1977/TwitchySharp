#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 PIPELINE_FILE" >&2
  exit 2
fi

pipeline_file=$1
if [[ ! -f "$pipeline_file" ]]; then
  echo "Pipeline file not found: $pipeline_file" >&2
  exit 2
fi

# Match known webhook URL shapes without ever printing the matching content.
readonly webhook_url_pattern='https?://[^[:space:]]*(discord(app)?\.com/api/webhooks/|hooks\.slack\.com/services/|webhook\.site/)'
line_number=0
violations=0

while IFS= read -r line || [[ -n "$line" ]]; do
  ((line_number += 1))
  if [[ "$line" =~ $webhook_url_pattern ]]; then
    echo "Plaintext webhook URL violation at $pipeline_file:$line_number" >&2
    ((violations += 1))
  fi
done < "$pipeline_file"

if ((violations > 0)); then
  exit 1
fi
