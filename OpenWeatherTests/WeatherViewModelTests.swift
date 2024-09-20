//
//  WeatherViewModelTests.swift
//  OpenWeatherTests
//
//  Created by Anil Kumar on 8/19/24.
//

import XCTest
import Combine
@testable import OpenWeather

class WeatherViewModelTests: XCTestCase {
    var viewModel: WeatherViewModel!
    var mockWeatherService: MockWeatherService!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockWeatherService = MockWeatherService()
        viewModel = WeatherViewModel(weatherService: mockWeatherService)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockWeatherService = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchWeatherSuccess() {
        // Arrange
        let weather = Weather(name: "Austin",
                              main: Main(temp: 25.0),
                              weather: [WeatherCondition(icon: "01d")])
        mockWeatherService.result = .success(weather)

        let expectation = XCTestExpectation(description: "Weather fetched successfully")

        // Act
        viewModel.fetchWeather()

        // Assert
        viewModel.$temperature
            .sink { temperature in
                XCTAssertEqual(temperature, "25.0°C")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.$weatherIcon
            .sink { icon in
                XCTAssertEqual(icon, "01d")
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func testFetchWeatherFailure() {
        // Arrange
        mockWeatherService.result = .failure(WeatherError.serverError)

        let expectation = XCTestExpectation(description: "Weather fetch failed")

        // Act
        viewModel.fetchWeather()

        // Assert
        viewModel.$errorMessage
            .sink { errorMessage in
                XCTAssertEqual(errorMessage, Constants.ErrorMessages.serverError)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 1.0)
    }

    func testLoadLastSearchedCity() {
        // Arrange
        UserDefaults.standard.set("New York", forKey: Constants.lastSearchedCity)
        
        // Act
        viewModel.loadLastSearchedCity()

        // Assert
        XCTAssertEqual(viewModel.city, "New York")
    }

    func testSaveLastSearchedCity() {
        // Arrange
        viewModel.city = "Los Angeles"
        
        // Act
        viewModel.saveLastSearchedCity()

        // Assert
        XCTAssertEqual(UserDefaults.standard.string(forKey: Constants.lastSearchedCity), "Los Angeles")
    }
    
    func testInitialCityLoad() {
        // Arrange
        UserDefaults.standard.removeObject(forKey: Constants.lastSearchedCity)
        
        // Act
        let newViewModel = WeatherViewModel(weatherService: mockWeatherService)
        
        // Assert
        XCTAssertEqual(newViewModel.city, "Austin") // Default city
    }
}
