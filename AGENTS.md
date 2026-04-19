# FitForge — Project State & Agent Handoff

## Goal

Build "FitForge" — a cross-platform (Android + iOS + Web) fitness app combining workout tracking (inspired by Verifit) with intelligent workout generation (inspired by gym-workout-generator). The app must be fully standalone with local storage (Drift/SQLite), optional WebDAV sync for backup, and progressive overload targets driven by actual workout history.

## Instructions

- **Framework**: Flutter (Dart) — chosen for cross-platform Android + iOS support
- **Architecture**: MVVM + Repository pattern with Riverpod state management
- **Storage**: Drift (SQLite) — NOT SharedPreferences (Verifit's approach was identified as an anti-pattern)
- **WebDAV**: CSV import/export for Verifit backward compatibility, manual sync (not auto-polling)
- **Workout generator**: Embedded (no API calls), works fully offline
- **Progressive overload**: Linear progression — when target reps are HIT, weight increases 5% and reps drop by 2. When target reps are MISSED, weight stays the same and reps DECREASE by 2 (NOT increase — user explicitly corrected this)
- **Units**: Configurable lbs/kg, default lbs
- **App must be fully standalone** — no server infrastructure dependency
- **Name**: FitForge (not Verifit, not gym-workout-generator)
- **Full feature parity with Verifit** for v1.0 + workout generation
- **Seed data format**: Hardcoded Dart list
- **6-tab navigation**: Home / Workout / Generate / Exercises / History / Settings
- **Workout tab** is the user's "paper workout document" — tied to the date selected on Home, fully editable (add exercises, reorder via long-press drag, edit weight/reps targets, delete), with a "Start Workout" button at the bottom that triggers the guided session flow. No play button in the AppBar — the bottom Start Workout button is sufficient.
- **Generate tab** creates workout routines and inserts them as "planned" (empty) sets into a specific date (user selects date). After generation: options are "Start Workout" (goes to Workout tab), "Add to Calendar" (goes to Workout tab), "Create Another" (stays on Generate)
- **Home screen** shows calendar with date carousel and day view of all sets for the selected date. Two FABs: small `+` for add exercise, large `play_arrow` for navigate to Workout tab
- **Bodyweight exercises** (push-ups, pull-ups, planks, etc.) must NOT show a weight field — display as `x reps` not `0 x reps`
- **Exercises must be editable** — user can customize sets/reps/rest/equipment/instructions on any exercise
- **Custom exercises** can be added via the Exercises tab
- **Version displayed as v0.1.1**
- **Exercise reorder**: Long-press drag on ReorderableListView. Order is persisted via `displayOrder` column in WorkoutSets table. DAO queries order by `displayOrder` then `id`.
- **"planned" badge removed** from Workout tab set rows — planned sets just show in muted color
- **"Log" renamed to "Edit"** on Workout tab
- **Edit Set dialog** has a red Delete button alongside Cancel/Save
- **Workout log screen (Edit popup)**: Back button goes to `/workout` by default, accepts optional `returnPath` param. Has edit (pencil) icon and delete (X) icon per set row, with 8px spacing between for fat fingers.
- **Workout session**: "Start Exercise" button is large (56px height, 28px play icon). Exit button goes to `/workout` not `/home`. Finished view: "Back to Workout" (primary, goes to /workout) + "Go Home" (secondary, goes to /home).
- **Date in Workout tab** is tappable — opens DatePicker via `showDatePicker`
- **WebDAV**: Credentials form works, but connection testing has known issues (times out even with 10s timeout added — likely a CORS or network issue on the dev machine, not a code bug)
- **Web deployment**: Must serve `sqlite3.wasm` and `drift_worker.js` from `web/` directory, use `WasmDatabase.open` (not the old `WebDatabase`), and run with COOP/COEP headers

## Discoveries

- **Drift on web** requires `sqlite3.wasm` (from sqlite3.dart releases) and `drift_worker.js` (from drift releases) placed in `web/` directory. Must use `WasmDatabase.open()` with `databaseName`, `sqlite3Uri`, `driftWorkerUri`. The old `WebDatabase`/`DriftWebStorage.indexedDb` approach fails with "can't access sql.js library" error.
- **Drift versions**: drift 2.28.2, sqlite3 2.9.4 (check pubspec.lock for exact versions when downloading web assets)
- **Drift `withDefault`** for integer columns uses `const Constant(0)` NOT `const Value(0)`
- **Web server command**: `flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080 --web-header=Cross-Origin-Opener-Policy=same-origin --web-header=Cross-Origin-Embedder-Policy=require-corp`
- **No X display on dev machine** — Chrome can't launch directly, must use `-d web-server`
- **Firewall**: `sudo iptables -I INPUT -p tcp --dport 8080 -j ACCEPT` needed to expose port to LAN
- **sqlite3 shared library** for native tests: `LD_LIBRARY_PATH=/home/linuxbrew/.linuxbrew/lib` required before running `flutter test`
- **riverpod_generator** and **custom_lint/riverpod_lint** incompatible with Dart 3.11.4 (pull in analyzer_plugin 0.12.0). Providers are written manually.
- **Drift table syntax**: Must use getter syntax (`TextColumn get name => text()();`) not field syntax
- **Drift test naming conflict**: `isNull`/`isNotNull` exist in both `drift` and `flutter_test` — use `hide` prefix in imports
- **Drift `NativeDatabase.createInBackground()`** requires `import 'package:drift/native.dart'` and `import 'dart:io' as io`
- **`currentDateAndTime`** (not `currentTimestampAndDate`) is the correct Drift function for dateTime defaults
- **Verifit CSV format**: `Date,Exercise,Category,Weight (kg),Reps,Comment` — comma-separated, no quoting/escaping
- **`webdav_client` package API**: Use `webdav.newClient(url, user: username, password: password)` to create client, `client.ping()` to test, `client.readDir(path)` to list files, `client.write(path, Uint8List)` to upload, `client.read(path)` returns `List<int>`, `client.remove(path)` to delete
- **ConsumerWidget limitation**: `ref` is only available inside the `build` method, not in helper methods. Must pass `WidgetRef ref` as parameter to helper methods that need it.
- **Flutter 3.41.6 requires**: Android SDK 36, build-tools 28.0.3, JDK 21 (full JDK with javac, not just JRE)
- **APK build** requires JAVA_HOME set to `/usr/lib/jvm/java-21-openjdk-amd64` and ANDROID_HOME set to the SDK path
- **GoRouter `context.pop()`** doesn't always work for full-screen routes on the root navigator — prefer `context.go('/path')` with explicit return paths, or use `Navigator.pop(context)` for dialogs

## Accomplished

### Session 1 — COMPLETE
- Initialized Flutter project, configured pubspec.yaml, strict analysis options
- Core theme (Material 3, light/dark, indigo seed), GoRouter with 5-tab navigation
- Drift database schema (3 tables: Exercises, WorkoutSets, Settings), DAOs, repositories
- Domain models with Freezed, WorkoutGenerator, ProgressiveTargetCalculator
- Riverpod providers, 5 screen stubs, GitHub Actions CI

### Session 2 — COMPLETE
- Exercise seed data (~100 exercises), exercise seed provider
- Unit tests for WorkoutRepository, ExerciseRepository, WorkoutGenerator, ProgressiveTargetCalculator
- HomeScreen with date carousel and workout day view
- Fixed Drift test issues (in-memory databases, isNull/isNotNull conflicts, libsqlite3 path)
- `AppDatabase.forTesting(QueryExecutor)` constructor for test databases
- Fixed `getLastSetForExercise` to sort by `id` as tiebreaker when `createdAt` matches
- All 30 tests passing

### Session 3 — COMPLETE
- Workout log screen with weight/reps input, rest timer, edit/delete, back button
- Exercise browser with search and body part tabs
- Workout generation screen with type/difficulty/duration/muscle selectors
- History screen with diary view (month navigation, expandable entries)
- Settings screen (theme, units, progression info, WebDAV, clear data)
- Added `getSetsForMonth` and `getSetsForDateRange` DAO/repository methods
- All routes: /log-workout, /workout-session, /exercise-detail

### Session 4 — COMPLETE
- History charts tab using fl_chart (volume over time line chart, exercise frequency bar chart, period selector)
- Exercise detail screen (instructions, equipment, PR display, favorite toggle, edit button, log-from-detail CTA)
- WebDAV sync service (CSV export/import, test connection with 10s timeout, upload/download/delete backups)
- Settings: full WebDAV configuration bottom sheet with test/save/export/import

### Session 5 — COMPLETE (Web deployment + Bug fixes)
- Fixed Drift web support: conditional imports (`database_setup.dart` exports `database_setup_io.dart` if native, `database_setup_web.dart` if web)
- Downloaded `sqlite3.wasm` (from sqlite3.dart releases) and `drift_worker.js` (from drift releases) to `web/`
- Switched web database from `WebDatabase.withStorage(DriftWebStorage.indexedDb(...))` to `WasmDatabase.open(...)`
- Web build succeeds, web server accessible on LAN at http://192.168.0.240:8080
- User tested the app in browser and provided detailed feedback

### Session 6 — COMPLETE (User feedback iteration — MAJOR changes)
- **Added `isBodyweight` column** to Exercises table (schema v2, migration added)
- Updated seed data with `_bodyweightExercises` set and post-processing in `buildExerciseSeed()`
- **Workout log screen**: Added back button (`go_router` `context.go('/home')`), hidden weight field for bodyweight exercises, display `x reps` not `0 x reps`, bodyweight validation allows weight=0
- **Exercise edit**: Added edit button on exercise detail screen with dialog to customize sets/reps/rest/equipment/instructions
- **Custom exercises**: Added `+` button on exercise browser with full form (name, type, difficulty, body part, sets, reps, rest, equipment, instructions)
- **Progression fix**: `calculate()` now decreases reps by `repIncreaseStep` (2) when target MISSED (was incorrectly increasing). `calculateForExercise()` also fixed.
- **Planned sets**: `addPlannedExercises()` in WorkoutRepository adds exercises with weight=0, comment='planned'. Home screen displays planned sets in muted color with `x reps` format, hides 'planned' comment
- **Generate workflow redesign**: Date selector added (DatePicker, supports future dates), post-generation actions: "Start Workout" (adds to calendar + goes to Workout tab), "Add to Calendar" (adds + goes to Workout tab), "Create Another" (stays on Generate)
- **Home screen**: Two FABs — small `+` for add exercise, large `play_arrow` for navigate to Workout tab
- **Version**: Changed from v1.0.0 to v0.1.0

### Session 7 — COMPLETE (Workout Tab)
- **Created `selectedDateProvider`** (StateProvider<DateTime>) in app_providers.dart — shared between Home and Workout tabs
- **Created Workout tab screen** (`workout_tab_screen.dart`):
  - Shows exercises for the selected date from `selectedDateProvider`
  - `StreamBuilder` watches sets for date, groups by exercise name
  - Empty state with "Add Exercise" and "Generate Workout" buttons
  - `ReorderableListView` for drag-to-reorder exercises (long-press to drag)
  - `_ExerciseSectionCard` for each exercise group: exercise name (tappable → exercise detail), delete button (X), sets list (tap to edit), "+ Set" and "Edit" buttons
  - `_AddExerciseBottomSheet` — searchable exercise picker that adds planned sets
  - "Start Workout" button at bottom of screen
- **Updated Home screen** to use `selectedDateProvider` instead of local `_selectedDate` state
- **Updated Generate screen** — "Start Workout" and "Add to Calendar" both redirect to `/workout` tab and set `selectedDateProvider`
- **Updated router** (`app.dart`) — 6 tabs: Home / Workout / Generate / Exercises / History / Settings

### Session 8 — COMPLETE (User feedback on Workout tab — Polish iteration)
- **Workout tab date is tappable** — `showDatePicker` on the date in the AppBar, with calendar icon
- **Removed explicit drag handle icon** — was showing duplicate handles. Now relies purely on `ReorderableListView`'s built-in long-press drag behavior (no custom `ReorderableDragStartListener` icon)
- **Removed play_arrow from AppBar** — only the bottom "Start Workout" button remains
- **Exercise reorder now persists** — added `displayOrder` column to `WorkoutSets` table (schema v3, migration). `onReorder` calls `_persistReorder()` which writes new displayOrder values to the database. DAO queries (`watchSetsForDate`, `getSetsForDate`) now order by `displayOrder ASC, id ASC`.
- **Removed "planned" badge** from set rows — planned sets still show in muted color but no badge
- **Renamed "Log" to "Edit"** on Workout tab
- **Removed pencil icon** from Workout tab set rows — edit is only available via the "Edit" button or tapping a set row
- **Added X (delete) icon** in log/edit popup — red close icon next to pencil with 8px spacing
- **Added Delete button** to Edit Set dialog — red TextButton alongside Cancel/Save
- **Fixed back button in log/edit popup** — accepts `returnPath` param, defaults to `/workout`
- **"Start Exercise" button** — made larger (56px height, size 28 play icon, fontSize 18)
- **Exit button** redirects to `/workout` instead of `/home`
- **Finished view** — "Back to Workout" (primary, →/workout) + "Go Home" (secondary, →/home)
- **Version bumped** to v0.2.0 (pubspec.yaml: 0.2.0+2, settings screen: 'v0.2.0')
- All 30 tests passing, 0 analyze errors

## Schema

### Database version: 3

**Exercises table**:
- id (PK, autoIncrement)
- name (text, unique)
- bodyPart (text)
- exerciseType (text) — strength/cardio/flexibility/hiit
- difficulty (text) — beginner/intermediate/advanced
- defaultSets (int)
- defaultReps (text, comma-separated) — e.g. "12,10,8"
- defaultRestSeconds (int)
- equipment (text, nullable)
- instructions (text, nullable)
- isBodyweight (bool, default false) — added in v2
- isFavorite (bool, default false)
- isCustom (bool, default false)

**WorkoutSets table**:
- id (PK, autoIncrement)
- date (text) — "yyyy-MM-dd" format
- exerciseName (text)
- bodyPart (text)
- weight (real)
- reps (real)
- comment (text, nullable) — "planned" for unlogged sets
- restSeconds (int, nullable)
- displayOrder (int, default 0) — added in v3, for exercise reorder persistence
- createdAt (dateTime, default now)

**Settings table**:
- key (text, PK)
- value (text)

## Relevant files / directories

### Source code (primary project)
- `/home/william/Projects/fitforge/` — The FitForge Flutter project root
- `lib/main.dart` — App entry point
- `lib/app.dart` — GoRouter with 6-tab NavigationBar (Home/Workout/Generate/Exercises/History/Settings) + full-screen routes
- `lib/core/` — Theme, constants, extensions
- `lib/core/constants/app_constants.dart` — App constants including progression rates
- `lib/data/database/app_database.dart` — Drift database definition, schemaVersion=3, migrations for isBodyweight (v2) and displayOrder (v3)
- `lib/data/database/database_setup.dart` — Conditional export: IO or Web
- `lib/data/database/database_setup_io.dart` — Native SQLite setup (path_provider + NativeDatabase)
- `lib/data/database/database_setup_web.dart` — Web WASM setup (WasmDatabase.open)
- `lib/data/database/tables/` — exercises_table.dart (has isBodyweight), workout_sets_table.dart (has displayOrder), settings_table.dart
- `lib/data/database/dao/` — exercise_dao.dart, workout_set_dao.dart (+ getSetsForMonth, getSetsForDateRange, updateDisplayOrders, ordered by displayOrder), settings_dao.dart
- `lib/data/repositories/` — workout_repository.dart (has addPlannedExercises, reorderExercises), exercise_repository.dart (has addCustomExercise), settings_repository.dart
- `lib/data/seed/exercise_seed.dart` — ~100 exercises with bodyweight marking via _bodyweightExercises set
- `lib/data/sync/webdav_sync_service.dart` — WebDAV CSV sync with 10s timeouts
- `lib/domain/generator/progressive_target_calculator.dart` — Linear progression: missed reps decrease by 2, hit reps increase weight 5%
- `lib/domain/generator/workout_generator.dart` — Exercise generation logic
- `lib/domain/models/` — workout_day.dart, exercise_personal_stats.dart, workout_generation_request.dart (all with Freezed .freezed.dart/.g.dart files)
- `lib/presentation/providers/app_providers.dart` — All Riverpod providers including `selectedDateProvider` and `webdavSyncProvider`
- `lib/presentation/screens/home/home_screen.dart` — Date carousel + workout day view, uses selectedDateProvider, two FABs (+ and play_arrow→/workout)
- `lib/presentation/screens/workout/workout_tab_screen.dart` — Workout tab: ReorderableListView (long-press drag, persisted via displayOrder), exercise section cards, add exercise sheet, date picker in AppBar, Start Workout button at bottom
- `lib/presentation/screens/log_workout/workout_log_screen.dart` — Weight/reps input, rest timer, edit+delete icons per set, back button (accepts returnPath), bodyweight exercise support
- `lib/presentation/screens/workout_session/workout_session_screen.dart` — Guided session flow (walks through GeneratedWorkout exercises), large Start Exercise button, Exit→/workout, finished view with Back to Workout + Go Home
- `lib/presentation/screens/exercise_browser/exercise_browser_screen.dart` — Search + body part tabs, + custom exercise button
- `lib/presentation/screens/exercise_detail/exercise_detail_screen.dart` — Detail with edit button, PRs, favorite, log CTA
- `lib/presentation/screens/generate_workout/generate_workout_screen.dart` — Date picker, type/difficulty/duration/muscle selectors, post-gen actions (Start/Add/Create Another)
- `lib/presentation/screens/history/history_shell.dart` — Diary tab (month nav, expandable entries) + Charts tab
- `lib/presentation/screens/history/workout_charts_tab.dart` — Volume line chart, exercise frequency bar chart (fl_chart)
- `lib/presentation/screens/settings/settings_screen.dart` — Theme, units, progression, WebDAV config sheet, clear data, v0.2.0

### Web assets
- `web/sqlite3.wasm` — SQLite WebAssembly (from sqlite3.dart release 2.9.4)
- `web/drift_worker.js` — Drift web worker (from drift release 2.28.2)
- `web/index.html` — Standard Flutter web entry point

### Tests
- `test/data/repositories/workout_repository_test.dart`
- `test/data/repositories/exercise_repository_test.dart`
- `test/domain/generator/workout_generator_test.dart`
- `test/domain/generator/progressive_target_calculator_test.dart`
- `test/widget_test.dart`

### Config
- `pubspec.yaml` — version 0.2.0+2
- `analysis_options.yaml`
- `.github/workflows/ci.yml`

### Reference projects
- `/home/william/Projects/verifit/` — Verifit (Java Android app, reference for tracking features)
- `/home/william/Projects/gym-workout-generator/` — gym-workout-generator (Python FastAPI, reference for generation)

### Build commands

#### Run tests
```bash
LD_LIBRARY_PATH=/home/linuxbrew/.linuxbrew/lib:$LD_LIBRARY_PATH ~/Projects/flutter/bin/flutter test
```
Note: The LD_LIBRARY_PATH is needed on lobstertank (this machine) for libsqlite3. On the new desktop, check if sqlite3 dev libs are installed, or install via `sudo apt install libsqlite3-dev`.

#### Run web server
```bash
flutter run -d web-server --web-hostname 0.0.0.0 --web-port 8080 --web-header=Cross-Origin-Opener-Policy=same-origin --web-header=Cross-Origin-Embedder-Policy=require-corp
```

#### Build APK
```bash
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
export ANDROID_HOME=$HOME/Android/Sdk
flutter build apk --release
# APK at: build/app/outputs/flutter-apk/app-release.apk
```

#### Regenerate Drift code
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Next steps / v0.2.0 features

The major features for the next checkpoint (v0.2.0) are **data export** and **WebDAV sync**:

1. **Data export** — Allow users to export their workout data as CSV (Verifit-compatible format). Must work on both mobile and web.
2. **WebDAV sync** — Fix the connection testing timeout issue (likely CORS on web, but should work on mobile). Ensure upload/download/delete of backup files works reliably.
3. **Build and publish release APK** — Create a v0.2.0 GitHub release with the APK attached.
4. **More widget tests** — The current 30 tests cover repository and domain layers. Need widget tests for screens.
5. **Charts improvements** — 1RM trends, bodyweight exercise tracking, better period selectors.
6. **General polish** — Loading states, error handling, edge cases.

## Known issues

- **WebDAV connection test** times out even with 10s timeout — likely a CORS issue when running on web, but needs re-testing on mobile where CORS doesn't apply
- **No Android SDK 36 or build-tools 28.0.3** on lobstertank — Flutter 3.41.6 requires these for APK builds. Need to install on the new desktop.
- **Only JRE installed** on lobstertank, not JDK — `javac` is missing so APK builds fail. Need `openjdk-21-jdk-headless` on the new desktop.
- **lobstertank disk is nearly full** (was 100% at one point, now ~96%). The new desktop should have plenty of space for builds.