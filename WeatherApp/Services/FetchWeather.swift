//
//  FetchWeather.swift
//  WeatherApp
//
//  Created by George Digmelashvili on 10/6/21.
//

import Foundation
import CoreLocation

struct OpenWeatherAPI {
    static let scheme = "https"
    static let host = "api.openweathermap.org"
    static let path = "/data/2.5"
    //static let key = "da2798e7e8c96956caff9ac80cce3ebe"
    static let key = "c0d037bbf0a21990121457947f5785ef"
}

class ApiCall{
    
    static let shared = ApiCall()
    private var urlString = ""
    
    private init(){}
    
    private func locationWeatherURL(latitude: CLLocationDegrees, longitude: CLLocationDegrees) -> String {
        var components = URLComponents()
        components.scheme = OpenWeatherAPI.scheme
        components.host = OpenWeatherAPI.host
        components.path = OpenWeatherAPI.path + "/onecall"
        components.queryItems = [URLQueryItem(name: "lat", value: String(latitude)),
                                 URLQueryItem(name: "lon", value: String(longitude)),
                                 URLQueryItem(name: "exclude", value: "minutely"),
                                 URLQueryItem(name: "units", value: "metric"),
                                 URLQueryItem(name: "appid", value: OpenWeatherAPI.key)]
        guard let componentsString = components.string else { return "" }
        return componentsString
    }
    
    func fetchWeather(cordinates: CLLocationCoordinate2D, completion: @escaping (WeatherViewModel) -> Void) {
        let urlString = locationWeatherURL(latitude: cordinates.latitude, longitude: cordinates.longitude)
        guard let url = URL(string: urlString) else {return}
        print(url)
        let resource = Resource<WeatherModel>(url: url)
        Webservice.load(resource: resource) { result in
            switch result {
            case .success(let data):
                completion(WeatherViewModel(weahter: data, coordinates: cordinates))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

