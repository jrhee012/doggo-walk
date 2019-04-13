//
//  HomeViewController.swift
//  doggo-walk
//
//  Created by Jaehyuk Rhee on 4/9/19.
//  Copyright © 2019 Jaehyuk Rhee. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class HomeViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    let locationManager = CLLocationManager()
    let userDefaults = UserDefaults.standard
    
    let startTitle = "Start"
    let viewMapTitle = "View Map"
    
    var tripCoords: [CLLocationCoordinate2D] = []
    var start = false
    var end = true
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var startButtonUI: UIButton!
    @IBOutlet weak var finishButtonUI: UIButton!
    
    @IBAction func startButtonUp(_ sender: Any) {
        let buttonTitle = startButtonUI.currentTitle
        if buttonTitle == self.startTitle {
            self.start = true
            self.end = false
//            self.locationManager.startUpdatingLocation()
        }
        
        self.viewDidLoad()
    }
    @IBAction func finishButtonDown(_ sender: Any) {
        self.start = false
        self.end = true
        
        //        self.popTripView(tripCoords: self.tripCoords)
        self.tripCoords = []
        self.viewDidLoad()
    }
    
    //    @IBAction func finishButtonUp(_ sender: Any) {
//        self.start = false
//        self.end = true
//
//        self.popTripView(tripCoords: self.tripCoords)
//        self.tripCoords = []
//        self.viewDidLoad()
//    }
//
//    @IBAction func startButtonDown(_ sender: Any) {
//        let buttonTitle = startButtonUI.currentTitle
//        if buttonTitle == self.startTitle {
//            self.start = true
//            self.end = false
//            self.locationManager.startUpdatingLocation()
//        }
//
//        if self.tripCoords.count > 0 {
//            self.popTripView(tripCoords: self.tripCoords)
//        }
//
//        self.viewDidLoad()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        if !self.start && !self.end {
            self.start = false
            self.end = true
        }
        
        if self.start && !self.end {
            startButtonUI.setTitle(self.viewMapTitle, for: UIControl.State.normal)
            finishButtonUI.isEnabled = true
            finishButtonUI.isHidden = false
        }

        if !self.start && self.end {
            startButtonUI.setTitle(self.startTitle, for: UIControl.State.normal)
            finishButtonUI.isEnabled = false
            finishButtonUI.isHidden = true
        }
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.allowsBackgroundLocationUpdates = true
            self.locationManager.pausesLocationUpdatesAutomatically = false
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
        }
        
        mapView.delegate = self
        
//        self.updateMapView()
    }
    
//    private func popTripView() {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let tripViewController = storyBoard.instantiateViewController(withIdentifier: "trip") as! TripViewController
//        self.present(tripViewController, animated: true, completion: nil)
//    }
//
//    private func popTripView(tripCoords: [CLLocationCoordinate2D]) {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//        let tripViewController = storyBoard.instantiateViewController(withIdentifier: "trip") as! TripViewController
//        tripViewController.tripCoords = self.tripCoords
//        if self.end {
//            tripViewController.ended = true
//        }
//        self.present(tripViewController, animated: true, completion: nil)
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        
        if !self.end {
            self.tripCoords.append(locValue)
            print(self.tripCoords.count)
//            if self.tripCoords.count == 1 {
//                self.popTripView(tripCoords: self.tripCoords)
//            }
//            print(self.tripCoords.count)
        }
        
        if (self.tripCoords.count > 0) {
            self.updateMapView()
        } else {
            self.currentLocationMapView(coord: locValue)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.orange
            renderer.lineWidth = 3
            return renderer
        }
        
        return MKOverlayRenderer()
    }
    
    private func updateMapView() {
        self.addAnnotations()
        self.addPolylineToMap()
    }
    
    private func clearAllMapUI() {
        self.clearAllAnnotations()
        self.clearAllOverlays()
    }
    
    private func clearAllAnnotations() {
        self.mapView.removeAnnotations(mapView.annotations)
    }
    
    private func clearAllOverlays() {
        self.mapView.removeOverlays(mapView.overlays)
    }
    
    private func currentLocationMapView(coord: CLLocationCoordinate2D) {
//        self.clearAllMapUI()
        
        let startAnnotation = MKPointAnnotation()
        startAnnotation.coordinate = coord
        startAnnotation.title = "Current Location"
        mapView.addAnnotation(startAnnotation)
        
        let polyline = MKPolyline(coordinates: [coord], count: 1)
        self.mapView.addOverlay(polyline, level: MKOverlayLevel.aboveRoads)
        self.mapView.setVisibleMapRect(polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 50.0, left: 50.0, bottom: 50.0, right: 50.0), animated: true)
    }
    
    private func addAnnotations() {
        self.clearAllAnnotations()
        
        let startAnnotation = MKPointAnnotation()
        startAnnotation.coordinate = self.tripCoords[0]
        startAnnotation.title = "Start"
        mapView.addAnnotation(startAnnotation)
        
        if self.tripCoords.count > 1 {
            let lastAnnotation = MKPointAnnotation()
            lastAnnotation.coordinate = self.tripCoords[self.tripCoords.count - 1]
            if self.end {
                lastAnnotation.title = "Finish"
            } else {
                lastAnnotation.title = "Current"
            }
            mapView.addAnnotation(lastAnnotation)
        }
    }
    
    private func addPolylineToMap() {
        self.clearAllOverlays()
        
        let coordinates = self.tripCoords
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        self.mapView.addOverlay(polyline, level: MKOverlayLevel.aboveRoads)
        self.mapView.setVisibleMapRect(polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 50.0, left: 50.0, bottom: 50.0, right: 50.0), animated: true)
    }
}

