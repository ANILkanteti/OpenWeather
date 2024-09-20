//
//  LocationManager.swift
//  OpenWeather
//
//  Created by Anil Kumar on 8/19/24.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    @Published var city: String?
    @Published var locationPermissionGranted = false
    @Published var errorMessage: String?
    
    override init() {
        super.init()
        locationManager.delegate = self
        // Request location permission upon location object is created
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationPermissionGranted = true
            requestLocation()
        } else {
            locationPermissionGranted = false
            errorMessage = "Location permission not granted."
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                self?.errorMessage = "Failed to get city name: \(error.localizedDescription)"
                return
            }
            if let city = placemarks?.first?.locality {
                DispatchQueue.main.async {
                    self?.city = city
                }
            } else {
                self?.errorMessage = "Failed to find city for location."
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorMessage = "Failed to find user's location: \(error.localizedDescription)"
    }
}
