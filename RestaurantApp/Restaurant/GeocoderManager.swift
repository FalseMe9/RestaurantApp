//
//  GeocoderManager.swift
//  Restaurant_Tab
//
//  Created by Billie Hartanto on 23/06/25.
//

import SwiftUI
import CoreLocation
@MainActor
class GeocoderManager: NSObject, ObservableObject {
    @Published var addressString: String = ""
    @Published var postalCode: String?
    func reverseGeocode(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        let geocoder = CLGeocoder()

        geocoder.reverseGeocodeLocation(location){ [self] (placemarks, error) in
            if let error = error {
                print("Reverse geocode failed with error: \(error.localizedDescription)")
                self.addressString = "Unable to find address"
                return
            }

            if let placemark = placemarks?.first {
                var address = ""
                if let thoroughfare = placemark.thoroughfare {
                    address += thoroughfare + ", "
                }
                if let subThoroughfare = placemark.subThoroughfare {
                    address += subThoroughfare + ", "
                }
                if let locality = placemark.locality {
                    address += locality + ", "
                }
                if let administrativeArea = placemark.administrativeArea {
                    address += administrativeArea + ", "
                }
                self.postalCode = placemark.postalCode
                self.addressString = address
                if address.isEmpty{
                    self.addressString = "No address found"
                }
            } else {
                self.addressString = "No address found"
            }
        }
    }
}
