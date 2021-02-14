//
//  CALayer+Extensions.swift
//  Bmore
//
//  Created by Idan Moshe on 11/02/2021.
//

import UIKit

extension CALayer {
    
    func round(roundedRect rect: CGRect, byRoundingCorners corners: UIRectCorner, cornerRadii: CGSize, strokeColor: CGColor? = nil) {
        let maskPath = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: cornerRadii
        )
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        maskLayer.strokeColor = strokeColor
        
        self.mask = maskLayer
    }
    
}
