//
//  WeatherService.swift
//  OpenWeather
//
//  Created by Anil Kumar on 8/19/24.
//

import Foundation
import Combine

class WeatherService {
    
    func fetchWeather(for city: String) -> AnyPublisher<Weather, Error> {
        guard let url = Endpoint.weather(city: city).url else {
            return Fail(error: WeatherError.invalidURL).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw WeatherError.serverError
                }
                return data
            }
            .decode(type: Weather.self, decoder: JSONDecoder())
            .mapError { error in
                if error is DecodingError {
                    return WeatherError.dataDecodingError
                } else {
                    return error
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
