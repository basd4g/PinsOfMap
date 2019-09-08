//
//  PINs.swift
//  PinsOfMap
//
//  Created by 中山慶祐 on 2019/09/08.
//  Copyright © 2019 Keisuke Nakayama. All rights reserved.
//
import UIKit
import MapKit

struct PIN {
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    var title: String
    var subTitle: String
}

class PINs {
    let userDefaultKey = "PINSARRAY"
    private var uitableview: UITableView?
    private var array: [PIN]
    public var count: Int {
        get {
            return array.count
        }
    }
    init() {
        array = []
        if UserDefaults.standard.object(forKey: userDefaultKey+"_LATITUDE") == nil
            || UserDefaults.standard.object(forKey: userDefaultKey+"_LONGITUDE") == nil
            || UserDefaults.standard.object(forKey: userDefaultKey+"_TITLE") == nil
            || UserDefaults.standard.object(forKey: userDefaultKey+"_SUBTITLE") == nil {
            return
        }
        let arrayLatitude: [Double] = UserDefaults.standard.array(forKey: userDefaultKey+"_LATITUDE") as! [Double]
        let arrayLongitude: [Double] = UserDefaults.standard.array(forKey: userDefaultKey+"_LONGITUDE") as! [Double]
        let arrayTitle: [String] = UserDefaults.standard.array(forKey: userDefaultKey+"_TITLE") as! [String]
        let arraySubTitle: [String] = UserDefaults.standard.array(forKey: userDefaultKey+"_SUBTITLE") as! [String]
        
        if(arrayLatitude.count == 0) {
            return
        }
        for index in 0...(arrayLatitude.count-1) {
            array.append(PIN(latitude: arrayLatitude[index] ,
                             longitude: arrayLongitude[index] ,
                             title: arrayTitle[index],
                             subTitle: arraySubTitle[index]))
        }
        
    }
    public func registerUITableView(uitableview: UITableView){
        self.uitableview = uitableview
    }
    public func reloadUITableView(){
        if uitableview != nil {
            uitableview!.reloadData()
        }
    }
    
    public func add(annotation: MKPointAnnotation, mapView: MKMapView){
        putPin2Map(annotation: annotation, mapView: mapView)
        
        let pin = PIN(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude, title: annotation.title!, subTitle: annotation.subtitle!)
        
        if search(latitude: pin.latitude, longitude: pin.longitude) != nil {
            print("New pin already exist.")
            return
        }
        array.append(pin)
        store()
        
        self.reloadUITableView()
    }
    private func putPin2Map(annotation: MKPointAnnotation, mapView: MKMapView){
        if annotation.title == nil {
            print("Need annotation's title")
            annotation.title = ""
        }
        if  annotation.subtitle == nil {
            print("Need annotation's sub title")
            annotation.subtitle = ""
        }
        
        mapView.addAnnotation(annotation)
    }
    
    public func remove(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        if let index = self.search(latitude: latitude, longitude: longitude) {
            array.remove(at: index)
            store()
            reloadUITableView()
        }
    }
    
    public func remove(annotation: MKAnnotation, mapView: MKMapView){
        remove(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        mapView.removeAnnotation(annotation)
    }
    
    public func getArray() -> [PIN] {
        return array
    }
    
    public func getPin(index: Int) -> CLLocationCoordinate2D{
        return CLLocationCoordinate2D(latitude: array[index].latitude, longitude: array[index].longitude)
    }
    
    public func getTitle(index: Int) -> String{
        return array[index].title
    }
    
    private func search(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> Int?{
        if array.count == 0 {
            return nil
        }
        for index in 0...(self.array.count-1) {
            if array[index].latitude == latitude && array[index].longitude == longitude {
                return index
            }
        }
        return nil
    }
    
    private func store(){
        var arrayLatitude: [Double] = []
        var arrayLongitude: [Double] = []
        var arrayTitle: [String] = []
        var arraySubTitle: [String] = []
        for pin in array {
            arrayLatitude.append(pin.latitude )
            arrayLongitude.append(pin.longitude )
            arrayTitle.append(pin.title)
            arraySubTitle.append(pin.subTitle)
        }
        UserDefaults.standard.set(arrayLatitude, forKey: userDefaultKey+"_LATITUDE")
        UserDefaults.standard.set(arrayLongitude, forKey: userDefaultKey+"_LONGITUDE")
        UserDefaults.standard.set(arrayTitle, forKey: userDefaultKey+"_TITLE")
        UserDefaults.standard.set(arraySubTitle, forKey: userDefaultKey+"_SUBTITLE")
    }
    
    public func reflectStoredPin(mapView: MKMapView){
        if array.count == 0 {
            return
        }
        for pin in array {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
            annotation.title = pin.title
            annotation.subtitle = pin.subTitle
            putPin2Map(annotation: annotation, mapView: mapView)
        }
    }
    
    
}

var PINS = PINs()
