//
//  HourlyCollectionViewCell.swift
//  WeatherApp
//
//  Created by George Digmelashvili on 10/5/21.
//

import UIKit

final class HourlyCollectionViewCell: UICollectionViewCell {
    
   
   
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    
    
    static let identifier = "HourlyCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "HourlyCollectionViewCell",
                     bundle: nil)
    }
    
    func setupCell(_ viewModel: WeatherViewModel, index: Int) {
        
        let hourly = viewModel.hourlyAtIndex(index)
        timeLabel.text = index == 0 ? "Now" : hourly.hour
        tempLabel.text = hourly.temp
        humidityLabel.text = hourly.humidity
        
        if hourly.hour == viewModel.sunrise{
            iconImageView.image = #imageLiteral(resourceName: "sunrise")
        } else if hourly.hour == viewModel.sunset{
            iconImageView.image = #imageLiteral(resourceName: "sunset")
        } else {
            iconImageView.downloaded(from: hourly.urlStringIcon)
        }
    }
    
    func setupCell(_ viewModel: WeatherDataViewModel, index: Int) {
        
        let hourly = viewModel.hourlyAtIndex(index)
        timeLabel.text = index == 0 ? "Now" : hourly.hour
        tempLabel.text = hourly.temp
        humidityLabel.text = hourly.humidity
        
        if hourly.hour == viewModel.sunrise{
            iconImageView.image = #imageLiteral(resourceName: "sunrise")
        } else if hourly.hour == viewModel.sunset{
            iconImageView.image = #imageLiteral(resourceName: "sunset")
        } else {
            iconImageView.downloaded(from: hourly.urlStringIcon)
        }
    }
    
}

