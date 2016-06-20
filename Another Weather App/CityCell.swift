//
//  CityCell.swift
//  Another Weather App
//
//  Created by Adam Szmajdzinski on 24.05.2016.
//  Copyright © 2016 szmajdzinski. All rights reserved.
//

import UIKit

class CityCell: UITableViewCell {

    @IBOutlet weak var cityNameLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var iconImg: UIImageView!
    @IBOutlet weak var removeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.backgroundColor = nil
    }
    
    func configureCell(city: City) {
        cityNameLbl.text = city.name
    }
    
    func configureCell(city: City, weather: WeatherState, index: Int!) {
        cityNameLbl.text = city.name
        tempLbl.text = formatTemp(weather.temp)
        iconImg.image = UIImage(named: weather.icon)
        removeButton.tag = index
    }

    @IBAction func removeButtonPressed(sender: UIButton) {
        FavoriteCities.instance.removeCity(sender.tag)
        
    }

}
