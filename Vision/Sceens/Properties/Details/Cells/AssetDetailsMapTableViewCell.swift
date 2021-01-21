//
//  AssetDetailsMapTableViewCell.swift
//  Vision
//
//  Created by Idan Moshe on 07/12/2020.
//

import UIKit
import MapKit

class AssetDetailsMapTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var topTitleLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    deinit {
        self.mapView.removeAnnotations(self.mapView.annotations)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.topTitleLabel.text = "location".localized
        self.mapView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(property: Property) {
        if property.latitude != 0.0 && property.longitude != 0.0 {
            self.addAnnotation(title: property.address ?? "",
                               subtitle: "\(Application.SpecialCharacters.localizedCurrencySign) \(property.price ?? "")",
                               coordinate: CLLocationCoordinate2DMake(property.latitude, property.longitude))
            
            self.showDirections(source: self.mapView.userLocation.coordinate,
                                destination: CLLocationCoordinate2DMake(property.latitude, property.longitude))
        }
    }
    
    private func addAnnotation(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude)
        annotation.setValue(title, forKey: "title")
        annotation.setValue(subtitle, forKey: "subtitle")
        
        self.mapView.addAnnotation(annotation)
        
        self.mapView.showAnnotations([annotation], animated: true)
    }
    
    private func showDirections(source: CLLocationCoordinate2D, destination: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: source, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination, addressDictionary: nil))
        request.requestsAlternateRoutes = true
        request.transportType = .automobile

        let directions = MKDirections(request: request)

        directions.calculate { [unowned self] response, error in
            guard let unwrappedResponse = response else { return }

            for route in unwrappedResponse.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }
    
}

// MARK: - MKMapViewDelegate

extension AssetDetailsMapTableViewCell: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = .systemBlue
        renderer.lineWidth = 3.0
        return renderer
        }
    
}
