//
//  HourlyTableViewCell.swift
//  WeatherApp
//
//  Created by George Digmelashvili on 10/5/21.
//

import UIKit

final class HourlyTableViewCell: UITableViewCell, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var weatherModel: WeatherViewModel?
    private var weatherCache: WeatherDataViewModel?
    static var identifier = "HourlyTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "HourlyTableViewCell",
                     bundle: nil)
    }
    
    func configure(model: WeatherViewModel) {
        self.weatherModel = model
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func configure(model: WeatherDataViewModel){
        self.weatherCache = model
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    private func setupCollectionView() {
        collectionView.register(HourlyCollectionViewCell.nib(), forCellWithReuseIdentifier: HourlyCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
    }
    
}


extension HourlyTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyCollectionViewCell.identifier, for: indexPath) as! HourlyCollectionViewCell
        
        if let hour = weatherModel{
            cell.setupCell(hour, index: indexPath.row)
        } else if let hour = weatherCache{
            cell.setupCell(hour, index: indexPath.row)
        }
        return cell
    }
    
}
