//
//  ContentView.swift
//  WeatherApp
//
//  Created by Caleb McKinley on 11/21/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        VStack {
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
