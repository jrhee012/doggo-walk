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

class TripViewController: UIViewController {
    let locationManager = CLLocationManager()
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var mapView: MKMapView!
    
//    var tripCoords: [NSDictionary] = []
    var tripCoords: [CLLocationCoordinate2D] = []
    
    @IBAction func backToHomeButton(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "home") as! HomeViewController
        self.dismiss(animated: true, completion: nil)
//        self.present(nextViewController, animated:true, completion:nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        print(self.tripCoords.count)
    }
}
