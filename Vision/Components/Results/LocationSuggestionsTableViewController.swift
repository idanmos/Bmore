//
//  LocationSuggestionsTableViewController.swift
//  LocationPicker
//
//  Created by Idan Moshe on 30/01/2021.
//

import UIKit
import MapKit

protocol LocationSuggestionsTableViewControllerDelegate: class {
    func locationSearchController(_ locationSearchController: LocationSuggestionsTableViewController, didSelect mapItem: LocationMapItem)
}

class LocationSuggestionsTableViewController: UITableViewController {
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        self.view.frame = UIScreen.main.bounds
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    weak var searchDelegate: LocationSuggestionsTableViewControllerDelegate?
    var dataSource: [MKMapItem] = []
    
    deinit {
        debugPrint("Deallocating \(self)")
        self.dataSource.removeAll()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(LocationPickerTableViewCell.self)
        self.tableView.tableFooterView = UIView(frame: .zero)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(LocationPickerTableViewCell.self, indexPath: indexPath)
        let mapItem: MKMapItem = self.dataSource[indexPath.row]
        cell.textLabel?.text = mapItem.placemark.name
        cell.detailTextLabel?.text = "\(mapItem.placemark.thoroughfare ?? "") \(mapItem.placemark.subThoroughfare ?? ""), \(mapItem.placemark.locality ?? "")"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mapItem: MKMapItem = self.dataSource[indexPath.row]
        self.searchDelegate?.locationSearchController(self, didSelect: LocationMapItem(mapItem))
    }

}
