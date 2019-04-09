//
//  HomeViewController.swift
//  doggo-walk
//
//  Created by Jaehyuk Rhee on 4/9/19.
//  Copyright © 2019 Jaehyuk Rhee. All rights reserved.
//

import UIKit
import CoreLocation

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    let userDefaults = UserDefaults.standard
    
    let startTitle = "Start"
    let viewMapTitle = "View Map"
    
    var tripCoords: [CLLocationCoordinate2D] = []
    var start = false
    var end = true
    
    @IBOutlet weak var finishButtonUI: UIButton!
    @IBOutlet weak var startButtonUI: UIButton!
    
    private func popTripView() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let tripViewController = storyBoard.instantiateViewController(withIdentifier: "trip") as! TripViewController
        self.present(tripViewController, animated: true, completion: nil)
    }
    
    private func popTripView(tripCoords: [CLLocationCoordinate2D]) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let tripViewController = storyBoard.instantiateViewController(withIdentifier: "trip") as! TripViewController
        tripViewController.tripCoords = self.tripCoords
        self.present(tripViewController, animated: true, completion: nil)
    }
    
    @IBAction func finishButtonUp(_ sender: Any) {
        self.start = false
        self.end = true
        
        self.popTripView(tripCoords: self.tripCoords)
        self.tripCoords = []
        self.viewDidLoad()
    }
    
    @IBAction func startButtonDown(_ sender: Any) {
        let buttonTitle = startButtonUI.currentTitle
        if buttonTitle == self.startTitle {
            self.start = true
            self.end = false
            self.locationManager.startUpdatingLocation()
        }
        
        if self.tripCoords.count > 0 {
            self.popTripView(tripCoords: self.tripCoords)
        }
        
//        self.popTripView(tripCoords: self.tripCoords)
        self.viewDidLoad()
    }
    
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
//            self.locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !self.end {
            guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
            self.tripCoords.append(locValue)
            if self.tripCoords.count == 1 {
                self.popTripView(tripCoords: self.tripCoords)
            }
            print(self.tripCoords.count)
        } else {
            self.locationManager.stopUpdatingLocation()
        }
    }
}

