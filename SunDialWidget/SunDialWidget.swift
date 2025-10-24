//
//  SunDialWidget.swift
//  SunDialWidget
//
//  Created by Josh Kinnear on 12/9/2025.
//

import WidgetKit
import SwiftUI

@main
struct SunDialWidgetBundle: WidgetBundle {
    var body: some Widget {
        SunDialWidget()
    }
}

struct SunDialWidget: Widget {
    let kind: String = "SunDialWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: SunDialProvider()) { entry in
            SunDialWidgetEntryView(entry: entry)
                .padding()
        }
        .configurationDisplayName("SunDial")
        .description("Track sunrise, sunset, and golden hour times with a beautiful solar arc.")
        .supportedFamilies([.systemMedium, .systemLarge])
        .containerBackgroundRemovable(false)
    }
}

#Preview(as: .systemMedium) {
    SunDialWidget()
} timeline: {
    SunDialEntry(
        date: .now,
        sunrise: Calendar.current.date(bySettingHour: 5, minute: 33, second: 0, of: .now) ?? .now,
        sunset: Calendar.current.date(bySettingHour: 20, minute: 56, second: 0, of: .now) ?? .now,
        SunDialStart: Calendar.current.date(bySettingHour: 5, minute: 0, second: 0, of: .now) ?? .now,
        SunDialEnd: Calendar.current.date(bySettingHour: 21, minute: 30, second: 0, of: .now) ?? .now,
        location: "Unknown Location"
    )
}
