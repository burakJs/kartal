---
name: kartal-theming-navigation
description: This skill should be used when working with Flutter BuildContext for MediaQuery, Theme, FocusScope, keyboard insets, or Navigator routes. The kartal package exposes context.general for theme and media helpers and context.route for navigation shortcuts, plus widget.ext for visibility, disabled state, and sliver adapters.
---

# Kartal — theming, media, navigation, widget helpers

## When to use

- `MediaQuery.of(context)` / `Theme.of(context)` / `FocusScope.of(context)` boilerplate.
- Keyboard inset checks (`viewInsets.bottom`).
- `Navigator.of(context).push`, `pop`, `pushNamed`, `pushNamedAndRemoveUntil`.
- Toggling visibility or disabled appearance of a subtree.
- Wrapping a non-sliver child for `CustomScrollView`.

## API — `context.general`

| Member | Returns / behavior |
|--------|----------------------|
| `mediaQuery` | `MediaQuery.of(context)` |
| `mediaSize` | `MediaQuery.sizeOf(context)` |
| `mediaViewInset` | `MediaQuery.viewInsetsOf(context)` |
| `mediaBrightness` | `MediaQuery.platformBrightnessOf(context)` |
| `mediaTextScale(font)` | scales a font double via `MediaQuery.textScalerOf` |
| `appTheme` | `Theme.of(context)` |
| `textTheme`, `primaryTextTheme`, `colorScheme` | from `appTheme` |
| `focusNode` | `FocusScope.of(context)` |
| `isKeyBoardOpen` | `mediaViewInset.bottom > 0` |
| `keyboardPadding` | `mediaViewInset.bottom` |
| `appBrightness` | same as `mediaBrightness` |
| `unfocus()` | `focusNode.unfocus()` |

## API — `context.route`

`context.route.navigation` is the `NavigatorState` from `Navigator.of(context)`.

| Method / getter | Role |
|-----------------|------|
| `navigation` | underlying `NavigatorState` |
| `pop<T>([T? data])` | `navigation.maybePop(data)` |
| `popWithRoot()` | `Navigator.of(context, rootNavigator: true).pop()` |
| `navigateName<T>(path, {data})` | `pushNamed` |
| `navigateToReset<T>(path, {data})` | `pushNamedAndRemoveUntil` until predicate false |
| `navigateToPage<T>(page, {extra, type})` | `push` with `SlideRoute` (`SlideType` default `DEFAULT`) |

## API — `widget.ext` (`WidgetExtension`)

| Member | Role |
|--------|------|
| `toVisible({bool value = true})` | child or `SizedBox.shrink()` |
| `toDisabled({bool? disable, double? opacity})` | `IgnorePointer` + `Opacity` |
| `sliver` | `SliverToBoxAdapter(child: widget)` |

## Example

**Before**

```dart
Theme.of(context).textTheme.titleLarge;
Navigator.of(context).pop();
```

**After**

```dart
context.general.textTheme.titleLarge;
context.route.pop();
```

## When NOT to use

- GoRouter / auto_route / imperative API mismatch: `context.route` wraps imperative `Navigator`; do not fight the app’s router.
- When `rootNavigator` semantics differ per call site; `popWithRoot` always uses root.

## Gotchas

- `pop` uses `maybePop`, not unconditional `pop`.
- `navigateToPage` always uses kartal’s slide route helper.

## Import

```dart
import 'package:kartal/kartal.dart';
```
