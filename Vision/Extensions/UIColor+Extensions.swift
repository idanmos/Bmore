//
//  UIColor+Extensions.swift
//  Vision
//
//  Created by Idan Moshe on 24/12/2020.
//

import UIKit

extension UIColor {
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        let multiplier = CGFloat(255.999999)

        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }

        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
}

// MARK: - Flat Colors

extension UIColor {
    
    static func rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }
    
    static let turqoise = UIColor.rgb(26, 188, 156)
    static let emerald = UIColor.rgb(46, 204, 113)
    static let peterRiver = UIColor.rgb(52, 152, 219)
    static let amethyst = UIColor.rgb(155, 89, 182)
    static let wetAsphalt = UIColor.rgb(52, 73, 94)
    static let greenTea = UIColor.rgb(22, 160, 133)
    static let nephritis = UIColor.rgb(39, 174, 96)
    static let belizeHole = UIColor.rgb(41, 128, 185)
    static let wisteria = UIColor.rgb(142, 68, 173)
    static let midnightBlue = UIColor.rgb(44, 62, 80)
    static let sunFlower = UIColor.rgb(241, 196, 15)
    static let carrot = UIColor.rgb(230, 126, 34)
    static let alizarin = UIColor.rgb(231, 76, 60)
    static let clouds = UIColor.rgb(236, 240, 241)
    static let concrete = UIColor.rgb(149, 165, 166)
    static let orange = UIColor.rgb(243, 156, 18)
    static let pumpkin = UIColor.rgb(211, 84, 0)
    static let pomegranate = UIColor.rgb(192, 57, 43)
    static let silver = UIColor.rgb(189, 195, 199)
    static let asbestos = UIColor.rgb(127, 140, 141)
    
}
