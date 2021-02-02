//
//  BaseViewController.swift
//  Bmore
//
//  Created by Idan Moshe on 29/01/2021.
//

import UIKit

class BaseViewController: UIViewController {
    
//    lazy var menuButtonItem: UIBarButtonItem = {
//        let button = UIBarButtonItem(image: UIImage(systemName: "line.horizontal.3"), style: .plain, target: self, action: #selector(self.onPressMenu(_:)))
//        return button
//    }()
    
    lazy var spinner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func loadView() {
        super.loadView()
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.barTintColor = .white
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        guard self.spinner.superview == nil, let superView = self.view.superview else { return }

        superView.addSubview(self.spinner)
        superView.bringSubviewToFront(self.spinner)
        self.spinner.center = CGPoint(x: superView.frame.size.width / 2, y: superView.frame.size.height / 2)
    }
    
    func showSpinner() {
        self.spinner.startAnimating()
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 1))
    }
    
    func hideSpinner() {
        if Thread.isMainThread {
            self.spinner.stopAnimating()
        } else {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.spinner.stopAnimating()
            }
        }
    }

}
