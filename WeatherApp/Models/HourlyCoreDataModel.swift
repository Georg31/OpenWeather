//
//  HourlyCoreDataModel.swift
//  WeatherApp
//
//  Created by George Digmelashvili on 10/6/21.
//

import Foundation

public class HoursData: NSObject, NSCoding {
    
    public var hours: [Hours] = []
    
    enum Key: String {
        case hours = "hours"
    }
    
    init(hours: [Hours]) {
        self.hours = hours
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(hours, forKey: Key.hours.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let mhours = aDecoder.decodeObject(forKey: Key.hours.rawValue) as! [Hours]
        
        self.init(hours: mhours)
    }
    
    
}

public class Hours: NSObject, NSCoding {
    
    public var hour: String = ""
    public var urlStringIcon: String = ""
    public var temp: String = ""
    public var humidity: String = ""
    
    enum Key:String {
        case hour = "hour"
        case urlStringIcon = "urlStringIcon"
        case temp = "temp"
        case humidity = "humidity"
    }
    init(hour: String, url: String, temp: String, humidity: String) {
        self.hour = hour
        self.urlStringIcon = url
        self.temp = temp
        self.humidity = humidity
    }
    
    public override init() {
        super.init()
    }
    
    public func encode(with aCoder: NSCoder) {
        
        aCoder.encode(hour, forKey: Key.hour.rawValue)
        aCoder.encode(urlStringIcon, forKey: Key.urlStringIcon.rawValue)
        aCoder.encode(temp, forKey: Key.temp.rawValue)
        aCoder.encode(humidity, forKey: Key.humidity.rawValue)
    }
    
    public required convenience init?(coder aDecoder: NSCoder) {
        let mhour = aDecoder.decodeObject(forKey: Key.hour.rawValue) as! String
        let murlStringIcon = aDecoder.decodeObject(forKey: Key.urlStringIcon.rawValue) as! String
        let mtemp = aDecoder.decodeObject(forKey: Key.temp.rawValue) as! String
        let mhumidity = aDecoder.decodeObject(forKey: Key.humidity.rawValue) as! String
        
        
        self.init(hour: mhour, url: murlStringIcon, temp: mtemp, humidity: mhumidity)
    }
}
