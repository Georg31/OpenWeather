//
//  ViewController.swift
//  WeatherApp
//
//  Created by George Digmelashvili on 10/4/21.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController{
    
    @IBOutlet private weak var locationNameLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var currentTempLabel: UILabel!
    @IBOutlet private weak var lowTempLabel: UILabel!
    @IBOutlet private weak var highTempLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    var weatherModel: WeatherViewModel?
    var weatherCache: WeatherDataViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        setupVC()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(DailyTableViewCell.nib(),
                           forCellReuseIdentifier: DailyTableViewCell.identifier)
        tableView.register(HourlyTableViewCell.nib(),
                           forCellReuseIdentifier: HourlyTableViewCell.identifier)
        tableView.showsVerticalScrollIndicator = false
    }
    
    private func setupVC(){
        if let weather = weatherModel {
            self.locationNameLabel.text = weather.cityName
            self.currentTempLabel.text = weather.currentTemp
            self.descriptionLabel.text = weather.currentDescription
            self.lowTempLabel.text = weather.currentMin
            self.highTempLabel.text = weather.currentMax
            self.tableView.reloadData()
        } else if let weather = weatherCache{
            self.locationNameLabel.text = weather.cityName
            self.currentTempLabel.text = weather.currentTemp
            self.descriptionLabel.text = weather.currentDescription
            self.lowTempLabel.text = weather.currentMin
            self.highTempLabel.text = weather.currentMax
            self.tableView.reloadData()
        }
    }
    
    
}



extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return WeatherTableViewSection.numberOfSection
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = WeatherTableViewSection(sectionIndex: section) else { return 0 }
        
        switch section {
        case .hourly:
            return 1
        case .daily:
            return 7

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = WeatherTableViewSection(sectionIndex: indexPath.section) else { return UITableViewCell() }
        
        switch section {
        case .hourly:
            let cell = tableView.dequeueReusableCell(withIdentifier: HourlyTableViewCell.identifier, for: indexPath) as! HourlyTableViewCell
            if let weatherModel = weatherModel{
                cell.configure(model: weatherModel)
            } else if let weatherModel = weatherCache{
                cell.configure(model: weatherModel)
            }
            return cell
            
        case .daily:
            let cell = tableView.dequeueReusableCell(withIdentifier: DailyTableViewCell.identifier, for: indexPath) as! DailyTableViewCell
            if let daily = self.weatherModel?.dailyAtIndex(indexPath.row){
                cell.configure(model: daily)
            }else if let daily = self.weatherCache?.dailyAtIndex(indexPath.row){
                cell.configure(model: daily)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = WeatherTableViewSection(sectionIndex: indexPath.section) else { return CGFloat() }
        switch section {
        case .hourly:
            return section.cellHeight
        case .daily:
            return section.cellHeight
        }
    }
    
}




//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        var visibleRect = CGRect()
//        visibleRect.origin = collectionView.contentOffset
//        visibleRect.size = collectionView.bounds.size
//        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
//        guard let indexPath = collectionView.indexPathForItem(at: visiblePoint) else { return }
//        self.pageControl.currentPage = indexPath.row
//    }

