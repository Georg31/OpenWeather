//
//  PageController.swift
//  WeatherApp
//
//  Created by George Digmelashvili on 10/5/21.
//

import UIKit
import CoreLocation

class PageController: UIPageViewController, LocationServiceDelegate, AddNewCity {
    
    
    private let locationManager = LocationManager()
    private var pageControl = UIPageControl()
    private var imageView: UIImageView?
    private var location: CLLocationCoordinate2D?
    var data: WeatherDataListViewModel?
    var modelData: WeatherViewModel?
    
    lazy var viewControllerList: [UIViewController] = {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherViewController")
        return [vc]
    }()
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
//    var menuButton: UIButton = {
//        let btn = UIButton(frame: CGRect(x: 20, y: UIScreen.main.bounds.maxY - 45, width: 40, height: 40))
//        btn.setImage(UIImage(systemName: "gear"), for: .normal)
//        btn.tintColor = .white
//        btn.addTarget(self, action: #selector(menuButtonClick), for: .touchUpInside)
//        return btn
//    }()
    
    var newCityButton: UIButton = {
        let btn = UIButton(frame: CGRect(x: UIScreen.main.bounds.maxX - 55, y: UIScreen.main.bounds.maxY - 45, width: 40, height: 40))
        btn.setImage(UIImage(systemName: "line.3.horizontal"), for: .normal)
        btn.tintColor = .white
        btn.addTarget(self, action: #selector(newCityButtonClick), for: .touchUpInside)
        return btn
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.handleUserLocation()
        configurePageControl()
        config()
    }
    
    
    @objc func menuButtonClick(_ sender: UIButton){
        
    }
    
    @objc func newCityButtonClick(_ sender: UIButton){
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchViewController") as! SearchViewController
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
    }
    
    func addNewCity(placeMark: CLPlacemark) {
        self.presentedViewController?.dismiss(animated: true)
        self.location = placeMark.location?.coordinate
        ApiCall.shared.fetchWeather(cordinates: CLLocationCoordinate2D(latitude: location!.latitude, longitude: location!.longitude)) { [self] weather in
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
            vc.weatherModel = weather
            Dbase.shared.saveMovie(weather)
            self.viewControllerList.append(vc)
            self.pageControl.numberOfPages = self.viewControllerList.count
            self.pageControl.currentPage = self.viewControllerList.count
            self.setViewControllers([vc], direction: .forward, animated: true)
        }
    }
    
    
    func tracingLocation(currentLocation: CLLocationCoordinate2D) {
        location = currentLocation
        //print(location)
        setupVCList()
        
    }
    
    private func setupVCList(){
        
        if !Network.reachability.isReachable{
            setWeatherCache()
            pageControl.setIndicatorImage(UIImage(systemName: "location.fill"), forPage: 0)
            return
        }
        if let firstVC = viewControllerList.first{
            ApiCall.shared.fetchWeather(cordinates: location!) { weather in
                self.modelData = weather
                self.modelData?.isMainLocation = true
                Dbase.shared.saveMovie(self.modelData!)
                (firstVC as! WeatherViewController).weatherModel = weather
                self.setViewControllers([firstVC], direction: .forward, animated: true)
                self.checkData()
                
            }
        }
        
    }
    
    private func setWeatherCache(){
        self.data = Dbase.shared.retrieveData()
        guard let data = data?.data else {return}
        self.viewControllerList.removeAll()
        if let weather = data.first(where: {$0.isMainLocation == true}){
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
            vc.weatherCache = weather
            self.setViewControllers([vc], direction: .forward, animated: true, completion: nil)
            self.viewControllerList.append(vc)
        }
        for weather in data{
            if weather.isMainLocation{ continue}
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
            vc.weatherCache = weather
            self.viewControllerList.append(vc)
        }
        self.pageControl.numberOfPages = self.viewControllerList.count
    }
    
    private func checkData(){
        self.data = Dbase.shared.retrieveData()
        pageControl.setIndicatorImage(UIImage(systemName: "location.fill"), forPage: 0)
        guard var data = data?.data else{ return}
        self.pageControl.numberOfPages = data.count
        if let ind = data.firstIndex(where: {$0.isMainLocation == true}), data.count > 1{
            data.remove(at: ind)
            for item in data{
                ApiCall.shared.fetchWeather(cordinates: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longtitude)) { [self] weather in
                    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
                    vc.weatherModel = weather
                    self.viewControllerList.append(vc)
                }
            }
        }
    }
    
    private func configurePageControl() {
        
        pageControl = UIPageControl(frame: CGRect(x: 70,y: UIScreen.main.bounds.maxY - 50,width: UIScreen.main.bounds.width - 140, height: 50))
        self.pageControl.isUserInteractionEnabled = false
        self.pageControl.isSelected = false
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = .black
        self.pageControl.pageIndicatorTintColor = .lightGray
        self.pageControl.currentPageIndicatorTintColor = .white
        self.view.addSubview(pageControl)
    }
    
    private func config(){
        //self.view.addSubview(menuButton)
        self.view.addSubview(newCityButton)
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "BackGroundLight")!)
        self.dataSource = self
        self.delegate = self
        self.pageControl.numberOfPages = self.viewControllerList.count
    }
}

extension PageController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.firstIndex(of: viewController) else { return nil}
        let prevIndex = vcIndex - 1
        guard prevIndex >= 0, viewControllerList.count > prevIndex else{ return nil}
        return viewControllerList[prevIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let vcIndex = viewControllerList.firstIndex(of: viewController) else { return nil}
        let nextIndex = vcIndex + 1
        guard viewControllerList.count > nextIndex, viewControllerList.count != nextIndex else { return nil}
        return viewControllerList[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        let pageContentViewController = pageViewController.viewControllers![0]
        self.pageControl.currentPage = viewControllerList.firstIndex(of: pageContentViewController)!
        
    }
    
}

