//
//  UIView+Extensions.swift
//  Vision
//
//  Created by Idan Moshe on 07/12/2020.
//

import UIKit

extension UIView {
    
    func embed(in view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            self.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
    
    func constraints(to view: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func statusBarFrame() -> CGFloat {
        if let height = self.window?.windowScene?.statusBarManager?.statusBarFrame.height {
            return height
        } else {
            return UIApplication.shared.statusBarFrame.size.height
        }
    }
    
    func makeAsCircle(borderColor: UIColor? = nil, borderWidth: CGFloat? = nil) {
        self.layer.cornerRadius = self.frame.size.height/2.0
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        
        if let color: UIColor = borderColor {
            self.layer.borderColor = color.cgColor
        }
        if let width: CGFloat = borderWidth {
            self.layer.borderWidth = width
        }
    }
    
    func findContainingViewController() -> UIViewController? {
        if let nextResponder = next as? UIViewController {
            return nextResponder
        }

        if let nextResponder = next as? UIView {
            return nextResponder.findContainingViewController()
        }

        return nil
    }
    
}
