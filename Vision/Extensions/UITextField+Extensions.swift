//
//  UITextField+Extensions.swift
//  Vision
//
//  Created by Idan Moshe on 11/12/2020.
//

import UIKit
import Combine

extension UITextView {
    func addTollbar(target: Any?, action: Selector?) {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: NSLocalizedString("ok", comment: ""), style: .plain, target: target, action: action)
        toolBar.setItems([done, flexible], animated: true)
        self.inputAccessoryView = toolBar
    }
}

extension UITextField {
    
    func addTollbar(target: Any?, action: Selector?) {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: NSLocalizedString("ok", comment: ""), style: .plain, target: target, action: action)
        toolBar.setItems([done, flexible], animated: true)
        self.inputAccessoryView = toolBar
    }
    
    func addMapTollbar(target: Any?, action: Selector?) {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: 44.0))
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(title: NSLocalizedString("map", comment: ""), style: .plain, target: target, action: action)
        let close = UIBarButtonItem(title: NSLocalizedString("close", comment: ""), style: .plain, target: self, action: #selector(self.resignFirstResponder))
        toolBar.setItems([close, flexible, done], animated: true)
        self.inputAccessoryView = toolBar
    }
        
}

extension UITextField {

    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField }
            .map { $0.text ?? "" }
            .eraseToAnyPublisher()
    }

}
