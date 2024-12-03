//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Andy Reyes on 11/22/24.
//

import SwiftUI
import Foundation


func formatStringTime(_ timeInHour: String) -> String {
    let currentTime = timeInHour.split(separator: ":").first
    let intCurrentTime = Int(currentTime!)
    if let intCurrentTime {
        if intCurrentTime > 12 {
            let time = intCurrentTime - 12
            return "\(time)PM"
        }
        else {
            return "\(intCurrentTime)AM"
        }
    }
    return "Time not found"
}

struct WeatherView: View {
    var weather: CurrentWeatherResponse
    // Most of the stuff in here is hard coded to the dummyWeatherData. Can make changes when needed for the acutly data.
    
    var body: some View {
        ZStack(alignment: .leading) {
            BackgroundTimer(weather: weather.current.condition.text).edgesIgnoringSafeArea(.all)
            VStack {
                VStack(alignment: .center, spacing: 5) {
                    Text(weather.location.name)
                        .bold().font(.title)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.white)
                    Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                        .fontWeight(.light)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .foregroundColor(.white)
                }
                
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                ScrollView(.horizontal) {
                    HStack(spacing: 20) {
                        // fix this to filter correctly
                        let currentHour = Calendar.current.component(.hour, from: Date())
                        let hours = weather.forecast.forecastday[0].hour[currentHour..<24]
                        if hours.isEmpty {
                            Text("No data").foregroundColor(.gray)
                        } else {
                            ForEach(hours, id: \.time_epoch) {
                                hour in
                                VStack(spacing: 15) {
                                    Text(formatStringTime(String(hour.time.suffix(5))))
                                    AsyncImage(url: URL(string: "https:" + hour.condition.icon)) { image in image.resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 40, height: 40)
                                        
                                    } placeholder: {
                                        LoadingView()
                                    }
                                    Text("\(hour.temp_f.roundDouble())" + "°")
                                        .font(.title2)
                                        .bold()
                                }
                                .frame(width: 100, alignment: .center)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                
                ScrollView(.horizontal) {
                    HStack(spacing: 20) {
                        // fix this to filter correctly
                        let forecastdays = weather.forecast.forecastday[1..<7]
                        if forecastdays.isEmpty {
                            Text("No data").foregroundColor(.gray)
                        } else {
                            ForEach(forecastdays, id: \.date_epoch) {
                                forecastday in
                                VStack(spacing: 15) {
                                    Text(forecastday.date.suffix(5))
                                    AsyncImage(url: URL(string: "https:" + forecastday.day.condition.icon)) { image in image.resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 40, height: 40)
                                        
                                    } placeholder: {
                                        LoadingView()
                                    }
                                    Text("\(forecastday.day.avgtemp_f.roundDouble())" + "°")
                                        .font(.title2)
                                        .bold()
                                }
                                .frame(width: 100, alignment: .center)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                            }
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                
                
                VStack {
                    Spacer()
                    VStack(alignment: .leading, spacing: 20)
                    {
                        Text("Weather Now")
                            .bold()
                            .padding(.bottom)
                        HStack {
                            WeatherRow(logo: "thermometer", name: "Min Temp", value: weather.forecast.forecastday[0].day.mintemp_f.roundDouble() + "°")
                            Spacer()
                            
                            WeatherRow(logo: "thermometer", name: "Max Temp", value: weather.forecast.forecastday[0].day.maxtemp_f.roundDouble() + "°")
                        }
                        HStack {
                            WeatherRow(logo: "wind", name: "Wind Speed", value: weather.current.wind_mph.roundDouble() + "m/s")
                            Spacer()
                            
                            WeatherRow(logo: "humidity", name: "Humidity", value: String(weather.current.humidity) + "%")
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .padding(.bottom, 20)
                    .foregroundColor(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
                    .background(.white)
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                }
                
                
            }
            
//            .edgesIgnoringSafeArea(.bottom)
//            .background(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
//            .preferredColorScheme(.dark)
        }
    }
}
struct BackgroundTimer: View {
    let weather: String // current weather
    
    var gradientColors: [Color] {
    let hour = Calendar.current.component(.hour, from: Date()) // current hour
    
    var colors = [Color.blue.opacity(0.5), Color.orange.opacity(0.5)]
    
    // Change the background to the weather at the current time
    if weather.lowercased().contains("rain") {
        colors = [Color.gray.opacity(0.7), Color.blue.opacity(0.5)]
    } else if weather.lowercased().contains("cloud") {
        colors = [Color.gray.opacity(0.8), Color.gray.opacity(0.4)]
    } else if weather.lowercased().contains("snow") {
        colors = [Color.white.opacity(0.8), Color.white.opacity(0.4)]
    } else if weather.lowercased().contains("thunder") {
        colors = [Color.black, Color.purple.opacity(0.7)]
    }
    // Change the background according to the time of day
    switch hour {
    case 6..<12:
        return colors.map { $0.opacity(0.9)}
    case 12..<18:
        return colors.map { $0.opacity(1.0)}
    case 18..<20:
        return colors.map { $0.opacity(0.7)}
    default:
        return colors.map { $0.opacity(0.5)}
    }
    }
    
    var body: some View {
        LinearGradient (gradient: Gradient(colors: gradientColors), startPoint: .top, endPoint: .bottom)
    }
    
    
}
    
    struct WeaterView_Previews: PreviewProvider {
        static var previews: some View {
            
            WeatherView(weather: previewWeather)
        }
    }

