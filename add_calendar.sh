#!/usr/bin/env bash
# Copy an .ics file into calendars/, regenerate manifest.json, commit and push.
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <path-to-file.ics> [dest-name.ics]" >&2
  exit 1
fi

SRC="$1"
DEST_NAME="${2:-$(basename "$SRC")}"

if [[ "$DEST_NAME" != *.ics ]]; then
  echo "Destination filename must end in .ics" >&2
  exit 1
fi

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cp "$SRC" "$REPO_DIR/calendars/$DEST_NAME"

# Regenerate manifest.json from the calendars/ directory (portable, no jq required).
python3 - "$REPO_DIR" <<'PY'
import json, os, sys

repo_dir = sys.argv[1]
cal_dir = os.path.join(repo_dir, "calendars")
files = sorted(f for f in os.listdir(cal_dir) if f.endswith(".ics"))

with open(os.path.join(repo_dir, "manifest.json"), "w") as f:
    json.dump(files, f, indent=2)
    f.write("\n")
PY

cd "$REPO_DIR"
git add "calendars/$DEST_NAME" manifest.json
git commit -m "Add calendar: $DEST_NAME"
git push

echo ""
echo "Done. Once GitHub Pages finishes deploying, the calendar will be available at:"
echo "  https://<your-username>.github.io/<your-repo>/calendars/$DEST_NAME"
