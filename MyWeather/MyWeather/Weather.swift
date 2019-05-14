//
//  Weather.swift
//  MyWeather
//
//  Created by Techninier on 12/05/2019.
//  Copyright © 2019 byProgrammers. All rights reserved.
//

import Foundation

struct Weather {
    
    var title: String
    var weather_state_name: String
    var the_temp: Double
    var weather_state_abbr: String
    
    init(json: [String: AnyObject]) {
        self.title = json["title"] as? String ?? ""
        
        if let con_weather = json["consolidated_weather"] as? [[String: AnyObject]] {
            if con_weather.count > 0 {
                let weather = con_weather[0]
                
                self.weather_state_name = weather["weather_state_name"] as? String ?? ""
                self.weather_state_abbr = weather["weather_state_abbr"] as? String ?? ""
                self.the_temp = weather["the_temp"] as? Double ?? 0.0
            } else {
                self.weather_state_name = ""
                self.the_temp = 0.0
                self.weather_state_abbr = ""
            }
        } else {
            self.weather_state_name = ""
            self.the_temp = 0.0
            self.weather_state_abbr = ""
        }
    }
    
}
