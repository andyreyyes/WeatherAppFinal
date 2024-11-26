//
//  ContentView.swift
//  WeatherApp
//
//  Created by Caleb McKinley on 11/21/24.
//

import SwiftUI

struct ContentView: View {
    // This works when you run the simulation bc it allows
    // you to actually enable your location.
    // It's pretty slow through the simulation so there is a local way to run it. Go to the weather view directly.
    @StateObject var locationManager = LocationManager()
    var weatherManager = WeatherManager()
    @State var weather: CurrentWeatherResponse?
    
    var body: some View {
        VStack {
            if let location = locationManager.location {
                if let weather = weather {
                    WeatherView(weather: weather)
                } else {
                    LoadingView()
                        .task {
                            do {
                                weather = try await weatherManager.getForecast(latitude: location.latitude, longitude: location.longitude)
                            } catch {
                                print("Error getting weather: \(error)")
                            }
                        }
                }
            } else {
                if locationManager.isLoading {
                    LoadingView()
                }
                else {
                    WelcomeView()
                        .environmentObject(locationManager)
                }
            }
        }
        .background(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
