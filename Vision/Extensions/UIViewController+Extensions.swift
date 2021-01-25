//
//  UIViewController+Extensions.swift
//  B-more
//
//  Created by Idan Moshe on 11/01/2021.
//

import UIKit
import MessageUI
import Messages

@nonobjc extension UIViewController {
    
    func add(_ child: UIViewController, containerView: UIView) {
        child.view.frame = containerView.frame
        child.willMove(toParent: self)
        
        containerView.addSubview(child.view)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            child.view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0),
            child.view.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0),
            child.view.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: 0),
            child.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0)
        ])
        
        self.addChild(child)
        child.didMove(toParent: self)
    }
    
    func add(_ child: UIViewController) {
        child.view.frame = self.view.frame
        child.willMove(toParent: self)
        
        self.view.addSubview(child.view)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            child.view.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
            child.view.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0),
            child.view.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0),
            child.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        ])
        
        self.addChild(child)
        child.didMove(toParent: self)
    }
    
    func remove(from containerView: UIView) {
        self.willMove(toParent: nil)
        containerView.removeFromSuperview()
        self.removeFromParent()
    }
    
    func removeAllChildren() {
        self.children.forEach { (obj: UIViewController) in
            obj.willMove(toParent: nil)
            obj.removeFromParent()
            obj.view.removeFromSuperview()
        }
    }
    
}

extension UIViewController {
    
    func showAlert(title: String? = nil, message: String? = nil, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ok".localized, style: .cancel, handler: handler))
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension UIViewController {
    
    @objc func closeScreen() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension UIViewController {
    
    func wrappedNavigationController() -> UINavigationController {
        return UINavigationController(rootViewController: self)
    }
    
}

extension UIViewController: MFMessageComposeViewControllerDelegate {
    
    func sendSMS(phoneNumber: String) {
        guard MFMessageComposeViewController.canSendText() else { return }
        let controller = MFMessageComposeViewController()
        controller.recipients = [phoneNumber]
        controller.messageComposeDelegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    public func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        debugPrint(#file, #function, result)
        controller.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - MFMailComposeViewControllerDelegate

extension UIViewController: MFMailComposeViewControllerDelegate {
    
    func sendEmail(email: String) {
        guard MFMailComposeViewController.canSendMail() else { return }
        let controller = MFMailComposeViewController()
        controller.setToRecipients([email])
        controller.mailComposeDelegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        debugPrint(#file, #function, result)
        controller.dismiss(animated: true, completion: nil)
    }
    
}
