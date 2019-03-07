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
    @IBOutlet weak var backgroundView: UIView!
    
    var gradientLayer = CAGradientLayer()
    
    private let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather"
    private let openWeatherMapAPIKey = "fe93902cb706356ed79462fb2658b5a4"
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        backgroundView.layer.addSublayer(gradientLayer)
    
        cityNameLabel.text = ""
        temperatureLabel.text = ""
        weatherLabel.text = ""
        getWeather()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getWeather()
    }

    // MARK: - Actions
  
    var currentLocation = location
    
    func didGetWeather(weather: Weather) {
        self.cityNameLabel.text = weather.city
        self.temperatureLabel.text = "\(Int(weather.temperatureFahrenheit))"
        
    }
    
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
                            
                            if let main = jsonResult["main"] as? NSDictionary {
                                if let temp = main["temp"] as? Double {
                                    
                                    DispatchQueue.main.sync(execute: {
                                        self.temperatureLabel.text = "\(Int((temp - 273.15) * 1.8 + 32))°"
                                        
                                    })
                                }
                            }
                            
                            if let iconName = ((jsonResult["weather"] as? NSArray)?[0] as? NSDictionary)?["icon"] as? String {
                                DispatchQueue.main.sync(execute: {
                                    let suffix = iconName.suffix(1)
                                    
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
    }
    
}





