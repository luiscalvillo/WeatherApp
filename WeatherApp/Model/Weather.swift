//
//  Weather.swift
//  WeatherApp
//
//  Created by Luis Calvillo on 6/4/17.
//  Copyright © 2017 Luis Calvillo. All rights reserved.
//
//
//import Foundation
//
//struct Weather {
//    
//    let city: String
//    // let country: String
//    let mainWeather: String
//    let weatherDescription: String
//    let temperature: Double
//    
//    var temperatureCelsius: Double {
//        get {
//            return temperature - 273.15
//        }
//    }
//    
//    var temperatureFahrenheit: Double {
//        get {
//            return (temperature - 273.15) * 1.8 + 32
//        }
//    }
//    
//    
//    init(weatherData: [String: AnyObject]) {
//        
//        
//        city = weatherData["name"] as! String
//        
//        let weatherDict = weatherData["weather"]![0] as! [String: AnyObject]
//        mainWeather = weatherDict["main"] as! String
//        weatherDescription = weatherDict["description"] as! String
//        
//        
//        let mainDict = weatherData["main"]![0] as! [String: AnyObject]
//        temperature = mainDict["temp"] as! Double
//    }
//}
//
//
//
//
//
//








