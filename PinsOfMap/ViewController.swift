//
//  ViewController.swift
//  PinsOfMap
//
//  Created by 中山慶祐 on 2019/09/06.
//  Copyright © 2019 Keisuke Nakayama. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    let manager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var longPressGesRec: UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locations: \(locations)")
        
        let current = locations[0]
        let region = MKCoordinateRegion(center: current.coordinate, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error = \(error)")
    }

    @IBAction func mapViewDidLongPress(_ sender: UIGestureRecognizer) {
        if sender.state == .began {
            //tap start
            print(".start")
        } else if sender.state == .ended {
            //tap finish
            print(".finish")
        }
    }
}

