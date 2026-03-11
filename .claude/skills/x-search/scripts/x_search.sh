#!/bin/bash
# X Search via Grok API
# Usage: bash x_search.sh "query" [options]

set -euo pipefail

# --- Parse arguments ---
QUERY=""
HANDLES=""
EXCLUDE=""
FROM_DATE=""
TO_DATE=""
IMAGES="false"
VIDEOS="false"
WEB="false"
MODEL="grok-4-1-fast-non-reasoning-latest"
SYSTEM_PROMPT=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --handles) HANDLES="$2"; shift 2 ;;
    --exclude) EXCLUDE="$2"; shift 2 ;;
    --from) FROM_DATE="$2"; shift 2 ;;
    --to) TO_DATE="$2"; shift 2 ;;
    --images) IMAGES="$2"; shift 2 ;;
    --videos) VIDEOS="$2"; shift 2 ;;
    --web) WEB="$2"; shift 2 ;;
    --model) MODEL="$2"; shift 2 ;;
    --system) SYSTEM_PROMPT="$2"; shift 2 ;;
    *)
      if [[ -z "$QUERY" ]]; then
        QUERY="$1"
      fi
      shift
      ;;
  esac
done

if [[ -z "$QUERY" ]]; then
  echo "Error: No search query provided" >&2
  echo "Usage: bash x_search.sh \"query\" [--handles h1,h2] [--exclude h1,h2] [--from YYYY-MM-DD] [--to YYYY-MM-DD] [--images true] [--videos true] [--web true] [--model model-name] [--system prompt]" >&2
  exit 1
fi

# --- Resolve API key ---
if [[ -z "${XAI_API_KEY:-}" ]]; then
  if [[ -f "$HOME/.config/xai/api_key" ]]; then
    XAI_API_KEY=$(cat "$HOME/.config/xai/api_key")
  else
    echo "Error: XAI_API_KEY not set and ~/.config/xai/api_key not found" >&2
    exit 1
  fi
fi

# --- Build x_search tool object ---
X_SEARCH_TOOL='{"type": "x_search"'

if [[ -n "$HANDLES" ]]; then
  HANDLES_JSON=$(echo "$HANDLES" | tr ',' '\n' | sed 's/^/"/;s/$/"/' | paste -sd',' -)
  X_SEARCH_TOOL="${X_SEARCH_TOOL}, \"allowed_x_handles\": [${HANDLES_JSON}]"
fi

if [[ -n "$EXCLUDE" ]]; then
  EXCLUDE_JSON=$(echo "$EXCLUDE" | tr ',' '\n' | sed 's/^/"/;s/$/"/' | paste -sd',' -)
  X_SEARCH_TOOL="${X_SEARCH_TOOL}, \"excluded_x_handles\": [${EXCLUDE_JSON}]"
fi

if [[ -n "$FROM_DATE" ]]; then
  X_SEARCH_TOOL="${X_SEARCH_TOOL}, \"from_date\": \"${FROM_DATE}\""
fi

if [[ -n "$TO_DATE" ]]; then
  X_SEARCH_TOOL="${X_SEARCH_TOOL}, \"to_date\": \"${TO_DATE}\""
fi

if [[ "$IMAGES" == "true" ]]; then
  X_SEARCH_TOOL="${X_SEARCH_TOOL}, \"enable_image_understanding\": true"
fi

if [[ "$VIDEOS" == "true" ]]; then
  X_SEARCH_TOOL="${X_SEARCH_TOOL}, \"enable_video_understanding\": true"
fi

X_SEARCH_TOOL="${X_SEARCH_TOOL}}"

# --- Build tools array ---
TOOLS="[${X_SEARCH_TOOL}"
if [[ "$WEB" == "true" ]]; then
  TOOLS="${TOOLS}, {\"type\": \"web_search\"}"
fi
TOOLS="${TOOLS}]"

# --- Build input array ---
INPUT="["
if [[ -n "$SYSTEM_PROMPT" ]]; then
  INPUT="${INPUT}{\"role\": \"system\", \"content\": $(echo "$SYSTEM_PROMPT" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read().strip()))')},"
fi
INPUT="${INPUT}{\"role\": \"user\", \"content\": $(echo "$QUERY" | python3 -c 'import json,sys; print(json.dumps(sys.stdin.read().strip()))')}]"

# --- Build request body ---
BODY=$(cat <<ENDJSON
{
  "model": "${MODEL}",
  "input": ${INPUT},
  "tools": ${TOOLS}
}
ENDJSON
)

# --- Make the API call ---
curl -s "https://api.x.ai/v1/responses" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${XAI_API_KEY}" \
  -d "${BODY}"
