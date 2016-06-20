//
//  UserSettings.swift
//  Another Weather App
//
//  Created by Adam Szmajdzinski on 18.06.2016.
//  Copyright © 2016 szmajdzinski. All rights reserved.
//

import Foundation

class UserSettings {
    static let instance = UserSettings()
    
    private let KEY_UNITS = "units"
    
    private var _tempUnit = "imperial"
    var tempUnit: String {
        return _tempUnit
    }
    
    init() {
        loadSettings()
    }
    
    func saveSettings() {
        let unitData = NSKeyedArchiver.archivedDataWithRootObject(tempUnit)
        NSUserDefaults.standardUserDefaults().setObject(unitData, forKey: KEY_UNITS)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func loadSettings() {
        if let unitData = NSUserDefaults.standardUserDefaults().objectForKey(KEY_UNITS) as? NSData {
            if let unit = NSKeyedUnarchiver.unarchiveObjectWithData(unitData) as? String {
                _tempUnit = unit
            }
        }
    }
    
    private func setUnit(unitName: String!) {
        _tempUnit = unitName
        saveSettings()
    }
    
    func changeUnit() {
        if _tempUnit == "metric" {
            setUnit("imperial")
        } else {
            setUnit("metric")
        }
    }
    
}