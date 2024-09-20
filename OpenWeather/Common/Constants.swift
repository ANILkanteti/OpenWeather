//
//  Constants.swift
//  OpenWeather
//
//  Created by Anil Kumar on 8/19/24.
//

import Foundation

struct Constants {
    
    static let lastSearchedCity = "lastSearchedCity"
    
    struct API {
        static let baseURL = "https://api.openweathermap.org/data/2.5/"
        static let apiKey = "cb34ffe97f80cfed62e938def6938826"
    }
    
    struct ErrorMessages {
        static let badURL = "The URL provided is invalid."
        static let serverError = "There was an issue communicating with the server."
    }
    
    struct WeatherIcons {
        static let baseIconURL = "https://openweathermap.org/img/wn/"
    }
}
