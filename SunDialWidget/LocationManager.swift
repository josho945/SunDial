// LocationManager.swift
import CoreLocation
import Foundation

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var locationContinuation: CheckedContinuation<CLLocationCoordinate2D, Never>?
    private var currentLocation: CLLocationCoordinate2D?
    private let fallback = CLLocationCoordinate2D(latitude: -34.4278, longitude: 150.8931) // Wollongong, AU

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyKilometer
    }

    func getCurrentLocation() async -> CLLocationCoordinate2D {
        // Return cached location if available
        if let currentLocation = currentLocation {
            return currentLocation
        }

        // Widgets cannot present permission UI. If not authorized, bail out fast.
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            break // proceed to request a one-shot fix
        default:
            return fallback
        }

        // Attempt a one-shot location request, but fail fast to avoid WidgetKit timeouts.
        return await withCheckedContinuation { continuation in
            self.locationContinuation = continuation
            manager.requestLocation()

            // Safety timeout: resume with fallback if no fix arrives quickly.
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 800_000_000) // 0.8s
                if let cont = self.locationContinuation {
                    self.locationContinuation = nil
                    self.currentLocation = fallback
                    cont.resume(returning: fallback)
                }
            }
        }
    }

    func getLocationName(for coordinate: CLLocationCoordinate2D) async -> String {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            if let placemark = placemarks.first {
                return placemark.locality ?? placemark.administrativeArea ?? "Unknown Location"
            }
        } catch {
            print("Geocoding error: \(error)")
        }

        return "Unknown Location"
    }

    // MARK: - CLLocationManagerDelegate

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        currentLocation = location.coordinate
        locationContinuation?.resume(returning: location.coordinate)
        locationContinuation = nil
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error)")
        // Return default location on error
        let defaultLocation = fallback
        currentLocation = defaultLocation
        locationContinuation?.resume(returning: defaultLocation)
        locationContinuation = nil
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            let defaultLocation = fallback
            currentLocation = defaultLocation
            locationContinuation?.resume(returning: defaultLocation)
            locationContinuation = nil
        default:
            break
        }
    }
}
