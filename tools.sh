#!/usr/bin/env bash

set -euo pipefail

TNL_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

usage() {
    printf '%s\n' \
        "Usage: ./tools.sh list-tags" \
        "       ./tools.sh preview" \
        "       ./tools.sh help" \
        "" \
        "list-tags lists tags in committed blog posts and their counts." \
        "preview builds the site, serves it on 0.0.0.0:5080, and reloads after changes." \
        "Set TNL_PREVIEW_PORT to use another preview port."
}

require_command() {
    if ! command -v "$1" >/dev/null 2>&1; then
        printf 'Required command is not available: %s\n' "$1" >&2
        exit 1
    fi
}

list_tags() {
    require_command git
    require_command python3
    python3 "$TNL_ROOT/tools/list_tags.py" "$TNL_ROOT"
}

preview() {
    require_command uv
    cd "$TNL_ROOT"
    exec uv run --quiet --script "$TNL_ROOT/tools/preview.py" \
        --host 0.0.0.0 \
        --port "${TNL_PREVIEW_PORT:-5080}"
}

case "${1:-}" in
    list-tags)
        list_tags
        ;;
    preview)
        preview
        ;;
    ""|-h|--help|help)
        usage
        ;;
    *)
        printf 'Unknown command: %s\n\n' "$1" >&2
        usage >&2
        exit 1
        ;;
esac
