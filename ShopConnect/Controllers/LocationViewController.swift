//
//  LocationViewController.swift
//  ShopConnect
//
//  Created by Aadit Trivedi on 7/10/20.
//  Copyright © 2020 Aadit Trivedi. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Firebase

class InfoViewController: UIViewController, CLLocationManagerDelegate {
    
    let db = Firestore.firestore()
    var lat: Double = 0
    var lon: Double = 0
    
    @IBOutlet weak var myMap: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
    }
    
    @IBAction func getLocationPressed(_ sender: UIButton) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         print("error:: \(error.localizedDescription)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        let span:MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region: MKCoordinateRegion = MKCoordinateRegion(center: myLocation, span: span)
        myMap.setRegion(region, animated:true)
        self.myMap.showsUserLocation = true
    }
    
    @IBAction func nextPressed(_ sender: UIButton) {
        db.collection("users").addDocument(data: [
            "usageType": "order",
            "location": GeoPoint(latitude: lat, longitude: lon)
            ]) { (error) in
            if let e = error {
                print("There was an issue saving data to firestore.", e)
            } else {
                print("Successfully saved data.")
            }
        }
    }
    
    
}


extension InfoViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Use searchTextField.text to get the weather for the city.
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something"
            return false
        }
    }
}
