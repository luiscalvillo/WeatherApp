//
//  SettingsViewController.swift
//  WeatherApp
//
//  Created by Luis Calvillo on 6/5/17.
//  Copyright © 2017 Luis Calvillo. All rights reserved.
//

import UIKit
import CoreLocation

 var location = ""

//let notificationKey = "com.artoftheapp.notificationKey"


class SettingsViewController: UITableViewController, CLLocationManagerDelegate {
    
    //var currentLocation = "San-diego"
    var settingsArray = ["Units: Fº/Cº", "Use Location"]
    
   
    
    let manager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
       
       
        
    }

    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation: CLLocation = locations[0]
        
        CLGeocoder().reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if error != nil {
                print(error)
            } else {
                if let placemark = placemarks?[0] {
                    var address = ""
                    if placemark.locality != nil {
                        address += placemark.locality! + ", "
                        location = placemark.locality!
                    }
                    
                    if placemark.administrativeArea != nil {
                        address += placemark.administrativeArea!
                    }
                    
                    print(placemark)
                    
                    //NotificationCenter.default.addObserver(self, selector: #selector(self.setLocation), name: NSNotification.Name(rawValue: notificationKey), object: nil)
                    
                }
            }
        }
    }

    
    
   

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SettingsCell

        cell.textLabel?.text = settingsArray[indexPath.row]
        
        
     
        if indexPath.row == 1 {
            cell.currentLocationSwitch.isHidden = false
            
            if cell.currentLocationSwitch.isOn {
                manager.delegate = self
                manager.desiredAccuracy = kCLLocationAccuracyBest
                manager.requestWhenInUseAuthorization()
                manager.startUpdatingLocation()
                
               // NotificationCenter.default.addObserver(self, selector: <#T##Selector#>, name: <#T##NSNotification.Name?#>, object: <#T##Any?#>)
                
                           }
        }
        
        
        // this brings the switch button to show on top of the cell
        cell.contentView.bringSubview(toFront: cell.currentLocationSwitch)
        return cell
    }

   
    



}
