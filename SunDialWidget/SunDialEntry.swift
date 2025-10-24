// SunDialEntry.swift
import WidgetKit
import Foundation

struct SunDialEntry: TimelineEntry {
    let date: Date
    let sunrise: Date
    let sunset: Date
    let SunDialStart: Date
    let SunDialEnd: Date
    let location: String

    // Computed properties for widget display
    var currentProgress: Double {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? date

        let totalDaySeconds = endOfDay.timeIntervalSince(startOfDay)
        let currentSeconds = date.timeIntervalSince(startOfDay)

        return currentSeconds / totalDaySeconds
    }

    var sunriseProgress: Double {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: sunrise)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? sunrise

        let totalDaySeconds = endOfDay.timeIntervalSince(startOfDay)
        let sunriseSeconds = sunrise.timeIntervalSince(startOfDay)

        return sunriseSeconds / totalDaySeconds
    }

    var sunsetProgress: Double {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: sunset)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? sunset

        let totalDaySeconds = endOfDay.timeIntervalSince(startOfDay)
        let sunsetSeconds = sunset.timeIntervalSince(startOfDay)

        return sunsetSeconds / totalDaySeconds
    }
}
