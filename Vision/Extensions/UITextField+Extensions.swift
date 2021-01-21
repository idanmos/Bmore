//
//  UITextField+Extensions.swift
//  Vision
//
//  Created by Idan Moshe on 11/12/2020.
//

import UIKit

extension UITextField {
    
    func addTollbar(target: Any?, action: Selector?) {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "אישור", style: .plain, target: target, action: action)
        toolBar.setItems([flexible, done], animated: true)
        self.inputAccessoryView = toolBar
    }
    
    func addMapTollbar(target: Any?, action: Selector?) {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: "מפה", style: .plain, target: target, action: action)
        let close = UIBarButtonItem(title: "סגור", style: .plain, target: self, action: #selector(self.resignFirstResponder))
        toolBar.setItems([close, flexible, done], animated: true)
        self.inputAccessoryView = toolBar
    }
        
}
