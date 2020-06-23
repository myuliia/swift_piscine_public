//
//  ViewController.swift
//  rush01
//
//  Created by Mishchenko YULIIA on 10/11/19.
//  Copyright © 2019 Mishchenko YULIIA. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Contacts

protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
}

var pinSaved = MKPointAnnotation()
var pinSaved2 = MKPointAnnotation()
var whichType : Int = 0

class ViewController: UIViewController, UITextFieldDelegate  {

    @IBOutlet weak var mapView: MKMapView!

    let regionInMetres : Double = 1000
    let locationManager = CLLocationManager()
    var directionsArray: [MKDirections] = []
    var selectedPin: MKPlacemark?
    var resultSearchController: UISearchController?

    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var ToLabel: UILabel!

    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!

    @IBAction func FromToSegmentedControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            whichPinSelect = 1
            self.resultSearchController?.searchBar.placeholder = "Enter departure point"
            sender.tintColor = #colorLiteral(red: 0.3815353513, green: 0.08322500437, blue: 0.2231117487, alpha: 1)
        case 1:
            whichPinSelect = 2
            self.resultSearchController?.searchBar.placeholder = "Enter destination point"
            sender.tintColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        default:
            break
        }
    }

    @IBAction func pressUserLocation(_ sender: UIButton) {
        currentLocation()
        centerViewOnUserLocation() }
    

    
    @IBAction func goButtonPressed(_ sender: UIButton) {
        if pin.city != "" {
            getDirections()
        }
        else {
             self.alertMessage(title: "There must be at least one pin", message: "")
        }
        chooseMapType()
    }

    @IBAction func settingsDone(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self

       let locationSearchTable = storyboard?.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        self.resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        self.resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = self.resultSearchController?.searchBar
        searchBar?.sizeToFit()
        searchBar?.placeholder = "Enter departure point"
        self.navigationItem.titleView = self.resultSearchController?.searchBar
        
        self.resultSearchController?.hidesNavigationBarDuringPresentation = false
        self.resultSearchController?.dimsBackgroundDuringPresentation = true
        self.definesPresentationContext = true
        
        locationSearchTable.mapView = self.mapView
        locationSearchTable.handleMapSearchDelegate = self
        
        DispatchQueue.main.async {
            self.locationManager.startUpdatingLocation()
        }
    }

    @IBAction func segmentWhichRoute(_ sender: UISegmentedControl) {
        whichRoute = sender.selectedSegmentIndex
        print("RouteNumber ", whichRoute)
    }

    @IBAction func segmentMapType(_ sender: UISegmentedControl) {
        whichType = sender.selectedSegmentIndex
    }

    @IBAction func longPress(_ sender: UILongPressGestureRecognizer) {
           sender.minimumPressDuration = 0.3
        if sender.state == .ended {
            mapView.removeOverlays(mapView.overlays)
            let locationInView = sender.location(in: mapView)
            let tappedCoordinate = mapView.convert(locationInView , toCoordinateFrom: mapView)
            let geoCoder = CLGeocoder()
            geoCoder.cancelGeocode()
            geoCoder.reverseGeocodeLocation(CLLocation(latitude: tappedCoordinate.latitude, longitude: tappedCoordinate.longitude)) { (placemark, error) in
                guard let placemark = placemark?.first else {
                    print("Error with placemark")
                    return
                }
                self.placePin(placemark: placemark)
            }
        }
    }

    func placePin(placemark: CLPlacemark) {
        var street : String? = placemark.thoroughfare
        if placemark.thoroughfare == nil {
                 street = placemark.subLocality ?? placemark.name
        }
        if whichPinSelect == 1 {
            pin = Pin(country: placemark.name, city: "From", longitude: placemark.location!.coordinate.longitude/*tappedCoordinate.longitude*/, latitude: placemark.location!.coordinate.latitude/*tappedCoordinate.latitude*/, street: street, streetNumber: placemark.subThoroughfare, color: "To")
            self.addPin(pinInfo: pin)
        }
        else if whichPinSelect == 2 {
            pin2 = Pin(country: placemark.name, city: "To", longitude: placemark.location!.coordinate.longitude/*tappedCoordinate.longitude*/, latitude: placemark.location!.coordinate.latitude/*tappedCoordinate.latitude*/, street: street, streetNumber: placemark.subThoroughfare, color: "From")
            self.addPin(pinInfo: pin2)
        }
    }

    func getDirections() {
        let request : MKDirections.Request
        if pin2.city == "" {
            guard let location = locationManager.location?.coordinate else {
                print("Troubles with location")
                return
            }
            request = createDirectionsRequest(from: location)
        }
        else {
            request = createDirectionsRequest(from: CLLocationCoordinate2D(latitude: pin2.latitude, longitude: pin2.longitude))
        }
        let directions = MKDirections(request: request)
        resetMapView(withNew: directions)
        directions.calculate { (responce, error) in
            guard let responce = responce else { print("ERROR")
                self.alertMessage(title: "No existing routes", message: "Choose another location")
                return
            }
            for route in responce.routes {
                self.mapView.addOverlay(route.polyline)
                self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            }
        }
    }

    func createDirectionsRequest(from coordinate: CLLocationCoordinate2D) -> MKDirections.Request {
        let destinationCoordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
        let startingLocation = MKPlacemark(coordinate: coordinate)
        let destination = MKPlacemark(coordinate: destinationCoordinate)
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: startingLocation)
        request.destination = MKMapItem(placemark: destination)
        switch whichRoute {
        case 0:
            request.transportType = .automobile
        case 1:
            request.transportType = .walking
        case 2:
            request.transportType = .automobile
        default:
            request.transportType = .automobile
        }
        request.requestsAlternateRoutes = true
        return request
    }

    func resetMapView(withNew directions: MKDirections) {
        mapView.removeOverlays(mapView.overlays)
        directionsArray.append(directions)
        let _ = directionsArray.map { $0.cancel()}
    }
}

