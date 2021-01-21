//
//  TransactionConfiguration.swift
//  B-more
//
//  Created by Idan Moshe on 09/01/2021.
//

import UIKit
import CoreLocation.CLLocation

struct TransactionConfiguration {
    var status: Int
    var type: Int
    var date: Date?
    var locationType: Int
    var propertyId: UUID?
    var address: String?
    var location: CLLocation?
    var placemark: CLPlacemark?
    var price: String?
    var commisionType: Int
    var commision: String?
    var contactId: String?
}
