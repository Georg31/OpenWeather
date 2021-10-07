//
//  LocationManager.swift
//  WeatherApp
//
//  Created by George Digmelashvili on 10/4/21.
//

import UIKit
import CoreLocation

protocol LocationServiceDelegate {
    func tracingLocation(currentLocation: CLLocationCoordinate2D)
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var delegate: LocationServiceDelegate?
    let locationManager : CLLocationManager!
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
    }
    
    
    func retreiveCoordinates(name: String, completionHandler: @escaping ([CLPlacemark]?) -> Void){
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(name) { placeMarks, error in
            completionHandler(placeMarks)
        }
    }
    
    func handleUserLocation(){
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            manager.startUpdatingLocation()
            break
        case .authorizedAlways:
            manager.startUpdatingLocation()
            break
        case .denied:
            break
        case .notDetermined:
            manager.requestAlwaysAuthorization()
            break
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {return}
        locationManager.stopUpdatingLocation()
        let coordinate = location.coordinate
        self.delegate?.tracingLocation(currentLocation: coordinate)
        
    }
}
