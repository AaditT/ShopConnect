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


class InfoViewController: UIViewController {
    
    let db = Firestore.firestore()
    var lat: Double = 0
    var lon: Double = 0
    var orderType: String?
    

    
    @IBOutlet weak var useLabel: UIButton!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var myMap: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(InfoViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
    }
    @objc func didTapView(){
      self.view.endEditing(true)
    }
    @IBAction func getLocationPressed(_ sender: UIButton) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    var numbers: [String] = []
    var availableMessage: String = ""
    var number: String = ""
    var typeLabelText: String = ""
    @IBAction func nextPressed(_ sender: UIButton) {
        var lookFor: String {
            if (orderType! == "order") {
                return "deliver"
            }
            return "order"
        }
        let data: [String: Any] = [
            "usageType": self.orderType!,
            "location": GeoPoint(latitude: self.lat, longitude: self.lon),
            "number": self.numberField.text!
        ]
        let doc_id: String = self.numberField.text!
        self.db.collection("users").document(doc_id).setData(data)
        var lookForEr: String {
            return lookFor + "er"
        }
        var lookForErs: String {
            return lookFor + "ers"
        }
            
        
        // Try ordering by timestamp?
        let query = db.collection("users").whereField("usageType", isEqualTo: lookFor)
        query.getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    if (querySnapshot!.documents.count >= 1) {
                        self.number = querySnapshot!.documents[0].data()["number"]! as! String
                        print("FOUND: \(self.number)")
                        self.availableMessage = ""
                        if (lookFor == "order") {
                            self.typeLabelText = "Your Orderer:"
                            self.db.collection("users").document(self.number).delete() { err in
                                if let err = err {
                                    print("Error removing document: \(err)")
                                } else {
                                    print("Document successfully removed!")
                                }
                            }

                        } else {
                            self.typeLabelText = "Your Deliverer:"
                        }
                        DispatchQueue.main.asyncAfter(deadline:.now() + 1.5, execute: {
                            self.performSegue(withIdentifier: "infoToConnection", sender: self)
                        })
                    } else {
                        self.availableMessage = "There are no available \(lookForErs) at the moment. Your contact has been saved and when a \(lookForEr) registers, you will be contacted!"
                        DispatchQueue.main.asyncAfter(deadline:.now() + 1.5, execute: {
                            self.performSegue(withIdentifier: "infoToConnection", sender: self)
                        })
                        
                    }
                }
        }
       
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "infoToConnection" {
            let destinationVC = segue.destination as! ConnectedViewController
            destinationVC.availableMessage = availableMessage
            destinationVC.number = number
            destinationVC.typeLabelText = typeLabelText

        }
    }
}

//MARK: - CLLocationManagerDelegate

extension InfoViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
         //print("error:: \(error.localizedDescription)")
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
}

//MARK: - UITextFieldDelegate

extension InfoViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        numberField.endEditing(true)
        
        //print(numberField.text!)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Use searchTextField.text to get the weather for the city.
        numberField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if numberField.text != "" {
            return true
        } else {
            numberField.placeholder = "Enter number..."
            return false
        }
    }
}
