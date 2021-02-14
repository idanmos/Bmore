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

extension UIView{
    func showMessage(message:NSString,animateDuration:Double)
    {
        let window = UIApplication.shared.keyWindow
        let showView = UIView()
        showView.backgroundColor = UIColor.black
        showView.frame = CGRect(x: 1, y: 1, width: 1, height: 1)//CGRectMake(1, 1, 1, 1);
        showView.alpha = 1.0;
        showView.layer.cornerRadius = 5.0;
        showView.layer.masksToBounds = true;
        window?.addSubview(showView)
        
        let label = UILabel()
        let attributesArray = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17),NSAttributedString.Key.foregroundColor:UIColor.lightGray]
        let labelSize:CGSize = message.size(withAttributes: attributesArray)
        
        label.frame = CGRect(x: 10.0, y: 5.0, width: labelSize.width, height: labelSize.height)//CGRectMake(10.0, 5.0, labelSize.width,labelSize.height);
        label.numberOfLines = 0
        label.text = message as String;
        label.textColor = UIColor.white;
        label.textAlignment = NSTextAlignment(rawValue: 1)!
        label.backgroundColor = UIColor.clear;
        label.font = UIFont.boldSystemFont(ofSize: 15)
        showView.addSubview(label)
        showView.frame = CGRect(x: (UIScreen.main.bounds.width - labelSize.width - 20.0)/2.0, y: UIScreen.main.bounds.width - 200.0, width:  labelSize.width+20.0, height: labelSize.height+10.0)
        
        //CGRectMake((UIScreen.main.bounds.width - labelSize.width - 20.0)/2.0,  UIScreen.main.bounds.width - 200.0, labelSize.width+20.0, labelSize.height+10.0)
        
        UIView.animate(withDuration: animateDuration, animations: { () -> Void in
            showView.alpha = 0
        }) { (finished) -> Void in
            showView.removeFromSuperview()
        }
        
    }

}

