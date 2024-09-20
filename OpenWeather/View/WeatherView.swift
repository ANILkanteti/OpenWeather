//
//  ContentView.swift
//  OpenWeather
//
//  Created by Anil Kumar on 8/19/24.
//

import SwiftUI

struct WeatherView: View {
    
    @StateObject private var viewModel = WeatherViewModel()
    @StateObject private var locationManager = LocationManager()
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        VStack {
            // Adjust the layout based on size class (e.g., show fields side by side in landscape)
            if horizontalSizeClass == .compact && verticalSizeClass == .regular {
                // Portrait Layout
                portraitLayout
            } else {
                // Landscape Layout
                landscapeLayout
            }
        }
        .padding()
        .edgesIgnoringSafeArea(.all) // Handle safe areas
        .onAppear {
            if locationManager.locationPermissionGranted {
                locationManager.requestLocation()
            } else {
                viewModel.fetchWeather() // Fetch weather using last searched city
            }
        }
        .onChange(of: locationManager.city) {
            if let city = locationManager.city {
                viewModel.city = city
                viewModel.fetchWeather()
            }
        }
    }
    
    private var portraitLayout: some View {
        VStack {
            weatherInputView
            weatherDisplayView
        }
    }
    
    private var landscapeLayout: some View {
        HStack {
            weatherInputView
            weatherDisplayView
        }
    }
    
    private var weatherInputView: some View {
        VStack {
            TextField("Enter City", text: $viewModel.city, onCommit: {
                viewModel.fetchWeather()
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
        }
    }
    
    private var weatherDisplayView: some View {
        VStack {
            if !viewModel.weatherIcon.isEmpty {
                AsyncImage(url: URL(string: "\(Constants.WeatherIcons.baseIconURL)\(viewModel.weatherIcon)@2x.png")) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                } placeholder: {
                    ProgressView()
                }
            }
            
            Text(viewModel.temperature)
                .font(.largeTitle)
                .padding()
        }
    }
}
