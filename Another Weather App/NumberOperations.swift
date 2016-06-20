//
//  DateOperations.swift
//  Another Weather App
//
//  Created by Adam Szmajdzinski on 01.05.2016.
//  Copyright © 2016 szmajdzinski. All rights reserved.
//

import Foundation

func timeStringFromUnixTime(unixTime: Double, format: String = "E yyyy MM dd hh:mm a") -> String {
    let date = NSDate(timeIntervalSince1970: unixTime)
    let dateFormatter = NSDateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.stringFromDate(date)
}

func formatTemp(temp: String) -> String {
    if UserSettings.instance.tempUnit == "metric" {
        return "\(temp) °C"
    } else if UserSettings.instance.tempUnit == "imperial" {
        return "\(temp) F"
    } else {
        return ""
    }
}