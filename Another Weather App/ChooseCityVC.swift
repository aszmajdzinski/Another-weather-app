//
//  ChooseCity.swift
//  Another Weather App
//
//  Created by Adam Szmajdzinski on 24.05.2016.
//  Copyright © 2016 szmajdzinski. All rights reserved.
//

import UIKit

class ChooseCityVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var citiesTable: UITableView!
    
    var weatherList: WeatherData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        citiesTable.delegate = self
        citiesTable.dataSource = self
        citiesTable.backgroundColor = nil
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChooseCityVC.onCitiesLoaded(_:)), name: "citiesLoaded", object: nil)
        loadCells()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let city = FavoriteCities.instance.list[indexPath.row]
        if let cell = tableView.dequeueReusableCellWithIdentifier("CityCellId") as? CityCell {
            if let weather = weatherList.weatherCityDict[city.id] {
                cell.configureCell(city, weather: weather, index: indexPath.row)
            } else {
                cell.configureCell(city)
            }
            
            return cell
        } else {
            let cell = CityCell()
            if let weather = weatherList.weatherCityDict[city.id] {
                cell.configureCell(city, weather: weather, index: indexPath.row)
            } else {
                cell.configureCell(city)
            }
            return cell
        }
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 84.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return FavoriteCities.instance.list.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let city = FavoriteCities.instance.list[indexPath.row]
        FavoriteCities.instance.chosenCity = city
        FavoriteCities.instance.saveFavoriteCities()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadCells() {
        FavoriteCities.instance.loadFavoriteCities()
        var citiesIdList = [Int]()
        for city in FavoriteCities.instance.list {
            citiesIdList.append(city.id)
        }
        
        weatherList = WeatherData(citiesList: citiesIdList)
        weatherList.downloadWeatherDataForList { () -> () in
            self.citiesTable.reloadData()
        }
    }
    
    func onCitiesLoaded(notif: AnyObject) {
        citiesTable.reloadData()
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
