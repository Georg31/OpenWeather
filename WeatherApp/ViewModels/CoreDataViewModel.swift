//
//  CoreDataViewModel.swift
//  WeatherApp
//
//  Created by George Digmelashvili on 10/7/21.
//

import Foundation


struct WeatherDataListViewModel{
    
    let data: [WeatherDataViewModel]
    
    init(_ data: [WeatherCache]){
        self.data = data.map({WeatherDataViewModel($0)})
    }
}


struct WeatherDataViewModel{
    
    let sunset: String
    let sunrise: String
    let currentMax: String
    let currentMin: String
    let currentDescription: String
    let currentTemp: String
    let cityName: String
    let latitude: Double
    let longtitude: Double
    let hourly: [HourlyViewModel]
    let daily: [DailyViewModel]
    var isMainLocation = false
    
    init(_ data: WeatherCache){
        self.sunset = data.sunset!
        self.sunrise = data.sunrise!
        self.currentMax = data.currentMax!
        self.currentMin = data.currentMin!
        self.currentDescription = data.currentDescription!
        self.currentTemp = data.currentTemp!
        self.cityName = data.cityName!
        self.latitude = data.lat
        self.longtitude = data.lon
        self.hourly = data.hour!.hours.map({HourlyViewModel($0)})
        self.daily = data.day!.days.map({DailyViewModel($0)})
        self.isMainLocation = data.isMainLocation
    }
    
    
    func hourlyAtIndex(_ index: Int) -> HourlyViewModel{
        return hourly[index]
    }
    
    func dailyAtIndex(_ index: Int) -> DailyViewModel{
        return daily[index + 1]
    }
    
}



struct DailyViewModel{
    
    let day: String
    let maxTemp: String
    let minTemp: String
    let urlStringIcon: String
    let humidity: String
    
    init(_ data: Days){
        self.day = data.day
        self.maxTemp = data.maxTemp
        self.minTemp = data.minTemp
        self.urlStringIcon = data.urlStringIcon
        self.humidity = data.humidity
    }
}


struct HourlyViewModel{
    
    let hour: String
    let urlStringIcon: String
    let humidity: String
    let temp: String
    
    init(_ data: Hours){
        self.hour = data.hour
        self.urlStringIcon = data.urlStringIcon
        self.humidity = data.humidity
        self.temp = data.temp
    }
}
