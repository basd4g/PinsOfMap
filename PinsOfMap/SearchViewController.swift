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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
        searchBar.placeholder = "場所を検索"
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("tapped")
        if !(searchBar.text != nil) {
            print("error, searchBar.text = nil")
            return
        }
        
        geocoding(address: searchBar.text!)
    }
    
    private func geocoding(address: String){
        var coordinate : CLLocationCoordinate2D? = nil
        CLGeocoder().geocodeAddressString(address) { placemarks, error in
            coordinate = placemarks?.first?.location?.coordinate
            if coordinate == nil {
                return
            }
            print("緯度:\(coordinate!.latitude), 経度:\(coordinate!.longitude)")
            self.revGeocoding(coordinate: CLLocation(latitude: coordinate!.latitude, longitude: coordinate!.longitude))

        }
    }
    
    private func revGeocoding(coordinate: CLLocation){
        CLGeocoder().reverseGeocodeLocation(coordinate) { placemarks, error in
            if error != nil {
                return
            }
            for placemark in placemarks! {
                let voidStr = ""
                print("Name = \(placemark.name ?? voidStr )")
                print("Country = \(placemark.country ?? voidStr )")
                print("Postal Code = \(placemark.postalCode ?? voidStr)")
                print("Administrative Area = \(placemark.administrativeArea ?? voidStr)")
                print("Sub Administrative Area = \(placemark.subAdministrativeArea ?? voidStr)")
                print("Locality = \(placemark.locality ?? voidStr)")
                print("Sub Locality = \(placemark.subLocality ?? voidStr)")
                print("Throughfare = \(placemark.thoroughfare ?? voidStr)")
            }
        }
    }
}
