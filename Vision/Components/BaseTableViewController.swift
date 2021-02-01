//
//  BaseViewController.swift
//  B-more
//
//  Created by Idan Moshe on 18/01/2021.
//

import UIKit

class BaseTableViewController: UITableViewController {
    
    lazy var spinner: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .gray
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var noDataView: NoDataView = {
        let view = NoDataView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = false
        return view
    }()
        
    override func loadView() {
        super.loadView()
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.barTintColor = .white
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
                
        guard (self.spinner.superview == nil || self.noDataView.superview == nil), let superView = self.tableView.superview else { return }
                
        /// - Tag: Spinner
        superView.addSubview(self.spinner)
        superView.bringSubviewToFront(self.spinner)
        self.spinner.center = CGPoint(x: superView.frame.size.width / 2, y: superView.frame.size.height / 2)
        
        /// - Tag: No Data View
        superView.addSubview(self.noDataView)
        superView.bringSubviewToFront(self.noDataView)
        
        NSLayoutConstraint.activate([
            self.noDataView.topAnchor.constraint(equalTo: superView.topAnchor, constant: 0),
            self.noDataView.leftAnchor.constraint(equalTo: superView.leftAnchor, constant: 0),
            self.noDataView.rightAnchor.constraint(equalTo: superView.rightAnchor, constant: 0),
            self.noDataView.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: 0)
        ])
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
    
    func showNoDataView(show: Bool) {
        if show {
            self.noDataView.isHidden = false
            if let superView = self.tableView.superview {
                superView.bringSubviewToFront(self.noDataView)
            }
        } else {
            self.noDataView.isHidden = true
        }
    }

}
