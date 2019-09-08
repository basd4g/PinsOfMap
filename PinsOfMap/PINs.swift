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
    private var uitableview: UITableView?
    private var array: [PIN]
    public var count: Int {
        get {
            return array.count
        }
    }
    init() {
        array = []
    }
    public func registerUITableView(uitableview: UITableView){
        self.uitableview = uitableview
    }
    public func reloadUITableView(){
        if uitableview != nil {
            print("reloadUITableView")
            uitableview!.reloadData()
        }
    }
    
    public func add(annotation: MKPointAnnotation, mapView: MKMapView){
        if annotation.title == nil {
            print("Need annotation's title")
            annotation.title = ""
        }
        if  annotation.subtitle == nil {
            print("Need annotation's sub title")
            annotation.subtitle = ""
        }
        
        mapView.addAnnotation(annotation)
        
        let pin = PIN(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude, title: annotation.title!, subTitle: annotation.subtitle!)
        
        if search(latitude: pin.latitude, longitude: pin.longitude) != nil {
            print("New pin already exist.")
            return
        }
        array.append(pin)
        
        self.reloadUITableView()
    }
    
    public func remove(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        if let index = self.search(latitude: latitude, longitude: longitude) {
            array.remove(at: index)
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
}

var PINS = PINs()
