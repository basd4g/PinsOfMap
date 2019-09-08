//
//  Geocode.swift
//  PinsOfMap
//
//  Created by 中山慶祐 on 2019/09/08.
//  Copyright © 2019 Keisuke Nakayama. All rights reserved.
//

import MapKit

class GeoCode {
    /*
     static func getLatitudeAndLongitude(searchWord: String, callback:(CLLocationDegrees,CLLocationDegrees)->Void) {
     
     }*/
    
    static func getNameAndAddress(latitude: CLLocationDegrees, longitude: CLLocationDegrees, callback: @escaping (String,String)->Void){
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            guard let placemark = placemarks?.first, error == nil else { return }
            
            let name = placemark.name ?? ""
            var address = ""
            if placemark.country != "日本" && placemark.country != "Japan" {
                address += placemark.country ?? ""
            }
            address += placemark.administrativeArea ?? ""
            address += placemark.locality ?? ""
            address += placemark.thoroughfare ?? ""
            address += placemark.subThoroughfare ?? ""
            
            callback(name,address)
        }
    }
}


