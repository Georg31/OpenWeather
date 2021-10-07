//
//  DailyTableViewCell.swift
//  WeatherApp
//
//  Created by George Digmelashvili on 10/5/21.
//

import UIKit

class DailyTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    
    
    private var weatherModel: DailyWeatherViewModel?
    static let identifier = "DailyTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "DailyTableViewCell",
                     bundle: nil)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imgView.image = nil
    }
    
    func configure(model: DailyWeatherViewModel) {
        dayLabel.text = model.day
        highTempLabel.text = model.maxTemp
        lowTempLabel.text = model.minTemp
        humidityLabel.text = model.humidity
        imgView.downloaded(from: model.urlStringIcon)
    }
    
    func configure(model: DailyViewModel) {
        dayLabel.text = model.day
        highTempLabel.text = model.maxTemp
        lowTempLabel.text = model.minTemp
        humidityLabel.text = model.humidity
        imgView.downloaded(from: model.urlStringIcon)
    }
}
