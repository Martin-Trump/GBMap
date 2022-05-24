//
//  ViewController.swift
//  GBMap
//
//  Created by Павел Шатунов on 21.05.2022.
//

import UIKit
import GoogleMaps
import CoreLocation

class ViewController: UIViewController {
    var geocoder: CLGeocoder?
    var route: GMSPolyline?
    var routePath: GMSMutablePath?
    var locationManager: CLLocationManager?
    var marker: GMSMarker?
    var manualMarker: GMSMarker?

    let coordinate = CLLocationCoordinate2D(latitude: 37.34033264974476, longitude: -122.06892632102273)
  
    @IBOutlet weak var mapView: GMSMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocation()
        configureLocationManager()
        
    }

    @IBAction func toggleMarker(_ sender: Any) {
        if marker == nil {
            addMarker()
        } else {
            removeMarker()
        }
    }
    @IBAction func updateLocation(_ sender: Any) {
        locationManager?.requestLocation()
        route?.map = nil
        route = GMSPolyline()
        routePath = GMSMutablePath()
        route?.map = mapView
        locationManager?.startUpdatingLocation()
    }
    
    func configureLocationManager() {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.delegate = self
    }
    
    func configureLocation() {
        let camera = GMSCameraPosition.camera(withTarget: coordinate, zoom: 17)
        mapView.camera = camera
        mapView.delegate = self
    }
    
    func addMarker() {
        let marker = GMSMarker(position: coordinate)
        self.marker = marker
        marker.map = mapView
    }
    
    func removeMarker() {
        marker?.map = nil
        marker = nil
    }
}

extension ViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        if let manualMarker = manualMarker {
            manualMarker.position = coordinate
        } else {
            let marker = GMSMarker(position: coordinate)
            marker.map = mapView
            self.manualMarker = marker
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        routePath?.add(location.coordinate)
        route?.path = routePath
        
        let position = GMSCameraPosition.camera(withTarget: location.coordinate, zoom: 17)
        mapView.animate(to: position)
        print(location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
