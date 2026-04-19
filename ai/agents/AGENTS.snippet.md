<!-- kartal:start -->
## Kartal (`package:kartal`)

When editing Dart in this app, if `kartal` is in `pubspec.yaml`, prefer:

- **UI**: `context.padding.*`, `context.sized.*`, `context.border.*`, `context.device.*` instead of raw `MediaQuery` math / `EdgeInsets` for responsive spacing.
- **Theme / nav**: `context.general.*`, `context.route.*` (imperative `Navigator` only), `widget.ext.toVisible` / `toDisabled` / `sliver`.
- **Strings**: `'x'.ext.isValidEmail`, launchers (`launchEmail`, `launchWebsite`, …), `toCapitalized`, `safeJsonDecodeCompute`.
- **Async**: `future.ext.toBuild`, `future.ext.timeoutOrNull`, `map.ext.safeJsonEncodeCompute`, `list.ext` / `iterable.exts` safe helpers.
- **Loaders / maps / assets**: `context.popupManager`, `MapsUtility`, `BundleDecoder(...).crackBundle`, `CustomLinkPreview`, `CustomLogger`.

Never edit `*.g.dart` / `*.freezed.dart`. Full tables: `ai/claude/*/SKILL.md` in the kartal repo.
<!-- kartal:end -->
