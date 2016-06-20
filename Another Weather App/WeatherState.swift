//
//  WeatherState.swift
//  Another Weather App
//
//  Created by Adam Szmajdzinski on 01.05.2016.
//  Copyright © 2016 szmajdzinski. All rights reserved.
//

import Foundation

class WeatherState {
    private var _time: Double!
    private var _group: String!
    private var _desc: String!
    private var _icon: String!
    private var _temp: String!
    private var _windSpeed: String!
    private var _windDeg: String!
    private var _cloudiness: String!
    private var _snow: String!
    private var _sunrise: String!
    private var _sunset: String!
    
    var time: Double {
        return _time
    }
    
    var group: String {
        get {
            if _group == nil {
                _group = ""
            }
            return _group
        }
        set(value) {
            _group = value
        }
    }
    
    var desc: String {
        get {
            if _desc == nil {
                _desc = ""
            }
            return _desc
        }
        set(value) {
            _desc = value
        }
    }
    
    var icon: String {
        get {
            if _icon == nil {
                _icon = ""
            }
            return _icon
        }
        set(value) {
            _icon = value
        }
    }
    
    var temp: String {
        get {
            if _temp == nil {
                _temp = ""
            }
            return _temp
        }
        set(value) {
            _temp = value
        }
    }
    
    var windSpeed: String {
        get {
            if _windSpeed == nil {
                _windSpeed = ""
            }
            return _windSpeed
        }
        set(value) {
            _windSpeed = value
        }
    }
    
    var windDeg: String {
        get {
            if _windDeg == nil {
                _windDeg = ""
            }
            return _windDeg
        }
        set(value) {
            _windDeg = value
        }
    }
    
    var cloudiness: String {
        get {
            if _cloudiness == nil {
                _cloudiness = ""
            }
            return _cloudiness
        }
        set(value) {
            _cloudiness = value
        }
    }
    
    var snow: String {
        get {
            if _snow == nil {
                _snow = ""
            }
            return _snow
        }
        set(value) {
            _snow = value
        }
    }
    
    var sunrise: String {
        get {
            if _sunrise == nil {
                _sunrise = ""
            }
            return _sunrise
        }
        set(value) {
            _sunrise = value
        }
    }
    
    var sunset: String {
        get {
            if _sunset == nil {
                _sunset = ""
            }
            return _sunset
        }
        set(value) {
            _sunset = value
        }
    }
    
    func isDay() -> Bool {
        if icon.containsString("d") {
            return true
        }
        return false
    }
    
    func isNight() -> Bool {
        if icon.containsString("n") {
            return true
        }
        return false
    }
    
    init(time: Double) {
        _time = time
    }
}