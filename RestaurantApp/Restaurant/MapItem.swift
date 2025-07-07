//
//  MapItem.swift
//  RestaurantApp
//
//  Created by Billie Hartanto on 28/06/25.
//

import Foundation
import MapKit

struct MapItem:Codable, Equatable, Identifiable{
    var id : String?
    var name : String
    var phoneNumber : Int?
    var addressString : String
    var postalCode : String?
    
    let latitude : Double
    let longitude : Double
    init(item : MKMapItem){
        id = item.id
        name = item.name ?? "No Name"
        phoneNumber = Int(item.phoneNumber ?? "N")
        latitude = item.placemark.coordinate.latitude
        longitude = item.placemark.coordinate.longitude
        let placemark = item.placemark
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
        if address.isEmpty{
            self.addressString = "No address found"
        }else{
            self.addressString = address
        }
    }
    var coordinate : CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    static func == (lhs: MapItem, rhs: MapItem) -> Bool {
        lhs.id == rhs.id
    }
}
