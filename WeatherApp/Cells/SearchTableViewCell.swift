//
//  SearchTableViewCell.swift
//  WeatherApp
//
//  Created by George Digmelashvili on 10/7/21.
//

import UIKit
import CoreLocation

protocol AddNewCity{
    func addNewCity(placeMark: CLPlacemark)
}

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var cityLabel: UILabel!
    private var placeMark: CLPlacemark!
    private var delegate: AddNewCity?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpCell(placeMark: CLPlacemark, del: AddNewCity){
        self.cityLabel.text = placeMark.name! + ", " + placeMark.country!
        self.placeMark = placeMark
        self.delegate = del
    }
    
    
    @IBAction func addNewCityButton(_ sender: UIButton) {
        delegate?.addNewCity(placeMark: self.placeMark)
    }
    
}
