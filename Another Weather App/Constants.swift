//
//  Constants.swift
//  Another Weather App
//
//  Created by Adam Szmajdzinski on 01.05.2016.
//  Copyright © 2016 szmajdzinski. All rights reserved.
//

import Foundation

let API_KEY = "9688b3b416bf37293a3d3713768e4330"
let URL_BASE = "http://api.openweathermap.org/data/2.5/"
let URL_CURRENT = "\(URL_BASE)weather?appid=\(API_KEY)"
let URL_FORECAST = "\(URL_BASE)forecast?appid=\(API_KEY)"
let URL_LIST = "\(URL_BASE)group?appid=\(API_KEY)"

typealias DownloadComplete = () -> ()