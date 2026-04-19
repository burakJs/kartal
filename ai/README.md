# Kartal AI assistant assets

Optional rules and skills so coding agents (Cursor, Claude Code, Codex, Aider, etc.) suggest **kartal** APIs (`context.padding.*`, `string.ext.*`, `future.ext.toBuild`, …) instead of only verbose Flutter defaults.

These files live in the **kartal** repository; copy them into **your app** project (they are not loaded automatically by adding the pub dependency).

## Layout

| Path | Purpose |
|------|---------|
| `cursor/*.mdc` | Cursor project rules (`.cursor/rules/`). |
| `claude/*/SKILL.md` | Claude Code skills (`.claude/skills/<name>/`). |
| `agents/AGENTS.snippet.md` | Paste into your app’s `AGENTS.md` (between markers). |
| `MANUAL_EVAL.md` | Optional before/after check for Cursor or Claude. |

## Cursor

From your **Flutter app** root (not inside `pub-cache`):

```bash
mkdir -p .cursor/rules
for f in kartal-overview kartal-ui kartal-string kartal-async kartal-utility; do
  curl -fsSL -o ".cursor/rules/${f}.mdc" \
    "https://raw.githubusercontent.com/VB10/kartal/master/ai/cursor/${f}.mdc"
done
```

Adjust branch/host if you vendor a fork.

## Claude Code

```bash
mkdir -p .claude/skills
# Option A: copy from a local kartal clone
cp -R /path/to/kartal/ai/claude/* .claude/skills/

# Option B: shallow clone then copy only ai/claude
git clone --depth 1 https://github.com/VB10/kartal.git /tmp/kartal-ai && \
  cp -R /tmp/kartal-ai/ai/claude/* .claude/skills/
```

Each skill is a folder named like `kartal-responsive-ui/` containing `SKILL.md`.

## AGENTS.md (generic agents)

Copy the contents of [`agents/AGENTS.snippet.md`](agents/AGENTS.snippet.md) into your project’s `AGENTS.md`, or merge manually. Keep the `<!-- kartal:start -->` / `<!-- kartal:end -->` markers so you can replace the block later.

## Proposal / tracking

Upstream discussion: [VB10/kartal#88](https://github.com/VB10/kartal/issues/88).

## Import reminder

Dart code still needs:

```dart
import 'package:kartal/kartal.dart';
```
