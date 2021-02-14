//
//  PopOverViewController.swift
//  Bmore
//
//  Created by Idan Moshe on 14/02/2021.
//

import UIKit

class PopOverViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
    
    @discardableResult class func show(with view: UIView, barButtonItem: UIBarButtonItem? = nil, presenter: UIViewController? = nil) -> PopOverViewController {
        let size = CGSize(width: 375, height: 162)
        let viewController = PopOverViewController()
        viewController.view.frame = CGRect(origin: .zero, size: size)
        viewController.preferredContentSize = size
        viewController.modalPresentationStyle = .popover
        
        view.translatesAutoresizingMaskIntoConstraints = false
        viewController.view.addSubview(view)
        
        viewController.popoverPresentationController?.barButtonItem = barButtonItem
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: viewController.view.topAnchor, constant: 0),
            view.leftAnchor.constraint(equalTo: viewController.view.leftAnchor, constant: 0),
            view.rightAnchor.constraint(equalTo: viewController.view.rightAnchor, constant: 0),
            view.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor, constant: 0)
        ])
        
        if let presenter = presenter {
            presenter.present(viewController, animated: true, completion: nil)
        }
        
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
}
