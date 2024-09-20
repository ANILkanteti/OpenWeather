//
//  WeatherErrors.swift
//  OpenWeather
//
//  Created by Anil Kumar on 8/19/24.
//

import Foundation

enum WeatherError: Error, LocalizedError {
    case invalidURL
    case serverError
    case dataDecodingError
    case locationError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return Constants.ErrorMessages.badURL
        case .serverError:
            return Constants.ErrorMessages.serverError
        case .dataDecodingError:
            return "Failed to decode weather data."
        case .locationError(let description):
            return description
        }
    }
}

