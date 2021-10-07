//
//  DailyCoreDataModel.swift
//  WeatherApp
//
//  Created by George Digmelashvili on 10/6/21.
//

import Foundation

public class DaysData: NSObject, NSCoding {
    
    public var days: [Days] = []
    
    enum Key: String {
        case days = "days"
    }
    
    init(days: [Days]) {
        self.days = days
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(days, forKey: Key.days.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let mDays = aDecoder.decodeObject(forKey: Key.days.rawValue) as! [Days]
        
        self.init(days: mDays)
    }
}

public class Days: NSObject, NSCoding {
    
    public var maxTemp: String = ""
    public var minTemp: String = ""
    public var day: String = ""
    public var urlStringIcon: String = ""
    public var humidity: String = ""
    
    enum Key:String {
        case maxTemp = "maxTemp"
        case urlStringIcon = "urlStringIcon"
        case minTemp = "minTemp"
        case humidity = "humidity"
        case day = "day"
    }
    init(maxTemp: String, url: String, minTemp: String, humidity: String, day: String) {
        self.maxTemp = maxTemp
        self.urlStringIcon = url
        self.minTemp = minTemp
        self.humidity = humidity
        self.day = day
    }
    
    public override init() {
        super.init()
    }
    
    public func encode(with aCoder: NSCoder) {
        
        aCoder.encode(maxTemp, forKey: Key.maxTemp.rawValue)
        aCoder.encode(urlStringIcon, forKey: Key.urlStringIcon.rawValue)
        aCoder.encode(minTemp, forKey: Key.minTemp.rawValue)
        aCoder.encode(humidity, forKey: Key.humidity.rawValue)
        aCoder.encode(day, forKey: Key.day.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let mMaxTemp = aDecoder.decodeObject(forKey: Key.maxTemp.rawValue) as! String
        let murlStringIcon = aDecoder.decodeObject(forKey: Key.urlStringIcon.rawValue) as! String
        let mMinTemp = aDecoder.decodeObject(forKey: Key.minTemp.rawValue) as! String
        let mhumidity = aDecoder.decodeObject(forKey: Key.humidity.rawValue) as! String
        let mDay = aDecoder.decodeObject(forKey: Key.day.rawValue) as! String
        
        
        self.init(maxTemp: mMaxTemp, url: murlStringIcon, minTemp: mMinTemp, humidity: mhumidity, day: mDay)
    }
}
