//
//  CountryCodeViewController.swift
//  Bmore
//
//  Created by Idan Moshe on 10/02/2021.
//

import UIKit

protocol CountryCodeViewControllerDelegate: class {
    func countryCodeViewControllerDelegate(
        _ viewController: CountryCodeViewController,
        didSelect countryCode: String,
        countryName: String,
        callingCode: String
    )
}

class CountryCodeViewController: UIViewController {
    
    weak var countryCodeEelegate: CountryCodeViewControllerDelegate?
    
    var isPresentedInNavigationController: Bool = false
    var interfaceOrientationMaek: UIInterfaceOrientationMask = .all
    
    private var countryCodes: [String] = []
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "SEARCH_BYNAMEORNUMBER_PLACEHOLDER_TEXT".localized
        searchBar.sizeToFit()
        return searchBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "COUNTRYCODE_SELECT_TITLE".localized
        
        if !self.isPresentedInNavigationController {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(
                barButtonSystemItem: .close,
                target: self,
                action: #selector(self.dismissWasPressed(_:))
            )
        }
        
        // setup ui
    }
    
    @objc private func dismissWasPressed(_ senderL: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
// MARK: - UISearchBarDelegate

extension CountryCodeViewController: UISearchBarDelegate {
    //
}
