//
//  Extenstions.swift
//  WeatherApp
//
//  Created by George Digmelashvili on 10/6/21.
//

import UIKit
import Alamofire

extension UIImageView {
    
    func downloaded(from link: String) {
        guard let url = URL(string: link) else { return }
        
        AF.request(url).response { resp in
            if case .success(let image) = resp.result {
                self.image = UIImage(data: image!)
            }
        }
    }
    
}


extension Date {
    func getHourForDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        return formatter.string(from: self)
    }
    
    func getDayForDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter.string(from: self)
    }
    
}


enum WeatherTableViewSection: Int {
    
    static let numberOfSection = 2
    
    case hourly = 0
    case daily = 1
    
    init?(sectionIndex: Int) {
        guard let section = WeatherTableViewSection(rawValue: sectionIndex) else { return nil }
        self = section
    }
    
    var cellHeight: CGFloat {
        switch self {
        case .hourly:
            return CGFloat(120)
        case .daily:
            return CGFloat(50)
        }
    }
}
