# Manual evaluation (optional)

Use this to verify that installing the rules/skills changes assistant behavior. Attach before/after screenshots to a PR if helpful.

## Setup

1. Create a small Flutter app with `kartal` in `pubspec.yaml`.
2. In `lib/main.dart`, add deliberately verbose code, for example:
   - `MediaQuery.of(context).size.width * 0.5`
   - `EdgeInsets.all(16)`
   - `Navigator.of(context).pop()`
   - `FutureBuilder<MyModel>(...)` with manual `ConnectionState` branches

## Before

1. Do **not** install `.mdc` or Claude skills.
2. Ask your agent: “Refactor this widget to be cleaner and more idiomatic for this project.”
3. Save the suggested diff or a screenshot.

## After

1. Install Cursor rules from [`README.md`](README.md) **or** copy `ai/claude/*` into `.claude/skills/`.
2. Start a **new** agent session (fresh context).
3. Ask the **same** prompt.
4. Confirm suggestions include kartal patterns such as `context.sized.dynamicWidth`, `context.padding.normal`, `context.route.pop`, or `future.ext.toBuild` where appropriate.

## Pass criteria

- Responsive spacing uses `context.padding.*` / `context.sized.*` instead of raw `MediaQuery` math where kartal fits the design.
- Navigation uses `context.route.*` when using kartal already.
- No edits to generated files (`*.g.dart`, `*.freezed.dart`).
