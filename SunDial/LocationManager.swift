// LocationManager.swift
import CoreLocation
import Foundation

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    private var locationContinuation: CheckedContinuation<CLLocationCoordinate2D, Never>?
    private var currentLocation: CLLocationCoordinate2D?

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

        // Check authorization status
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            return CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194) // Default to San Francisco
        default:
            break
        }

        return await withCheckedContinuation { continuation in
            self.locationContinuation = continuation
            manager.requestLocation()
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
        let defaultLocation = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        currentLocation = defaultLocation
        locationContinuation?.resume(returning: defaultLocation)
        locationContinuation = nil
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted:
            let defaultLocation = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
            currentLocation = defaultLocation
            locationContinuation?.resume(returning: defaultLocation)
            locationContinuation = nil
        default:
            break
        }
    }
}
