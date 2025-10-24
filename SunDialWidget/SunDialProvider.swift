// SunDialProvider.swift
import WidgetKit
import CoreLocation
import Solar

struct SunDialProvider: TimelineProvider {
    private let locationManager = LocationManager()

    func placeholder(in context: Context) -> SunDialEntry {
        SunDialEntry(
            date: Date(),
            sunrise: Calendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: Date()) ?? Date(),
            sunset: Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date()) ?? Date(),
            SunDialStart: Calendar.current.date(bySettingHour: 5, minute: 30, second: 0, of: Date()) ?? Date(),
            SunDialEnd: Calendar.current.date(bySettingHour: 18, minute: 30, second: 0, of: Date()) ?? Date(),
            location: "Loading..."
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (SunDialEntry) -> Void) {
        let entry = placeholder(in: context)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SunDialEntry>) -> Void) {
        Task {
            let entry = await createEntry()
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date()
            let timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
            completion(timeline)
        }
    }

    private func createEntry() async -> SunDialEntry {
        // Try to get current location
        let coordinate = await locationManager.getCurrentLocation()

        let currentDate = Date()
        let solar = Solar(for: currentDate, coordinate: coordinate)

        return SunDialEntry(
            date: currentDate,
            sunrise: solar?.sunrise ?? defaultSunrise(),
            sunset: solar?.sunset ?? defaultSunset(),
            SunDialStart: solar?.civilSunrise ?? defaultSunDialStart(),
            SunDialEnd: solar?.civilSunset ?? defaultSunDialEnd(),
            location: await locationManager.getLocationName(for: coordinate)
        )
    }

    private func defaultSunrise() -> Date {
        Calendar.current.date(bySettingHour: 6, minute: 30, second: 0, of: Date()) ?? Date()
    }

    private func defaultSunset() -> Date {
        Calendar.current.date(bySettingHour: 18, minute: 30, second: 0, of: Date()) ?? Date()
    }

    private func defaultSunDialStart() -> Date {
        Calendar.current.date(bySettingHour: 6, minute: 0, second: 0, of: Date()) ?? Date()
    }

    private func defaultSunDialEnd() -> Date {
        Calendar.current.date(bySettingHour: 19, minute: 0, second: 0, of: Date()) ?? Date()
    }
}
