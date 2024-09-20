//
//  MockWeatherService.swift
//  OpenWeatherTests
//
//  Created by Anil Kumar on 8/19/24.
//

import Combine
import Foundation
@testable import OpenWeather

class MockWeatherService: WeatherService {
    var result: Result<Weather, Error>?
    
    override func fetchWeather(for city: String) -> AnyPublisher<Weather, Error> {
        if let result = result {
            return result.publisher.eraseToAnyPublisher()
        } else {
            return Fail(error: URLError(.badServerResponse)).eraseToAnyPublisher()
        }
    }
}
