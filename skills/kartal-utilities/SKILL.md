---
name: kartal-utilities
description: This skill should be used when opening maps from encoded queries, decoding JSON assets from the Flutter bundle, fetching HTML link previews, logging errors, mapping HTTP status codes to colors, using device utilities, or using small widget extensions on Image, GlobalKey, Color, int, bool, DateTime, and File from the kartal package.
---

# Kartal — utilities and small widget / primitive extensions

## When to use

- Maps deep links (`MapsUtility`).
- JSON under `assets/` decoded to models with `compute`.
- Link unfurling (OpenGraph / Twitter cards) via HTTP fetch.
- Debug logging with type prefix.
- HTTP status visualization.
- `GlobalKey` measurement / `ensureVisible`.
- Static image rotation transitions.
- File MIME type checks.

## API — maps

`MapsUtility` (`maps_utility.dart`):

| Method | Role |
|--------|------|
| `openAppleMapsWithQuery(query, {callBack})` | Apple Maps deep link + optional custom launcher |
| `openGoogleMapsWithQuery(query, {callBack})` | Google Maps app deep link |
| `openGoogleWebMapsWithQuery(query)` | web fallback |

Errors log via `CustomLogger.showError<MapsUtility>`.

## API — bundle JSON

`BundleDecoder(assetPath)` + `crackBundle<T extends IAssetModel<T>, R>({required T model, AssetBundle? assetBundle})`:

- If `R == List<T>`, decodes JSON array to `List<T>`.
- Otherwise decodes JSON object with `model.fromJson`.

Requires models implementing `IAssetModel<T>` with `T fromJson(Map<String, dynamic> json)`.

## API — link preview & logging

| Type | Member |
|------|--------|
| `CustomLinkPreview` | `getLinkPreviewData(String url)` → `CustomLinkPreviewData?` |
| `CustomLogger` | `showError<T>(Object object, {bool isShowDebugMode = true})` |

## API — HTTP / int

| Type | Member |
|------|--------|
| `HttpResult` | `fromStatusCode(int)`, `color` getter on enum |
| `int.ext` | `randomColorValue`, `httpStatus`, `httpStatusColor` |

## API — device utility

`DeviceUtility.instance` exposes `isIpad`, `shareMailText`, `initPackageInfo`, `getUniqueDeviceId`, and `deviceUtils` platform abstraction.

## API — `GlobalKey<T State>.ext`

| Member | Role |
|--------|------|
| `rendererBox` | `RenderBox?` from `findRenderObject` |
| `offset` | global origin |
| `height` | box height |
| `scrollToWidget({alignmentPolicy})` | `Scrollable.ensureVisible` |

## API — `Image.ext`

| Getter | Role |
|--------|------|
| `rightRotation`, `upRotation`, `bottomRotation`, `leftRotation` | `RotationTransition` with fixed `AlwaysStoppedAnimation` turns |

## API — `widget.ext`

See `kartal-theming-navigation` for `toVisible`, `toDisabled`, `sliver`.

## API — primitives

| Receiver | `ext` members |
|----------|---------------|
| `bool?` | `isSuccess`, `isFail` |
| `Color` | `randomColor` (`MaterialColor` from `Colors.primaries`), `withOpacity(double opacity)` (`Color.withValues`) |
| `DateTime` / `DateTime?` | `differenceTime({DateLocalizationLabel localizationLabel})` — relative human string |
| `File` | `fileType`, `isImageFile`, `isVideoFile`, `isAudioFile`, `isTextFile` |

## Example — asset decode

```dart
final posts = await BundleDecoder('assets/posts.json')
    .crackBundle<Post, List<Post>>(model: Post());
```

## When NOT to use

- Arbitrary HTML parsing security concerns without sanitization.
- Large Dio fetches on UI thread for preview — consider caching.

## Gotchas

- `File` APIs use conditional imports (`dart:io` vs web); unavailable platforms need guards.
- `CustomLogger` is debug-oriented (`kDebugMode` gate with `isShowDebugMode`).

## Import

```dart
import 'package:kartal/kartal.dart';
```
