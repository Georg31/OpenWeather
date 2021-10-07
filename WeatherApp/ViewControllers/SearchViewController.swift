//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by George Digmelashvili on 10/7/21.
//

import UIKit
import CoreLocation

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    private let locationManager = LocationManager()
    private var placeMarks: [CLPlacemark]?
    var delegate: AddNewCity?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        
    }
    

}


extension SearchViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.placeMarks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell", for: indexPath) as! SearchTableViewCell
        cell.setUpCell(placeMark: self.placeMarks![indexPath.row], del: delegate!)
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 3 {
            locationManager.retreiveCoordinates(name: searchText) { data in
                if let place = data{
                    self.placeMarks = place
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
}
