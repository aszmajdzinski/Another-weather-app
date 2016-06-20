//
//  WeatherData.swift
//  Another Weather App
//
//  Created by Adam Szmajdzinski on 01.05.2016.
//  Copyright © 2016 szmajdzinski. All rights reserved.
//

import Foundation
import Alamofire

class WeatherData {
    private var _weatherArray = [WeatherState]()
    private var _city: City!
    private var _weatherUrlCurrent: NSURL!
    private var _weatherUrlForecast: NSURL!
    private var _weatherUrlList: NSURL!
    private var _weatherCityDict = [Int: WeatherState]()
    private var _dataDownloaded = false
    
    private let unit = "units=" + UserSettings.instance.tempUnit
    
    var dataDownloaded: Bool {
        return _dataDownloaded
    }
    
    var weatherArray: [WeatherState] {
        return _weatherArray
    }
    
    var weatherCityDict:[Int: WeatherState] {
        return _weatherCityDict
    }
    
    init(city: City) {
        _city = city
        if city.id == 0 {
            let cityName = city.name.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            _weatherUrlCurrent = NSURL(string: "\(URL_CURRENT)&q=\(cityName!)&\(unit)")
            _weatherUrlForecast = NSURL(string: "\(URL_FORECAST)&q=\(cityName!)&\(unit)")
        } else {
            _weatherUrlCurrent = NSURL(string: "\(URL_CURRENT)&id=\(city.id)&\(unit)")
            _weatherUrlForecast = NSURL(string: "\(URL_FORECAST)&id=\(city.id)&\(unit)")
        }
    }
  
    init(citiesList: [Int]) {
        var url = "\(URL_LIST)&\(unit)&id="
        for id in citiesList {
            url = url + "\(id),"
        }
        _weatherUrlList = NSURL(string: url)
        _city = City(cityName: "", cityId: 0)
    }
    
    func downloadWeatherData(completed: DownloadComplete) {
        print(_weatherUrlCurrent)
        Alamofire.request(.GET, _weatherUrlCurrent).responseJSON { response in
            let result = response.result
            if let dict = result.value as? Dictionary<String,AnyObject> {
                if let weatherState = self.parseResult(dict) {
                    self._weatherArray.append(weatherState)
                }
            }
        }
        
        Alamofire.request(.GET, _weatherUrlForecast).responseJSON { response in
            let result = response.result
            if let dict = result.value as? Dictionary<String,AnyObject> {
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] where list.count > 0 {
                    for element in list {
                        if let weatherState = self.parseResult(element) {
                            self._weatherArray.append(weatherState)
                        }
                    }
                }
            }
            completed()
        }
    }
    
    func downloadWeatherDataForList(completed: DownloadComplete) {
        Alamofire.request(.GET, _weatherUrlList).responseJSON { response in
            let result = response.result
            if let dict = result.value as? Dictionary<String,AnyObject> {
                if let list = dict["list"] as? [Dictionary<String, AnyObject>] where list.count > 0 {
                    for cityWeather in list {
                        if let weatherState = self.parseResult(cityWeather) {
                            if let cityId = cityWeather["id"] as? Int {
                                self._weatherCityDict[cityId] = weatherState
                            }
                        }
                    }
                }
            }
            completed()
        }
    }
    
    func parseResult(dict: Dictionary<String, AnyObject>) -> WeatherState? {
       if let time = dict["dt"] as? Double {
            let weatherState = WeatherState(time: time)
            _dataDownloaded = true
            
            if let main = dict["main"] as? Dictionary<String, AnyObject> {
                if let temp = main["temp"] as? Double {
                    weatherState.temp = "\(Int(round(temp)))"
                }
            }
        
            if let weather = dict["weather"] as? [Dictionary<String, AnyObject>] where weather.count > 0{
                if let group = weather[0]["main"] as? String {
                    weatherState.group = "\(group)"
                }
                if let desc = weather[0]["description"] as? String {
                    weatherState.desc = "\(desc)"
                }
                if let icon = weather[0]["icon"] as? String {
                    weatherState.icon = "\(icon)"
                }
            }
        
            if let wind = dict["wind"] as? Dictionary<String, AnyObject> {
                if let windSpeed = wind["speed"] as? Double {
                    weatherState.windSpeed = "\(Int(round(windSpeed)))"
                }
                if let windDeg = wind["deg"] as? Double {
                    weatherState.windDeg = "\(windDeg)"
                }
            }
        
            if let clouds = dict["clouds"] as? Dictionary<String, AnyObject> {
                if let all = clouds["all"] as? Int {
                    weatherState.cloudiness = "\(all)"
                }
            }
        
            if let sys = dict["sys"] as? Dictionary<String, AnyObject> {
                if let sunrise = sys["sunrise"] {
                    weatherState.sunrise = "\(sunrise)"
                }
                if let sunset = sys["sunset"] {
                    weatherState.sunset = "\(sunset)"
                }
            }
        
            if let cityId = dict["id"] as? Int {
                if _city.id == 0 {
                    _city.id = cityId
                }
            }
            return weatherState
        }
        return nil
    }
    
    func getCityData() -> City? {
        if _city.name != "" && _city.id != 0 {
            return City(cityName: _city.name, cityId: _city.id)
        }
        
        return nil
    }
}