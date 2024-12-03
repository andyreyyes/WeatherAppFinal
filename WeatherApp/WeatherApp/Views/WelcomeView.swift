//
//  WelcomeView.swift
//  WeatherApp
//
//  Created by John Le on 11/21/24.
//

import SwiftUI
import CoreLocationUI

struct WelcomeView: View {
    @EnvironmentObject var locationManager: LocationManager
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                VStack(spacing: 20) {
                    Text("Welcome to the Weather App")
                        .bold().font(.title)
                    
                    Text("Please allow location access to get your current location")
                        .padding()
                }
                .multilineTextAlignment(.center)
                .padding()
                
                LocationButton(.shareCurrentLocation) {
                    locationManager.requestLocation()
                }
                .cornerRadius(30)
                .symbolVariant(.fill)
                .foregroundColor(.white)
                NavigationLink(destination: SearchView()) {
                    Text("Search for a location")
                        .foregroundColor(.blue)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                }
                .padding()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(BackgroundTimer(weather: "clear").edgesIgnoringSafeArea(.all))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeView()
            .environmentObject(LocationManager())
    }
}
