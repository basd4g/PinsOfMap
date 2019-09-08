//
//  ViewController.swift
//  PinsOfMap
//
//  Created by 中山慶祐 on 2019/09/06.
//  Copyright © 2019 Keisuke Nakayama. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate, MKMapViewDelegate {
    let manager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var longPressGesRec: UILongPressGestureRecognizer!
    
    var pinsCount: Int = 0
    var nowLocationCoordinate: CLLocationCoordinate2D?
    var nowLocationLoading: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.delegate = self
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            manager.requestWhenInUseAuthorization()
        }
        
        // コンパスの表示
        let compass = MKCompassButton(mapView: mapView)
        compass.compassVisibility = .visible
        compass.frame = CGRect(x: self.view.bounds.width - 50, y: 50, width: 40, height: 40)
        self.view.addSubview(compass)
        // デフォルトのコンパスを非表示にする
        mapView.showsCompass = false
        
        // スケールバーの表示
        let scale = MKScaleView(mapView: mapView)
        scale.frame.origin.x = 15
        scale.frame.origin.y = 45
        scale.legendAlignment = .leading
        self.view.addSubview(scale)
        
        //nowLocationボタン
        let button = UIButton(type: UIButton.ButtonType.system)
        button.addTarget(self, action: #selector(nowLocationTapped(_:)), for: UIControl.Event.touchUpInside)
        button.setTitle("hello", for: .normal)
        button.frame = CGRect(x: self.view.bounds.width - 50, y: 100, width: 40, height: 40)
        let image = UIImage(named: "neer-me")
        button.setImage(image!, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        self.view.addSubview(button)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locations: \(locations)")
        
        nowLocationCoordinate = locations[0].coordinate
        nowLocationLoading = false
    }
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error = \(error)")
        nowLocationLoading = false
    }

    @IBAction func mapViewDidLongPress(_ sender: UIGestureRecognizer) {
        if sender.state == .began {
            //tap start
            print(".start")
        } else if sender.state == .ended {
            //tap finish
            print(".finish")
            let tapPoint = sender.location(in: view)
            let center = mapView.convert(tapPoint, toCoordinateFrom: mapView)
            addPins(point: center)
            
            
        }
    }
    
    private func addPins(point: CLLocationCoordinate2D) {
        GeoCode.getNameAndAddress(latitude: point.latitude, longitude: point.longitude, callback: {
           (name,address) in
            let annotation : MKPointAnnotation = MKPointAnnotation()
            annotation.coordinate = point
            annotation.title = name
            annotation.subtitle = address
            
            PINS.add(annotation: annotation, mapView: self.mapView)
            
            self.showPoint(point: point)
        })
    }
    
    func showPoint(point: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: point, latitudinalMeters: 500, longitudinalMeters: 500)
        mapView.setRegion(region, animated: true)
    }
    
    @objc func nowLocationTapped(_ sender: UIButton) {
        if nowLocationCoordinate == nil {
            var title: String = ""
            var message: String = ""
            if nowLocationLoading == true {
                title = "現在地を読み込み中"
                message = "しばらくお待ちください"
            } else {
                title = "現在地が不明"
                message = "現在地の読み込みに失敗しました"
            }
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {
                (action: UIAlertAction!) -> Void in print ("ok")})
            alert.addAction(okButton)
            present(alert, animated: true, completion: nil)
            return
        }
        showPoint(point: nowLocationCoordinate!)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.animatesDrop = true
        }
        else {
            pinView?.annotation = annotation
        }
        
//        pinView?.pinTintColor = UIColor.purple
        
        pinView?.canShowCallout = true
        
        let rightButton: AnyObject! = UIButton(type: UIButton.ButtonType.detailDisclosure)
        pinView?.rightCalloutAccessoryView = rightButton as? UIView
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
//        print("tapped")
//        print(#function)
//        let str: String = view.annotation?.title == nil ?  "" : (view.annotation?.title!)!
//        print(str)
        
        let alert = UIAlertController(title: (view.annotation?.title!)!, message: (view.annotation?.subtitle!)!, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "ピンを削除", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) -> Void in
                PINS.remove(annotation: view.annotation!, mapView: self.mapView)
        })
        alert.addAction(okButton)
        
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action: UIAlertAction!) -> Void in return})
        alert.addAction(cancelButton)
        
        present(alert, animated: true, completion: nil)
    }
}
