//
//  PropertiesMapViewController.swift
//  Vision
//
//  Created by Idan Moshe on 06/12/2020.
//

import UIKit
import MapKit
import CoreLocation

class PropertiesMapViewController: UIViewController {
            
    // MARK: - Variables
    
    private var viewModel: PropertiesViewModel!
    
    private lazy var mapView: MKMapView = {
        let map = MKMapView(frame: .zero)
        map.delegate = self
        map.showsScale = true
        map.showsCompass = true
        map.showsTraffic = true
        map.showsBuildings = true
        map.showsUserLocation = true
        return map
    }()
    
    /// - Tag: Map
    private var userTrackingButton: MKUserTrackingButton!
    private var scaleView: MKScaleView!
    
    // MARK: - Lifecycle
    
    init(viewModel: PropertiesViewModel) {
        super.init(nibName: nil, bundle: nil)
//        self.view.frame = UIScreen.main.bounds
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    deinit {
        debugPrint("Deallocating \(self)")
    }
    
    override func loadView() {
        super.loadView()
                
        self.mapView.embed(in: self.view)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "map".localized
        
        self.setupCompassButton()
        self.setupUserTrackingButtonAndScaleView()
                
        let authorizationStatus: CLAuthorizationStatus = CLLocationManager.authorizationStatus()
        let locationAuthorized: Bool = (authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse)
        self.userTrackingButton.isHidden = !locationAuthorized
        
        self.mapView.userTrackingMode = .follow
        
        let manager = CLLocationManager()
        manager.activityType = .otherNavigation
        manager.pausesLocationUpdatesAutomatically = false
        manager.desiredAccuracy = 100
        manager.distanceFilter = 100
        manager.delegate = self
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2.0) {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        for annotation: MKAnnotation in self.mapView.annotations {
            if annotation is MKUserLocation { continue }
            self.mapView.removeAnnotation(annotation)
        }
        
        var annotations: [MKAnnotation] = []
        
        viewModel.resetAndReload()
        viewModel.fetchedObjects.forEach { (property: Property) in
            let coordinate = CLLocationCoordinate2D(
                latitude: property.latitude,
                longitude: property.longitude
            )
            
            if CLLocationCoordinate2DIsValid(coordinate) {
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = property.address
                // annotation.subtitle = ""
                annotations.append(annotation)
            }
        }
        
        self.mapView.addAnnotations(annotations)
        self.mapView.showAnnotations(annotations, animated: true)
    }
    
    // MARK: - Setup
    
    private func setupCompassButton() {
        let compass = MKCompassButton(mapView: self.mapView)
        compass.compassVisibility = .visible
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: compass)
        self.mapView.showsCompass = false
    }
    
    private func setupUserTrackingButtonAndScaleView() {
        self.mapView.showsUserLocation = true
        
        self.userTrackingButton = MKUserTrackingButton(mapView: self.mapView)
        self.userTrackingButton.isHidden = true // Unhides when location authorization is given.
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.userTrackingButton)
        
        // By default, `MKScaleView` uses adaptive visibility, so it only displays when zooming the map.
        // This is behavior is confirgurable with the `scaleVisibility` property.
        self.scaleView = MKScaleView(mapView: self.mapView)
        self.scaleView.legendAlignment = .trailing
        view.addSubview(self.scaleView)
        
        let stackView = UIStackView(arrangedSubviews: [self.scaleView, self.userTrackingButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 10
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
                                     stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)])
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func onAddAsset(_ sender: Any) {
        //
    }
}

extension PropertiesMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        //
    }
    
}

extension PropertiesMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .notDetermined {
            manager.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.requestLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint(#function, error)
    }
    
}
