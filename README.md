# SwingSpeed

A mobile app that measures peak golf swing speed using your phone's built-in IMU sensors. Attach the phone to a club shaft or simply hold it in your hand and swing. No external hardware required.

## Features

### Two Swing Modes

**Club Mount** — Attach the phone to the mid-shaft of a golf club. The app measures angular velocity at the attachment point and calculates club head speed based on the distance to the club head.

**Freehand** — Hold the phone in your hand (screen facing target, like a club face) and swing without a club. The app estimates club head speed for any selected club type using:
- Your arm length (configurable)
- Standard shaft length for the selected club (14 types: Driver through Putter)
- Dynamic wrist lag detection

### Swing Metrics

Each detected swing reports:

| Metric | Description |
|--------|-------------|
| **Peak Speed** | Maximum club head speed in mph |
| **Duration** | Gate-open time of the swing arc |
| **Attack Angle** | Vertical angle at impact — positive = hitting up, negative = hitting down |
| **Swing Path** | Horizontal deviation at impact — in-to-out or out-to-in |
| **Lag Factor** | Detected wrist lag multiplier (freehand mode) |

### Dynamic Wrist Lag Detection

In freehand mode, the app analyzes the angular acceleration profile during each swing to detect wrist lag automatically:

- **Phase 1** (early downswing): gradual acceleration — arms pulling, wrists cocked
- **Phase 2** (late downswing): sharp acceleration spike — wrist release

The ratio of peak acceleration between phases determines the lag factor (1.0x = no lag, up to 1.5x = pro-level release). This is applied per-swing to the estimated speed.

### Session Tracking

- **Live gauge** — animated speed arc updates at 30Hz during the swing
- **Auto-detection** — swings are detected automatically via gyroscope threshold (no button press needed)
- **Per-swing result card** — flashes after each swing with all metrics
- **Session summary** — swing count, peak, average, consistency score (0-100), speed distribution chart, and swing-by-swing timeline
- **Personal best** tracking across all sessions
- **Session history** with trend line chart

### Club Types (Freehand Mode)

Standard shaft lengths for accurate estimation:

| Club | Shaft Length |
|------|-------------|
| Driver | 45.5" (1.156m) |
| 3 Wood | 43" (1.092m) |
| 5 Wood | 42" (1.067m) |
| 3 Hybrid | 40" (1.016m) |
| 4 Hybrid | 39" (0.991m) |
| 5 Iron | 38" (0.965m) |
| 6 Iron | 37.5" (0.953m) |
| 7 Iron | 37" (0.940m) |
| 8 Iron | 36.5" (0.927m) |
| 9 Iron | 36" (0.914m) |
| Pitching Wedge | 35.5" (0.902m) |
| Sand Wedge | 35.25" (0.895m) |
| Lob Wedge | 35" (0.889m) |
| Putter | 34" (0.864m) |

## How It Works

### Sensor Pipeline

```
Gyroscope (100Hz) → Angular Magnitude → 5-Sample Rolling Average
  → Swing Gate State Machine (IDLE → OPEN → COOLDOWN)
  → Peak Tracking + Axis Decomposition
  → Speed: v = omega_peak x r x 2.23694 (mph)
  → Attack Angle & Swing Path from gyro axis ratios at peak
  → Dynamic Lag Factor from acceleration profile analysis
```

### Swing Detection

The app uses a 3-state gate to detect swings automatically:
- **IDLE** → angular velocity exceeds start threshold (default 3.0 rad/s) → **OPEN**
- **OPEN** → tracks peak; angular velocity drops below end threshold (1.0 rad/s) → **COOLDOWN**
- **COOLDOWN** → 1.5s ignore window prevents double-counting → **IDLE**

### Speed Calculation

- **Club mode**: `speed = omega_peak x club_offset x 2.23694`
- **Freehand mode**: `speed = omega_peak x (arm_length + shaft_length) x lag_factor x 2.23694`

## Tech Stack

| Component | Technology |
|-----------|-----------|
| Framework | Flutter (iOS + Android) |
| State Management | Riverpod |
| Local Database | Drift (SQLite) |
| Charts | fl_chart |
| Sensor Access | sensors_plus |
| Stream Processing | rxdart |

## Visual Design

Augusta Dark theme inspired by classic golf aesthetics:
- Deep forest green (`#1A2F1A`) background
- Gold (`#C9A84C`) accents
- Playfair Display serif headings
- Inter sans-serif data typography

## Data Storage

All data is stored locally on-device using SQLite. No cloud services, no accounts, no network required. Sessions persist across app restarts with automatic recovery of interrupted sessions.

## Settings

| Setting | Description | Default |
|---------|-------------|---------|
| Swing Mode | Club Mount or Freehand | Club |
| Club Length Offset / Arm Length | Pivot distance in meters | 0.5m / 0.7m |
| Club Type (freehand) | Which club to estimate for | Driver |
| Lag Fallback (freehand) | Used when auto-detection has too few samples | 1.2x |
| Start Threshold | Angular velocity to trigger swing detection | 3.0 rad/s |
| End Threshold | Angular velocity to end swing detection | 1.0 rad/s |
| Cooldown | Ignore window after swing | 1500ms |

## Building

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run
```

### Release Build (Android)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

## Testing

```bash
flutter test
```

27 tests covering: data models, database DAOs, commit transaction, speed calculator, swing detector state machine, widget rendering, and full session lifecycle integration.
