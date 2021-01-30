//
//  LocationMapItem.swift
//  LocationPicker
//
//  Created by Idan Moshe on 30/01/2021.
//

import UIKit
import MapKit

class LocationMapItem {
    
    private let item: MKMapItem
    init(_ mapItem: MKMapItem) {
        self.item = mapItem
    }
    
    let uuid = UUID()
    
    var name: String {
        return self.item.name ?? ""
    }
    
    var coordinate: CLLocationCoordinate2D {
        return self.item.placemark.coordinate
    }
    
    var title: String {
        var text: String = ""
        
        if let thoroughfare: String = self.item.placemark.thoroughfare {
            text += "\(thoroughfare) "
        }
        if let subThoroughfare: String = self.item.placemark.subThoroughfare {
            text += "\(subThoroughfare), "
        }
        if let locality: String = self.item.placemark.locality {
            text += "\(locality), "
        }
        if let country: String = self.item.placemark.country {
            text += "\(country)"
        }
        
        return text
    }
    
}
