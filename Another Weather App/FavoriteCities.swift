//
//  FavoriteCities.swift
//  Another Weather App
//
//  Created by Adam Szmajdzinski on 04.05.2016.
//  Copyright © 2016 szmajdzinski. All rights reserved.
//

import Foundation

class FavoriteCities {
    static let instance = FavoriteCities()
    
    private let KEY_CITIES = "cities"
    private let CHOSEN_CITY_KEY = "chosen_city"
    private var _list = [City]()
    private var _chosenCity: City!
    
    var list: [City] {
        return _list
    }
    
    var chosenCity: City {
        get {
            return _chosenCity
        }
        set(value) {
            _chosenCity = value
        }
    }
    
    init() {
        _chosenCity = City(cityName: "London", cityId: 2643743)
    }
    
    
    func saveFavoriteCities () {
        let citiesData = NSKeyedArchiver.archivedDataWithRootObject(_list)
        let chosenCityData = NSKeyedArchiver.archivedDataWithRootObject(_chosenCity)
        NSUserDefaults.standardUserDefaults().setObject(chosenCityData, forKey: CHOSEN_CITY_KEY)
        NSUserDefaults.standardUserDefaults().setObject(citiesData, forKey: KEY_CITIES)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func loadFavoriteCities() {
        if let citiesListData = NSUserDefaults.standardUserDefaults().objectForKey(KEY_CITIES) as? NSData {
            if let citiesArray = NSKeyedUnarchiver.unarchiveObjectWithData(citiesListData) as? [City] {
                _list = citiesArray
            }
        }
        if let chosenCityData = NSUserDefaults.standardUserDefaults().objectForKey(CHOSEN_CITY_KEY) as? NSData {
            if let city = NSKeyedUnarchiver.unarchiveObjectWithData(chosenCityData) as? City {
                _chosenCity = city
            }
        }
        NSNotificationCenter.defaultCenter().postNotification(NSNotification(name: "citiesLoaded", object: nil))
    }
    
    func addCity(city: City) {
        if !_list.contains(city) {
            _list.append(city)
            saveFavoriteCities()
        }
    }
    
    func removeCity(index: Int) {
        if _list.count > index {
            _list.removeAtIndex(index)
            saveFavoriteCities()
            loadFavoriteCities()
        }
    }
   
}