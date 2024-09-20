//
//  WeatherModel.swift
//  OpenWeather
//
//  Created by Anil Kumar on 8/19/24.
//

import Foundation

struct Weather: Decodable {
    let name: String
    let main: Main
    let weather: [WeatherCondition]
}

struct Main: Decodable {
    let temp: Double
}

struct WeatherCondition: Decodable {
    let icon: String
}
