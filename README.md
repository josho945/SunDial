# SunDial — Solar Arc Widget

SunDial is a SwiftUI + WidgetKit project that displays live solar cycle data — including sunrise, sunset, and the current position of the sun throughout the day.  

I saw a concept on Threads that mocked something like this up, and wanted to try and implement it. Took a lot longer than expected.

## Features

- Displays current local time, sunrise, and sunset.
- Animated 'live' solar arc bar (15min)
- Minimal and responsive UI built for iOS 17+.
- Completely useless app that only serves as a container for the widget

## Dependencies

This widget relies on the **Solar** Swift package (https://github.com/ceeK/Solar) to calculate sunrise and sunset times.  
> Note: The Solar dependency is **not included** in this repository. You’ll need to add it manually to the project via Swift Package Manager.

To add it manually:
1. In Xcode, go to **File → Add Packages...**
2. Enter the repository URL: `https://github.com/ceeK/Solar`
3. Select the latest stable version and add it to the `SunDialWidget` target.

## Project Structure

```
SunDial/
├── SunDial/                    # iOS app host target
│   └── SunDialApp.swift
├── SunDialWidget/              # Widget extension target
│   ├── SunDialWidgetView.swift
│   ├── SunDialWidget.swift
│   ├── LocationManager.swift
│   └── Provider.swift
└── Assets/                     # App & widget assets
```

---
**Created:** 2025-09-12  
**Author:** Josh Kinnear
**Platform:** iOS 17+ / SwiftUI / WidgetKit  
