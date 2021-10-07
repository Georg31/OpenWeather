//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by George Digmelashvili on 10/4/21.
//

import UIKit
import CoreLocation

struct WeatherViewModel{
    
    private let current: Current
    let hourly: [HourWeatherViewModel]
    let daily: [DailyWeatherViewModel]
    private let city: String
    private var lon: Double
    private var lat: Double
    var isMainLocation = false
    
    init(weahter: WeatherModel, coordinates: CLLocationCoordinate2D){
        self.current = weahter.current
        self.hourly = weahter.hourly.map({HourWeatherViewModel($0)})
        self.daily = weahter.daily.map({DailyWeatherViewModel($0)})
        self.city = weahter.timezone
        self.lat = coordinates.latitude
        self.lon = coordinates.longitude
    }
}


extension WeatherViewModel{
    
    var latitude: Double{
        return self.lat
    }
    
    var longtitude: Double{
        return self.lon
    }
    
    var currentDescription: String{
        return (self.current.weather.first?.descriptionWeather.capitalized)!
    }
    
    var cityName: String{
        return self.city.components(separatedBy: "/")[1].replacingOccurrences(of: "_", with: " ")
    }
    
    var currentTemp: String{
        return String(format: "%.f", self.current.temp) + "°"
    }
    
    var currentMax: String{
        return daily.first!.maxTemp
    }
    
    var currentMin: String{
        return self.daily.first!.minTemp
    }
    
    
    func hourlyAtIndex(_ index: Int) -> HourWeatherViewModel{
        return hourly[index]
    }
    
    func dailyAtIndex(_ index: Int) -> DailyWeatherViewModel{
        return daily[index + 1]
    }
    
    var sunrise: String{
        return Date(timeIntervalSince1970: Double(current.sunrise)).getHourForDate()
    }
    
    var sunset: String{
        return Date(timeIntervalSince1970: Double(current.sunset)).getHourForDate()
    }
    
}

struct HourWeatherViewModel{
    
    private let hourly: Hourly
    
    init(_ data: Hourly){
        self.hourly = data
    }
}


extension HourWeatherViewModel{
    
    var hour: String{
        let date = Date(timeIntervalSince1970: Double(hourly.dt)).getHourForDate()
        return date
    }
    
    var urlStringIcon: String{
        return "https://openweathermap.org/img/wn/\(hourly.weather[0].icon)@2x.png"
    }
    
    var humidity: String{
        return String(self.hourly.humidity) + " %"
    }
    
    var temp: String{
        return String(format: "%.f", self.hourly.temp) + "°"
    }
}

struct DailyWeatherViewModel{
    
    private let daily: Daily
    
    init(_ data: Daily){
        self.daily = data
    }
}

extension DailyWeatherViewModel{
    
    var maxTemp: String{
        return String(format: "%.f", self.daily.temp.max) + "°"
    }
    
    var minTemp: String{
        return String(format: "%.f", self.daily.temp.min) + "°"
    }
    
    var day: String{
        return Date(timeIntervalSince1970: Double(self.daily.dt)).getDayForDate()
    }
    
    var urlStringIcon: String{
        return "https://openweathermap.org/img/wn/\(self.daily.weather[0].icon)@2x.png"
    }
    
    var humidity: String{
        return String(self.daily.humidity) + " %"
    }
}


