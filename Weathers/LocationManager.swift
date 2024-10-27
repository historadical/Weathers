//
//  LocationManager.swift
//  Weathers
//
//  Created by Nic on 10/27/24.
//

import CoreLocation
import Combine

// Conforming to `ObservableObject` allows us to bind properties of this class to our SwiftUI views.
class LocationManager: NSObject, ObservableObject {
    
    private let manager = CLLocationManager()
    
    // `@Published` properties tell SwiftUI views using them to update themselves.
    @Published var userLocation: CLLocation? = nil
    @Published var authStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        manager.requestLocation()
    }
}

// Conforming to `CLLocationManagerDelegate` allows us to get information about the user's location and auth status.
extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let userLocation = locations.last {
            DispatchQueue.main.async { [weak self] in
                self?.userLocation = userLocation
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async { [weak self] in
            self?.authStatus = status
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        // TODO: - Handle error
        print(error.localizedDescription)
    }
}
