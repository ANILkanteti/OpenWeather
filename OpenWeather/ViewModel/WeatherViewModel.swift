//
//  WeatherViewModel.swift
//  OpenWeather
//
//  Created by Anil Kumar on 8/19/24.
//

import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    @Published var city: String = ""
    @Published var temperature: String = "--"
    @Published var weatherIcon: String = ""
    @Published var errorMessage: String?
    
    private var cancellable: AnyCancellable?
    private let weatherService: WeatherService
    
    init(weatherService: WeatherService = WeatherService()) {
        self.weatherService = weatherService
        loadLastSearchedCity()
    }
    
    func fetchWeather() {
        cancellable = weatherService.fetchWeather(for: city)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
                }
            }, receiveValue: { weather in
                self.temperature = "\(weather.main.temp)°C"
                self.weatherIcon = weather.weather.first?.icon ?? ""
                self.errorMessage = nil // Clear error message on success
            })
    }
    
    func saveLastSearchedCity() {
        UserDefaults.standard.set(city, forKey: Constants.lastSearchedCity)
    }
    
    func loadLastSearchedCity() {
        city = UserDefaults.standard.string(forKey: Constants.lastSearchedCity) ?? "Austin" // Default city
    }
}
