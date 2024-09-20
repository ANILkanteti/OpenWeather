//
//  EndPoints.swift
//  OpenWeather
//
//  Created by Anil Kumar on 8/19/24.
//

import Foundation

enum Endpoint {
    
    case weather(city: String)
    
    var url: URL? {
        switch self {
        case .weather(let city):
            return URL(string: "\(Constants.API.baseURL)weather?q=\(city)&appid=\(Constants.API.apiKey)&units=metric")
        }
    }
}
