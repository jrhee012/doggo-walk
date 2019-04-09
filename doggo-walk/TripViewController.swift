//
//  TripViewController.swift
//  doggo-walk
//
//  Created by Jaehyuk Rhee on 4/9/19.
//  Copyright © 2019 Jaehyuk Rhee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class TripViewController: UIViewController, MKMapViewDelegate {
    let locationManager = CLLocationManager()
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var mapView: MKMapView!
    
    var tripCoords: [CLLocationCoordinate2D] = []
    var ended = false
    
    @IBAction func backToHomeButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        mapView.delegate = self
        
        self.addAnnotations()
        self.addPolylineToMap()
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
    
    private func addAnnotations() {
        let startAnnotation = MKPointAnnotation()
        startAnnotation.coordinate = self.tripCoords[0]
        startAnnotation.title = "Start"
        mapView.addAnnotation(startAnnotation)
        
        let lastAnnotation = MKPointAnnotation()
        lastAnnotation.coordinate = self.tripCoords[self.tripCoords.count - 1]
        if self.ended {
            lastAnnotation.title = "Finish"
        } else {
            lastAnnotation.title = "Current"
        }
        mapView.addAnnotation(lastAnnotation)
    }
    
    private func addPolylineToMap() {
        let coordinates = self.tripCoords
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        self.mapView.addOverlay(polyline, level: MKOverlayLevel.aboveRoads)
        self.mapView.setVisibleMapRect(polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 50.0, left: 50.0, bottom: 50.0, right: 50.0), animated: true)
    }
}
