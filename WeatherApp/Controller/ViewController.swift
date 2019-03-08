//
//  ViewController.swift
//  WeatherApp
//
//  Created by Luis Calvillo on 5/20/17.
//  Copyright © 2017 Luis Calvillo. All rights reserved.
//

import UIKit
import CoreLocation

var location = ""

class ViewController: UIViewController, CLLocationManagerDelegate {

    // Mark: - Properties
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    @IBOutlet weak var weatherImageView: UIImageView!
    
    var gradientLayer = CAGradientLayer()
    
    private let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather"
    private let openWeatherMapAPIKey = "fe93902cb706356ed79462fb2658b5a4"
    
    let manager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.layer.addSublayer(gradientLayer)
    
        cityNameLabel.text = ""
        temperatureLabel.text = ""
        weatherLabel.text = ""
                
        manager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.locationServicesEnabled()) {
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.startUpdatingLocation()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setDayTimeGradientBackground()
        getWeather(city: location)

    }

    // MARK: - Actions
  
//    var currentLocation = location
    
//    func didGetWeather(weather: Weather) {
//        self.cityNameLabel.text = weather.city
//        self.temperatureLabel.text = "\(Int(weather.temperatureFahrenheit))"
//        
//    }
    
    func setDayTimeGradientBackground() {
        let topColor = UIColor(red: 50.0/255.0, green: 142.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 50.0/255.0, green: 231.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor, bottomColor]
    }
    
    func setNightTimeGradientBackground() {
        let topColor = UIColor(red: 22.0/255.0, green: 19.0/255.0, blue: 56.0/255.0, alpha: 1.0).cgColor
        let bottomColor = UIColor(red: 63.0/255.0, green: 56.0/255.0, blue: 165.0/255.0, alpha: 1.0).cgColor
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [topColor, bottomColor]
    }
    
    func updateUI() {
        cityNameLabel.text = "test3"
        temperatureLabel.text = "test2"
        weatherLabel.text = "test"
    }
    
    
    func getWeather(city: String) {
        
        print("WE got the weather")
        if let url = URL(string: "\(openWeatherMapBaseURL)?q=" + city + "&appid=\(openWeatherMapAPIKey)") {
            print("Step 2")
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error)
                } else {
                    print("Step 3")
                    if let urlContent = data {
                        print("step 4")
                        do {
                            let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                            print("step 5")
                            // weather description
                            if let description = ((jsonResult["weather"] as? NSArray)?[0] as? NSDictionary)?["description"] as? String {
                                print("Step 5.a")
                                DispatchQueue.main.sync(execute: {
                                    self.weatherLabel.text = description
                                })
                            }
                            
                            if let main = jsonResult["main"] as? NSDictionary {
                                print("Step 6.a")
                                if let temp = main["temp"] as? Double {
                                    print("step 6")
                                    DispatchQueue.main.sync(execute: {
                                        self.temperatureLabel.text = "\(Int((temp - 273.15) * 1.8 + 32))°"
                                        
                                        print("Temp: \(temp)")
                                    })
                                }
                            }
                            print("Step 7")
                            if let iconName = ((jsonResult["weather"] as? NSArray)?[0] as? NSDictionary)?["icon"] as? String {
                            
                                print("step 8")
                                DispatchQueue.main.sync(execute: {
                                    self.weatherImageView.image = UIImage(named: iconName)
                                    print(iconName)
                                    
                                    let suffix = iconName.suffix(1)
                                    print(iconName)
                                    
                                    print("suffix\(suffix)")
                                    
                                    if (suffix == "n") {
                                        self.setNightTimeGradientBackground()
                                    } else {
                                        self.setDayTimeGradientBackground()
                                    }
                                    
                                })
                            }
                            
                            // city name
                            if let name = jsonResult["name"] as? String {
                                DispatchQueue.main.sync(execute: {
                                    self.cityNameLabel.text = name
                                })
                            }
                
                        } catch {
                            print("JSON Processing Failed")
                        }
                    }
                }
            }
            
            task.resume()
        } else {
            weatherLabel.text = "Couldn't find weather for that city - please try another."
        }
        
//        manager.stopUpdatingLocation()


//        weatherLabel.text = description
        
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
                        location = placemark.locality!.replacingOccurrences(of: " ", with: "%20")
                        
                        self.getWeather(city: location)
                    }
                    
                    if placemark.administrativeArea != nil {
                        address += placemark.administrativeArea!
                    }
                    
                    print(placemark)
                }
            }
        }
        
        self.manager.stopUpdatingLocation()
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    
    
}






