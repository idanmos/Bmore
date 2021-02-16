//
//  UIImage+Extensions.swift
//  Bmore
//
//  Created by Idan Moshe on 14/02/2021.
//

import UIKit

extension UIImage {
    func tint(with color: UIColor) -> UIImage {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()

        image.draw(in: CGRect(origin: .zero, size: size))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

extension UIImage {
    
    static func propertyImage() -> UIImage? {
        if #available(iOS 14, *) {
            return UIImage(systemName: "building.2")
        } else {
            return UIImage(systemName: "house")
        }
    }
    
    static func leadsImage() -> UIImage? {
        return UIImage(systemName: "person.2")
    }
    
    static func taskImage() -> UIImage? {
        return UIImage(systemName: "list.number")
    }
    
    static func timeTrackingImage() -> UIImage? {
        return UIImage(systemName: "clock")
    }
    
    static func meetingImage() -> UIImage? {
        return UIImage(systemName: "person.3")
    }
    
    static func transactionImage() -> UIImage? {
        return UIImage(systemName: "dollarsign.circle")
    }
    
    static func targetsImage() -> UIImage? {
        if #available(iOS 14, *) {
            return UIImage(systemName: "target")
        } else {
            return UIImage(systemName: "arrow.up.forward")
        }
    }
    
}
