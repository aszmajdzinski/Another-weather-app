//
//  City.swift
//  Another Weather App
//
//  Created by Adam Szmajdzinski on 01.05.2016.
//  Copyright © 2016 szmajdzinski. All rights reserved.
//

import Foundation

class City: NSObject, NSCoding {
    private var _name: String!
    private var _id: Int!
    
    var name: String {
        return _name
    }
    
    var id: Int {
        get {
            return _id
        }
        set(value) {
            _id = value
        }

    }
    
    init(cityName: String, cityId: Int) {
        _name = cityName
        _id = cityId
    }
    
    init(cityName: String) {
        _name = cityName
        _id = 0
    }
    
    override init() {
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init()
        self._name = aDecoder.decodeObjectForKey("name") as? String
        self._id = aDecoder.decodeObjectForKey("id") as? Int
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self._name, forKey: "name")
        aCoder.encodeObject(self.id, forKey: "id")
    }
}