import Foundation
import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func locationManager(_ manager: LocationManager, didUpdateLocations locations: [CLLocation])
    func locationManager(_ manager: LocationManager, didFailWithError error: Error)
    func locationManagerWantsToShowLocationServicesAreDisabledError(_ manager: LocationManager)
}

final class LocationManager: NSObject, CLLocationManagerDelegate {
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        return locationManager
    }()

    weak var delegate: LocationManagerDelegate?

    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        delegate?.locationManager(self, didUpdateLocations: locations)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.locationManager(self, didFailWithError: error)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            break
        case .denied, .restricted:
            delegate?.locationManagerWantsToShowLocationServicesAreDisabledError(self)
        case .notDetermined:
            requestLocationPermission()
        @unknown default:
            break
        }
    }

}
