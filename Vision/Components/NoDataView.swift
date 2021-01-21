//
//  NoDataView.swift
//  B-more
//
//  Created by Idan Moshe on 13/01/2021.
//

import UIKit

class NoDataView: UIView {

    private lazy var noDataLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 25.0)
        label.text = NSLocalizedString("no_data", comment: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .clear
        label.sizeToFit()
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.tag = 1234321
        
        self.addSubview(self.noDataLabel)
        
        NSLayoutConstraint.activate([
            self.noDataLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            self.noDataLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            self.noDataLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            self.noDataLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
        ])
    }
    
    class func show(on view: UIView) {
        if let hiddenNoDataView: UIView = view.viewWithTag(1234321) {
            view.bringSubviewToFront(hiddenNoDataView)
            return
        }
        
        let noDataView = NoDataView(frame: .zero)
        noDataView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(noDataView)
        view.bringSubviewToFront(noDataView)
        
        NSLayoutConstraint.activate([
            noDataView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            noDataView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            noDataView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            noDataView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
        ])
    }
    
    class func hide(from view: UIView) {
        if let noDataView: UIView = view.viewWithTag(1234321) {
            noDataView.removeFromSuperview()
        }
    }

}
