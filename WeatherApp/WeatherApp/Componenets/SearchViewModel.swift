//
//  SearchViewModel.swift
//  WeatherApp
//
//  Created by John Le on 11/26/24.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var locations: [SearchLocation] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    private let apiKey = "4a53c8537ec946bfb4852338242211"
    
    private let defaultLocations: [SearchLocation] = [
            SearchLocation(id: 1, name: "New York", region: "New York", country: "United States", lat: 40.7128, lon: -74.0060, url: ""),
            SearchLocation(id: 2, name: "London", region: "Greater London", country: "United Kingdom", lat: 51.5074, lon: -0.1278, url: ""),
            SearchLocation(id: 3, name: "Tokyo", region: "Tokyo", country: "Japan", lat: 35.6895, lon: 139.6917, url: ""),
    ]

    init() {
        locations = defaultLocations
        $searchText
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] newValue in
                self?.fetchLocations(query: newValue)
            }
            .store(in: &cancellables)
    }

    func fetchLocations(query: String) {
        // If the query is empty, show default locations
        guard !query.isEmpty else {
            locations = defaultLocations
            return
        }

        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.weatherapi.com/v1/search.json?key=\(apiKey)&q=\(encodedQuery)") else {
            print("Invalid URL or query")
            return
        }

        isLoading = true
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [SearchLocation].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.locations = []
                case .finished:
                    self?.errorMessage = nil
                }
            }, receiveValue: { [weak self] locations in
                self?.locations = locations
            })
            .store(in: &cancellables)
    }
}
