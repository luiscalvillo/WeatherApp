//
//  ViewController.swift
//  WeatherApp
//
//  Created by Luis Calvillo on 5/20/17.
//  Copyright © 2017 Luis Calvillo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // Mark: - Properties
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    
    

    
    private let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather"
    private let openWeatherMapAPIKey = "fe93902cb706356ed79462fb2658b5a4"
   
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        cityNameLabel.text = ""
        temperatureLabel.text = ""
        weatherLabel.text = ""
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getWeather()
    }

    // MARK: - Actions
  
    
    var currentLocation = location
    
//cityNameTextField.text!.replacingOccurrences(of: " ", with: "%20")
    
    
    func didGetWeather(weather: Weather) {
        self.cityNameLabel.text = weather.city
        self.temperatureLabel.text = "\(Int(weather.temperatureFahrenheit))"
        
    }
    
    func getWeather() {
        if let url = URL(string: "\(openWeatherMapBaseURL)?q=" + location + "&appid=\(openWeatherMapAPIKey)") {
            
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error)
                } else {
                    if let urlContent = data {
                        
                        do {
                            let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject
                            
                            
                            
                            // weather description
                            if let description = ((jsonResult["weather"] as? NSArray)?[0] as? NSDictionary)?["description"] as? String {
                                DispatchQueue.main.sync(execute: {
                                    self.weatherLabel.text = description
                                })
                            }
                            
                            
                            /* // could not get to work
                            // temperature
                            if let temperature = ((jsonResult["main"] as! [String: AnyObject])["temp"] as? Double) {
                                DispatchQueue.main.sync(execute: {
                                    self.temperatureLabel.text = temperature as? String
                                })
                            }
                            */
                            
                            if let main = jsonResult["main"] as? NSDictionary {
                                if let temp = main["temp"] as? Double {
                                    
                                    // fixed weather from not showing up by using dispatch
                                    DispatchQueue.main.sync(execute: {
                                        self.temperatureLabel.text = String(temp)
                                    })
                                    
                                   
                            
                                }
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
    }
    
    
    
}





