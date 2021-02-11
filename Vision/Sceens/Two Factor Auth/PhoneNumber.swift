//
//  PhoneNumber.swift
//  Bmore
//
//  Created by Idan Moshe on 10/02/2021.
//

import UIKit

class PhoneNumber {
    
    static let COUNTRY_CODE_PREFIX: String = "+"
    
    private let phoneNumber: Any
    private let e164: String
    
    init(phoneNumber: Any, e164: String) {
        assert(e164.count > 0)
        self.phoneNumber = phoneNumber
        self.e164 = e164
    }
    
//    class func phoneNumber(from text: String, regionCode: String) -> PhoneNumber {
//        assert(text.count > 0)
//        assert(regionCode.count > 0)
//
//    }
//
//    class func tryParsePhoneNumber(fromUserSpecifiedText text: String?) -> PhoneNumber? {
//    }
//
//    class func tryParsePhoneNumber(fromE164 text: String?) -> PhoneNumber? {
//    }
//
//    convenience init?(fromUserSpecifiedText text: String?) {
//    }
//
//    private(set) var nationalNumber: String?
//
//    class func tryParsePhoneNumbers(
//        fromUserSpecifiedText text: String?,
//        clientPhoneNumber: String?
//    ) -> [PhoneNumber]? {
//    }
//
//    class func removeFormattingCharacters(_ inputString: String?) -> String? {
//    }
//
//    class func bestEffortLocalizedPhoneNumber(withE164 phoneNumber: String?) -> String? {
//    }
//
//    class func regionCode(fromCountryCodeString countryCodeString: String?) -> String? {
//    }
//
//    func toSystemDialerURL() -> URL? {
//    }
//
//    func toE164() -> String? {
//    }
//
//    func getCountryCode() -> NSNumber? {
//    }
//
//    func isValid() -> Bool {
//    }
//
//    func compare(_ other: PhoneNumber?) -> ComparisonResult {
//    }
//
//    class func defaultCountryCode() -> String? {
//    }
    
}
