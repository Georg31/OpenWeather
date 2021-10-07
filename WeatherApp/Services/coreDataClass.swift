//
//  coreDataClass.swift
//  WeatherApp
//
//  Created by George Digmelashvili on 10/6/21.
//

import Foundation
import CoreData

class Dbase {
    
    static let shared = Dbase()
    private init() {}
    
    func saveMovie(_ weather: WeatherViewModel) {
        if retrieveData().data.contains(where: {$0.cityName == weather.cityName && $0.isMainLocation}) { return}
        let context = AppDelegate.coreDataContainer.viewContext
        let entityDescription = NSEntityDescription.entity(forEntityName: "WeatherCache", in: context)
        let hours: [Hours] = weather.hourly.map({Hours(hour: $0.hour, url: $0.urlStringIcon, temp: $0.temp, humidity: $0.humidity)})
        let days: [Days] = weather.daily.map({Days(maxTemp: $0.maxTemp, url: $0.urlStringIcon, minTemp: $0.minTemp, humidity: $0.humidity, day: $0.day)})
        let cmsg = NSManagedObject(entity: entityDescription!, insertInto: context) as! WeatherCache
        let mRanges = HoursData(hours: hours)
        let mDays = DaysData(days: days)
        cmsg.setValue(weather.sunset, forKey: "sunset")
        cmsg.setValue(weather.sunrise, forKey: "sunrise")
        cmsg.setValue(weather.currentMax, forKey: "currentMax")
        cmsg.setValue(weather.currentMin, forKey: "currentMin")
        cmsg.setValue(weather.currentDescription, forKey: "currentDescription")
        cmsg.setValue(weather.currentTemp, forKey: "currentTemp")
        cmsg.setValue(weather.cityName, forKey: "cityName")
        cmsg.setValue(mDays, forKey: "day")
        cmsg.setValue(mRanges, forKeyPath: "hour")
        cmsg.setValue(weather.latitude, forKey: "lat")
        cmsg.setValue(weather.longtitude, forKey: "lon")
        cmsg.setValue(weather.isMainLocation, forKey: "isMainLocation")
        do {
            try context.save()
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    func retrieveData() -> WeatherDataListViewModel {
        let managedContext = AppDelegate.coreDataContainer.viewContext
        let fetchRequest: NSFetchRequest<WeatherCache> = WeatherCache.fetchRequest()
        var weather: WeatherDataListViewModel!
        do {
            let result = try managedContext.fetch(fetchRequest)
            weather = WeatherDataListViewModel(result)
        } catch {
            
            print(error.localizedDescription)
        }
        return weather
    }
    
}
