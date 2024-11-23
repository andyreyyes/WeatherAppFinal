//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Andy Reyes on 11/21/24.
//

import Foundation
import CoreLocation



class WeatherManager {
    
    private let apiKey: String
    init() {
        
        apiKey = "4a53c8537ec946bfb4852338242211"
    }
    
    func getCurrentWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> CurrentWeatherResponse{
        guard let url = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(latitude),\(longitude)&days=1&aqi=no&alerts=no") else {fatalError("Missing URL")}
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            fatalError("Error Fetching data")
        }
        
        let decodedData = try JSONDecoder().decode(CurrentWeatherResponse.self, from: data)
        
        return decodedData
        
    }
    
    func getForecast(location: String, amount_of_days: Int) {
        
    }
    
    func getWeatherHistory(location: String, date: String) {
        
    }
}

struct CurrentWeatherResponse: Decodable {

    struct Location: Decodable {
        var name: String
        var region: String
        var country: String
        var lat: Double
        var lon: Double
        var tz_id: String
        var localtime_epoch: Int
        var localtime: String
    }
    
    struct Condition: Decodable {
        var text: String
        var icon: String
        var code: Int
    }
    
    
    struct Current: Decodable {
        var last_updated_epoch: Int
        var last_updated: String
        var temp_c: Double
        var temp_f: Double
        let is_day: Int
        let condition: Condition
        let wind_mph: Double
        let wind_kph: Double
        let wind_degree: Int
        let wind_dir: String
        let pressure_mb: Double
        let pressure_in: Double
        let precip_mm: Double
        let precip_in: Double
        let humidity: Int
        let cloud: Int
        let feelslike_c: Double
        let feelslike_f: Double
        let windchill_c: Double
        let windchill_f: Double
        let heatindex_c: Double
        let heatindex_f: Double
        let dewpoint_c: Double
        let dewpoint_f: Double
        let vis_km: Double
        let vis_miles: Double
        let uv: Double
        let gust_mph: Double
        let gust_kph: Double
    }
    
    struct Forecast: Decodable {
        struct ForecastDay: Decodable {
            var date: String
            var date_epoch: Int
            var day: Day
            var astro: Astro
            var hour: [Hour]
            
            struct Day: Decodable {
                var maxtemp_c: Double
                var maxtemp_f: Double
                var mintemp_c: Double
                var mintemp_f: Double
                var avgtemp_c: Double
                var avgtemp_f: Double
                var maxwind_mph: Double
                var maxwind_kph: Double
                var totalprecip_mm: Double
                var totalprecip_in: Double
                var totalsnow_cm: Double
                var avgvis_km: Double
                var avgvis_miles: Double
                var avghumidity: Int
                var daily_will_it_rain: Int
                var daily_chance_of_rain: Int
                var daily_will_it_snow: Int
                var daily_chance_of_snow: Int
                var condition: Condition
                var uv: Double
            }
            
            struct Astro: Decodable {
                var sunrise: String
                var sunset: String
                var moonrise: String
                var moonset: String
                var moon_phase: String
                var moon_illumination: Int
                var is_moon_up: Int
                var is_sun_up: Int
            }
            
            struct Hour: Decodable {
                var time_epoch: Int
                var time: String
                var temp_c: Double
                var temp_f: Double
                var is_day: Int
                var condition: Condition
                var wind_mph: Double
                var wind_kph: Double
                var wind_degree: Int
                var wind_dir: String
                var pressure_mb: Double
                var pressure_in: Double
                var precip_mm: Double
                var precip_in: Double
                var snow_cm: Double
                var humidity: Int
                var cloud: Int
                var feelslike_c: Double
                var feelslike_f: Double
                var windchill_c: Double
                var windchill_f: Double
                var heatindex_c: Double
                var heatindex_f: Double
                var dewpoint_c: Double
                var dewpoint_f: Double
                var will_it_rain: Int
                var chance_of_rain: Int
                var will_it_snow: Int
                var chance_of_snow: Int
                var vis_km: Double
                var vis_miles: Double
                var gust_mph: Double
                var gust_kph: Double
                var uv: Double
            }
        }
        
        var forecastday: [ForecastDay]
    }

    var location: Location
    var current: Current
    var forecast: Forecast
}
