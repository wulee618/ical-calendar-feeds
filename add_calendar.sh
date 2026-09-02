#!/usr/bin/env bash
# Copy an .ics file into calendars/ under a random filename, commit and push.
#
# GitHub Pages is publicly reachable even when the repo is private, so the
# only real protection for calendar contents (e.g. a kid's school schedule)
# is an unguessable filename. Do not pass a descriptive dest name here.
set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage: $0 <path-to-file.ics> [note]" >&2
  echo "  note: optional label recorded in calendars/LOCAL_NOTES.md (never committed)" >&2
  exit 1
fi

SRC="$1"
NOTE="${2:-}"
RAND_NAME="$(openssl rand -hex 8).ics"

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cp "$SRC" "$REPO_DIR/calendars/$RAND_NAME"

if [[ -n "$NOTE" ]]; then
  NOTES_FILE="$REPO_DIR/calendars/LOCAL_NOTES.md"
  [[ -f "$NOTES_FILE" ]] || printf '# 本機備忘（不會被 commit / 不會上傳）\n\n| 檔名 | 內容 |\n|---|---|\n' > "$NOTES_FILE"
  echo "| $RAND_NAME | $NOTE |" >> "$NOTES_FILE"
fi

cd "$REPO_DIR"
git add "calendars/$RAND_NAME"
git commit -m "Add calendar: $RAND_NAME"
git push

echo ""
echo "Done. Once GitHub Pages finishes deploying, the calendar will be available at:"
echo "  https://<your-username>.github.io/<your-repo>/calendars/$RAND_NAME"
echo "Keep this URL private — anyone with it can read the calendar."
