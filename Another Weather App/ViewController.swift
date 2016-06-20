//
//  ViewController.swift
//  Another Weather App
//
//  Created by Adam Szmajdzinski on 01.05.2016.
//  Copyright © 2016 szmajdzinski. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {
    
    let DIM_VALUE: CGFloat = 0.3
    
    @IBOutlet weak var cityNameLbl: UILabel!
    @IBOutlet weak var dayLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var sunriseImg: UIImageView!
    @IBOutlet weak var sunriseLbl: UILabel!
    @IBOutlet weak var sunsetImg: UIImageView!
    @IBOutlet weak var sunsetLbl: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var weatherLbl: UILabel!
    @IBOutlet weak var windIcon: UIImageView!
    @IBOutlet weak var tempBtn: UIButton!
    @IBOutlet weak var windLbl: UILabel!
    @IBOutlet weak var cloudsIcon: UIImageView!
    @IBOutlet weak var bgImg: UIImageView!
    @IBOutlet weak var blurredBgImg: UIImageView!
    @IBOutlet weak var cloudsLbl: UILabel!
    @IBOutlet weak var rainIcon: UIImageView!
    @IBOutlet weak var rainLbl: UILabel!
    @IBOutlet weak var snowIcon: UIImageView!
    @IBOutlet weak var snowLbl: UILabel!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var favBtn: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var warningLbl: UILabel!
    @IBOutlet weak var refreshBtn: UIButton!
    @IBOutlet weak var sunTempStackView: UIStackView!
    @IBOutlet weak var detailsStackView: UIStackView!
    @IBOutlet weak var mainStackView: UIStackView!
    
    var weather: WeatherData!
    var weatherIndex = 0
    var city: City!
    
    func blurBackground() {
        super.awakeFromNib()
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = blurredBgImg.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        blurEffectView.layer.cornerRadius = 10
        blurEffectView.layer.masksToBounds = true
        blurredBgImg.addSubview(blurEffectView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        blurBackground()
    }
    
    override func viewDidAppear(animated: Bool) {
        FavoriteCities.instance.loadFavoriteCities()
        city = FavoriteCities.instance.chosenCity
        loadData()
    }
    
    func loadData() {
        weather = WeatherData(city: city)
        weather.downloadWeatherData { () -> () in
            self.slider.value = 0.0
            self.weatherIndex = 0
            if self.weather.dataDownloaded {
                self.showConnectionWarning(false)
                self.updateView()
            } else {
                self.showConnectionWarning(true)
            }
            if let chosenCity = self.weather.getCityData() {
                FavoriteCities.instance.chosenCity = chosenCity
                FavoriteCities.instance.saveFavoriteCities()
            }
        }
    }
    
    func updateView() {
        if let weatherState = weather?.weatherArray[weatherIndex] {
            assignBackgroundImg(weatherState)
            cityNameLbl.text = city.name
            dayLbl.text = timeStringFromUnixTime(weatherState.time, format: "E")
            dateLbl.text = timeStringFromUnixTime(weatherState.time, format: "MM/dd")
            timeLbl.text = timeStringFromUnixTime(weatherState.time, format: "hh:mm a")
            tempBtn.setTitle(formatTemp(weatherState.temp), forState: .Normal)
            weatherIcon.image = UIImage(named: weatherState.icon)
            weatherLbl.text = weatherState.group
            
            if let timeDouble = Double(weatherState.sunrise) {
                sunriseImg.alpha = 1.0
                sunriseLbl.alpha = 1.0
                sunriseLbl.text = timeStringFromUnixTime(timeDouble, format: "hh:mm a")
            } else {
                sunriseImg.alpha = DIM_VALUE
                sunriseLbl.alpha = DIM_VALUE
                sunriseLbl.text = "--:-- --"
            }
            
            if let timeDouble = Double(weatherState.sunset) {
                sunsetImg.alpha = 1.0
                sunsetLbl.alpha = 1.0
                sunsetLbl.text = timeStringFromUnixTime(timeDouble, format: "hh:mm a")
            } else {
                sunsetImg.alpha = DIM_VALUE
                sunsetLbl.alpha = DIM_VALUE
                sunsetLbl.text = "--:-- --"
            }
            
            if weatherState.cloudiness != "" {
                cloudsIcon.alpha = 1.0
                cloudsLbl.alpha = 1.0
                cloudsLbl.text = "\(weatherState.cloudiness)"
            } else {
                cloudsIcon.alpha = DIM_VALUE
                cloudsLbl.alpha = DIM_VALUE
                cloudsLbl.text = "--"
            }
            
            if weatherState.windSpeed != "" {
                windIcon.alpha = 1.0
                windLbl.alpha = 1.0
                windLbl.text = "\(weatherState.windSpeed) m/s"
            } else {
                windIcon.alpha = DIM_VALUE
                windLbl.alpha = DIM_VALUE
                
                windLbl.text = "-- m/s"
            }
        }
    }
    
    func assignBackgroundImg(weather: WeatherState) {
        if weather.isDay() {
            if weather.group == "Clear" {
                changeBackground(UIImage(named: "Clear")!)
            } else {
                changeBackground(UIImage(named: "Clouds")!)
            }
        } else if weather.isNight() {
            changeBackground(UIImage(named: "ClearNight")!)
        } else {
            changeBackground(UIImage(named: "Clear")!)
        }
    }
    
    func changeBackground(image: UIImage) {
        let transition = CATransition()
        transition.type = kCATransitionFade
        bgImg.layer.addAnimation(transition, forKey: kCATransition)
        bgImg.image = image
    }
    
    func showSearchBar(show: Bool) {
        cityNameLbl.hidden = show
        searchBtn.hidden = show
        addBtn.hidden = show
        favBtn.hidden = show
        searchBar.hidden = !show
    }
    
    func showConnectionWarning(display: Bool) {
        warningLbl.hidden = !display
        refreshBtn.hidden = !display
        cityNameLbl.hidden = display
        dayLbl.hidden = display
        timeLbl.hidden = display
        dateLbl.hidden = display
        searchBtn.hidden = display
        addBtn.hidden = display
        slider.hidden = display
        detailsStackView.hidden = display
        mainStackView.hidden = display
        sunTempStackView.hidden = display
        
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        let value = sender.value
        
        let weatherStatesCount = weather.weatherArray.count
        let newWeatherIndex = (Int(round(value * Float(weatherStatesCount - 1))))
        let step = 1.0 / Float(weatherStatesCount-1)
        
        sender.value = round(value/step) * step
       
        if  weatherIndex != newWeatherIndex {
            weatherIndex = newWeatherIndex
            updateView()
        }
        
    }
    
    @IBAction func searchBtnPressed(sender: AnyObject) {
        showSearchBar(true)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        print(searchBar.text)
        if let searchText = searchBar.text {
            city = City(cityName: searchText)
            loadData()
        }
        showSearchBar(false)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        showSearchBar(false)
    }
    
    @IBAction func addBtnPressed(sender: AnyObject) {
        if let city = weather.getCityData() {
            FavoriteCities.instance.addCity(city)
        }
    }
    
    @IBAction func tempBtnPressed(sender: UIButton) {
        UserSettings.instance.changeUnit()
        loadData()
    }
    
    @IBAction func refreshBtnPressed(sender: AnyObject) {
        loadData()
    }
    
}