extension ViewController : CLLocationManagerDelegate, MKMapViewDelegate {

    func addPin(pinInfo : Pin) {
        if whichPinSelect == 1 && pinSaved.title != "" {
            mapView.removeAnnotation(pinSaved)
        }
        else if whichPinSelect == 2 && pinSaved2.title != "" {
            mapView.removeAnnotation(pinSaved2)
        }
        let pin = MKPointAnnotation()
        
        if whichPinSelect == 1 {
            pinSaved = pin
            fromLabel.text = pinInfo.street
        }
        else if whichPinSelect == 2 {
            pinSaved2 = pin
            ToLabel.text = pinInfo.street
        }
        pin.title = pinInfo.country
        pin.subtitle = pinInfo.city
        pin.coordinate.latitude = pinInfo.latitude
        pin.coordinate.longitude = pinInfo.longitude
        pin.awakeFromNib()
        mapView.addAnnotation(pin)
    }

       func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let anotation = MKMarkerAnnotationView()
            if annotation.title != "My Location" {
                if annotation.subtitle == "To" {
                    anotation.markerTintColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
                }
                else if annotation.subtitle == "From" {
                    anotation.markerTintColor = #colorLiteral(red: 0.3815353513, green: 0.08322500437, blue: 0.2231117487, alpha: 1)
                }
            return anotation
            }
        return nil
        }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        if whichType == 0 {
            renderer.strokeColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        }
        else {
            renderer.strokeColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        }
        renderer.lineWidth = 3
        return renderer
    }

    func currentLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
    }

    func centerViewOnUserLocation() { // add it to button to show location
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: regionInMetres, longitudinalMeters: regionInMetres)
            mapView.setRegion(region, animated: true)
        }
        mapView.showsUserLocation = true
    }

    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        //
    }

    func chooseMapType() {
        switch whichType {
        case 0:
            mapView.mapType = MKMapType.mutedStandard
        case 1:
            mapView.mapType = MKMapType.satelliteFlyover
        case 2:
            mapView.mapType = MKMapType.hybridFlyover
        default:
            mapView.mapType = MKMapType.standard
        }
    }

    func alertMessage(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }

}

extension ViewController: HandleMapSearch {

    func dropPinZoomIn(placemark: MKPlacemark) {
        self.placePin(placemark: placemark)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        self.mapView.setRegion(region, animated: true)
    }

}

