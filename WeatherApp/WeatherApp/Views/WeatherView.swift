//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Andy Reyes on 11/22/24.
//

import SwiftUI

struct WeatherView: View {
    var weather: CurrentWeatherResponse
    // Most of the stuff in here is hard coded to the dummyWeatherData. Can make changes when needed for the acutly data.
    
    var body: some View {
        ZStack(alignment: .leading) {
            VStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(weather.location.name)
                        .bold().font(.title)
                    Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                        .fontWeight(.light)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                
                VStack {
                    HStack {
                        VStack(spacing: 20) {
                            Image(systemName: "sun.max")
                                .font(.system(size: 40))
                            
                            Text(weather.current.condition.text)
                        }
                        .frame(width: 150, alignment: .leading)
                        
                        Spacer()
                        Text(weather.current.feelslike_f.roundDouble() + "°")
                            .font(.system(size:100))
                            .fontWeight(.bold)
                            .padding()
                    }
                    Spacer()
                        .frame(height: 80)
                    
                    AsyncImage(url: URL(string: "https://pixabay.com/get/g0c317c7fe8c66f967c8fa97aec7f2e2aa5eb2d808c220738df475832a5e6706068b6ddef0589b313809fb8adfdb317b80ea436ad0d5b012ab59e403bff5d7b21_1280.png")) {image in image.resizable().aspectRatio(contentMode:.fit)
                            .frame(width:350)
                    } placeholder: {
                        ProgressView()
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity)
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
        
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
        .preferredColorScheme(.dark)
    }
}

struct WeaterView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView(weather: previewWeather)
    }
}
