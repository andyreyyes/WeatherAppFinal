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
                VStack(alignment: .center, spacing: 5) {
                    Text(weather.location.name)
                        .bold().font(.title)
                        .frame(maxWidth: .infinity, alignment: .center)
                    Text("Today, \(Date().formatted(.dateTime.month().day().hour().minute()))")
                        .fontWeight(.light)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                ScrollView(.horizontal) {
                    HStack(spacing: 20) {
                        // fix this to filter correctly
                        
                        let hours = weather.forecast.forecastday[0].hour[0..<12]
                        if hours.isEmpty {
                            Text("No data").foregroundColor(.gray)
                        } else {
                            // also correctly format this to have the time at the top
                            ForEach(hours, id: \.time_epoch) {
                                hour in
                                VStack(spacing: 15) {
                                    if let date = ISO8601DateFormatter().date(from: hour.time) {
                                        Text(date.formatted(.dateTime.hour().minute()))
                                            .font(.caption)
                                    } else {
                                        Text("N/A")
                                    }
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
}
    
    struct WeaterView_Previews: PreviewProvider {
        static var previews: some View {
            WeatherView(weather: previewWeather)
        }
    }

