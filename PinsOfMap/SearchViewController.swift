//
//  SearchViewController.swift
//  PinsOfMap
//
//  Created by 中山慶祐 on 2019/09/07.
//  Copyright © 2019 Keisuke Nakayama. All rights reserved.
//

import UIKit
import MapKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var placeName: UILabel!
    @IBOutlet weak var placeZipCode: UILabel!
    @IBOutlet weak var placeAddress: UILabel!
    
    var coordinate: CLLocationCoordinate2D? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        searchBar.placeholder = "場所を検索"
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("tapped")
        placeName.text = "施設名: "
        placeZipCode.text = "〒: "
        placeAddress.text = "住所: "
        if !(searchBar.text != nil) {
            print("error, searchBar.text = nil")
            return
        }
        
//        geocoding(address: searchBar.text!)
        GeoCode.getLatitudeAndLongitude(searchWord: searchBar.text!){
            coordinate in
            GeoCode.getNameAndAddress(coordinate: coordinate){
                (name,zipCode,address) in
                self.placeName.text = "施設名: \(name)"
                self.placeZipCode.text = "〒 \(zipCode)"
                self.placeAddress.text = "住所: \(address)"
                self.coordinate = coordinate
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if searchBar.isFirstResponder {
            searchBar.resignFirstResponder()
        }
    }
    /*
    private func geocoding(address: String){
        var coordinate : CLLocationCoordinate2D? = nil
        CLGeocoder().geocodeAddressString(address) { placemarks, error in
            coordinate = placemarks?.first?.location?.coordinate
            if coordinate == nil {
                return
            }
            GeoCode.getNameAndAddress(coordinate: coordinate!){
                (name,zipCode,address) in
                self.placeName.text = "施設名: \(name)"
                self.placeZipCode.text = "〒 \(zipCode)"
                self.placeAddress.text = "住所: \(address)"
                self.coordinate = coordinate!
            }
        }
    }

    private func revGeocoding(coordinate: CLLocationCoordinate2D){
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else { return }

            let voidStr = ""
            
            self.placeName.text = "施設名: \(placemark.name ?? voidStr)"
            self.placeZipCode.text = "〒 \(placemark.postalCode ?? voidStr)"
            
            var address = "住所: "
            if placemark.country != "日本" && placemark.country != "Japan" {
                address += "\(placemark.country ?? voidStr) "
            }
            address += placemark.administrativeArea ?? ""
            address += placemark.locality ?? ""
            address += placemark.thoroughfare ?? ""
            address += placemark.subThoroughfare ?? ""
            self.placeAddress.text = address
            
            self.coordinate = coordinate
        }
    }*/
    
    @IBAction func ViewOnMapButtonTapped(_ sender: UIButton) {
        if coordinate == nil {
            return
        }
        print("lat: \(coordinate!.latitude), lng: \(coordinate!.longitude)")
        
        let UINavigationController = tabBarController?.viewControllers?[0]
        tabBarController?.selectedViewController = UINavigationController
        
        if let controller: ViewController = tabBarController?.viewControllers?[0] as? ViewController {
            controller.showPoint(point: coordinate!)
        
        }
        
    }
}
