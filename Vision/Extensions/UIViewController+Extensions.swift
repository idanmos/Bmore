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
    
    func addChildController(_ childController: UIViewController, containerView: UIView? = nil) {
        childController.view.frame = (containerView ?? self.view).frame
        childController.willMove(toParent: self)
        
        (containerView ?? self.view).addSubview(childController.view)
        childController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            childController.view.topAnchor.constraint(equalTo: (containerView ?? self.view).topAnchor, constant: 0),
            childController.view.leftAnchor.constraint(equalTo: (containerView ?? self.view).leftAnchor, constant: 0),
            childController.view.rightAnchor.constraint(equalTo: (containerView ?? self.view).rightAnchor, constant: 0),
            childController.view.bottomAnchor.constraint(equalTo: (containerView ?? self.view).bottomAnchor, constant: 0)
        ])
        
        self.addChild(childController)
        childController.didMove(toParent: self)
    }
    
    func removeChildController(_ childController: UIViewController) {
        childController.willMove(toParent: nil)
        childController.view.removeFromSuperview()
        childController.removeFromParent()
    }
    
    func removeAllChildren() {
        self.children.forEach { (obj: UIViewController) in
            obj.willMove(toParent: nil)
            obj.removeFromParent()
            obj.view.removeFromSuperview()
        }
    }
    
    func isAncestor(ofViewController viewController: UIViewController) -> Bool {
        for child: UIViewController in self.children {
            if child == viewController {
                return true
            }
            if child.isAncestor(ofViewController: viewController) {
                return true
            }
        }
        return false
    }
    
}

extension UIViewController {
    
    func showAlert(title: String? = nil, message: String? = nil, autoDismiss: Bool = true, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "ok".localized, style: .cancel, handler: handler))
        self.present(alertController, animated: true, completion: nil)
        
        if autoDismiss {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.dismiss(animated: true)
            }
        }
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
