//
//  SearchView.swift
//  WeatherApp
//
//  Created by John Le on 11/26/24.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    var weatherManager = WeatherManager()
    @State var weather: CurrentWeatherResponse?
    @State private var navigateToWeatherView = false

    var body: some View {
        VStack {
            // Search Bar
            TextField("", text: $viewModel.searchText, prompt: Text("Search for a city").foregroundColor(.white))
                .padding(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white, lineWidth: 2)
                )
                .foregroundColor(.white)
                .padding(.horizontal)
                .padding(.top, 20)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
            
            if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            }
            
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .padding()
            }
            
            // List of Locations
            if !$viewModel.locations.isEmpty {
                NavigationStack {
                    List(viewModel.locations) {
                        location in NavigationLink(destination: {
                            if let weather = weather {
                                WeatherView(weather: weather)
                            } else {
                                LoadingView()
                            }
                        }, label: {
                            VStack(alignment: .leading) {
                                Text(location.name)
                                    .font(.headline)
                                Text("\(location.region), \(location.country)")
                                    .font(.subheadline)
                            }
                            .padding()
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                        })
                        .onTapGesture {
                            Task {
                                await loadWeather(for: location.name)
                            }
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                    }
                    .listStyle(PlainListStyle())
                    .padding(.top, 10)
                }
            } else{
                Spacer()
            }}
        .background(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    
        private func loadWeather(for city: String) async {
            do {
                weather = try await weatherManager.getForecast(name: city)
                navigateToWeatherView = true
            } catch {
                print("Error loading weather: \(error)")
            }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

