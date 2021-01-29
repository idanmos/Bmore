//
//  PropertyConfiguration.swift
//  Bmore
//
//  Created by Idan Moshe on 29/01/2021.
//

import Foundation

struct PropertyConfiguration {
    var uuid: UUID
    var date: Date?
    var enterDateIsNow: Bool
    var sellOrRent: String?
    var latitude: Double?
    var longitude: Double?
    var entryDate: Date?
    var type: Int16
    var address: String?
    var price: String?
    var size: Double?
    var rooms: Double?
    var balcony: Int16?
    var floorNumber: Int16?
    var totalFloorNumber: Int16?
    var parking: Int16?
    var extraInfo: String?
    var contactIdentifier: String?
    var isExclusivity: Bool
    var exclusivityEndDate: Date?
}
