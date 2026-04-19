---
name: kartal-async-future
description: This skill should be used when mapping a Future to Flutter widgets, adding timeouts that swallow errors, JSON-encoding a Map off the UI thread, or filtering nulls from iterables and lists. The kartal package provides future.ext, map.ext, iterable.exts, and list.ext helpers.
---

# Kartal — async UI, JSON compute, safe collections

## When to use

- Verbose `FutureBuilder` with manual `ConnectionState` switching.
- `future.timeout` with try/catch logging boilerplate.
- `jsonEncode` of large maps on the UI isolate.
- `[null, foo, bar]` cleanup or nullable list checks.

## API — `future.ext` (`FutureExtension`)

| Member | Role |
|--------|------|
| `toBuild({required onSuccess, required loadingWidget, required notFoundWidget, required onError, data})` | wraps `FutureBuilder` with `switch (snapshot.connectionState)` mapping |
| `timeoutOrNull({timeOutDuration = 10s, enableLogger = true})` | returns `null` on timeout/error; `debugPrint` in debug when logger enabled |

## API — `map.ext` (`MapExtension` on `Map<String, dynamic>`)

| Member | Role |
|--------|------|
| `safeJsonEncodeCompute()` | `compute(jsonEncode, map)` returning `Future<String?>` |

## API — `iterable.exts` (`IterableExtensions` on `Iterable<T?>`)

| Member | Role |
|--------|------|
| `makeSafe()` | filters nulls, casts to `T` |
| `makeSafeCustom(onHandle)` | custom filter + cast |

## API — `list.ext` (`ListExtension` / `ListDefaultExtension`)

| Member | Role |
|--------|------|
| `isNullOrEmpty`, `isNotNullOrEmpty` | null-safe emptiness |
| `makeSafe()` | removes null elements |
| `indexOrNull(search)` | `indexWhere` but returns `null` when `-1` |

## Example

**Before**

```dart
FutureBuilder<User>(
  future: repo.load(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const CircularProgressIndicator();
    }
    if (snapshot.hasError) return ErrorWidget(snapshot.error!);
    if (!snapshot.hasData) return const Text('No data');
    return Text(snapshot.data!.name);
  },
);
```

**After**

```dart
repo.load().ext.toBuild(
  loadingWidget: const CircularProgressIndicator(),
  notFoundWidget: const Text('No data'),
  onError: const Text('Error'),
  onSuccess: (data) => Text(data?.name ?? ''),
);
```

## When NOT to use

- Streams or `AsyncValue` from Riverpod — different primitives.
- When precise error reporting to the UI is required — `timeoutOrNull` hides errors.

## Gotchas

- `toBuild` treats `ConnectionState.done` without data as `onError`, not `notFoundWidget`.
- `list.ext` applies to `List<T>?` and non-null `List<T>` via separate extensions.

## Import

```dart
import 'package:kartal/kartal.dart';
```
