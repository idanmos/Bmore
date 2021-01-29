//
//  Schema.swift
//  Bmore
//
//  Created by Idan Moshe on 29/01/2021.
//

/*
Abstract:
Select entities and attributes from the Core Data model. Use these to check whether a persistent history change is relevant to the current view.
*/

import CoreData

enum Schema {
    enum Property: String {
        case date
        case uuid
    }
}
