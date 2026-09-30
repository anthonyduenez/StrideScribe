# StrideScribe

> **Project status: Shelved**

StrideScribe is an iOS running and activity-tracking application built to help users record workouts, monitor progress, and build consistent fitness habits through a focused mobile experience.

This project is preserved as a completed software-development and mobile-application learning project. No further features or maintenance are currently planned.

## Overview

StrideScribe connects three moments in one running workflow:

1. Start a run from a map showing the current location.
2. Track distance, pace, elapsed time, and location updates while running.
3. Review completed runs with saved statistics and route details.

The app is built with SwiftUI and uses a shared observable tracker to keep the active run state available across the app's views.

## Features

- Start a running session from a live map.
- Track GPS location updates during a run.
- Calculate distance, pace, and elapsed time in real time.
- Pause, resume, and stop a run using deliberate long-press controls.
- Provide haptic feedback for important run controls.
- Save completed runs locally.
- Review activity history with date, distance, duration, and pace.
- View a completed run's route and detailed statistics.
- Continue location tracking with background-task support.

## Tech Stack

- **Language:** Swift
- **Platform:** iOS
- **IDE:** Xcode
- **UI:** SwiftUI
- **Maps and location:** MapKit, Core Location
- **Persistence:** UserDefaults

## Architecture and Project Structure

The `runTracker` observable object owns the active run state, location manager, timer, route locations, and saved run history. It is created by the app entry point and injected into the SwiftUI environment so the map, live run screen, stop screen, activity history, and run detail views can share the same state.

```text
StrideScribe/
├── StrideScribe.xcodeproj
├── StrideScribe/
│   ├── StrideScribeApp.swift
│   ├── StrideTabView.swift
│   ├── ContentView.swift
│   ├── runView.swift
│   ├── StopView.swift
│   ├── CountdownView.swift
│   ├── ActivityView.swift
│   ├── RunDetailView.swift
│   ├── runTracker.swift
│   └── Assets.xcassets/
```

## Getting Started

### Prerequisites

- macOS
- Xcode
- iOS Simulator or a connected iPhone

### Installation

Clone the repository:

```bash
git clone https://github.com/anthonyduenez/StrideScribe.git
```

Open the project in Xcode:

```bash
open StrideScribe.xcodeproj
```

Build and run the application using the iOS Simulator or a connected device.

## Documentation

Additional project documentation is available in the [StrideScribe documentation page](https://www.notion.so/StrideScribe-Documentation-30ede2abd6a0807eaf39f86e454ddcaa?source=copy_link).

## Author

Anthony Duenez Ramirez
