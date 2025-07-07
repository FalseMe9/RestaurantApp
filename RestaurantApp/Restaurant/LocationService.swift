//
//  LocationService.swift
//  Restaurant_Tab
//
//  Created by Billie Hartanto on 21/06/25.
//

import Foundation
import CoreLocation
class LocationService:NSObject{
    static let shared = LocationService()
    lazy var locationManager:CLLocationManager = {
        let manager = CLLocationManager()
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        return manager
    }()
    var locationUpdated : ((CLLocationCoordinate2D)->Void)?
    override private init(){
        super.init()
        self.requestPermissionToAccessLocation()
    }
    
    func requestPermissionToAccessLocation(){
        switch locationManager.authorizationStatus{
        case .notDetermined, .restricted:
            locationManager.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            break;
        }
    }
}

extension LocationService: CLLocationManagerDelegate{
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus{
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            break;
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate{
            locationUpdated?(location)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error.localizedDescription)
    }
    
}
