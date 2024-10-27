//
//  LocationManager.swift
//  Weathers
//
//  Created by Nic on 10/27/24.
//

import SwiftUI
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
    
    private let manager = CLLocationManager()
    
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
