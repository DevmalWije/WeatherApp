//
//  ContentView.swift
//  WeatherApp
//
//  Created by Devmal Wijesinghe on 2024-12-24.
//

import SwiftUI

import Foundation
import CoreLocation

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var selectedMark: City?
    @State var cityName: String = ""
    
    @State private var currentLocation: String = "--"
    @State private var currentTemp: String = "--°"
    @State private var currentForcastSum: String = "-----"
    @State private var dayForecastSum: String = "Fetching Data..."
    
    @State private var tempHigh: Double = 00.0
    @State private var tempLow: Double = 00.0
    
    @State var testCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 7.0384, longitude: 79.9907) // Example: San Francisco, CA
    
    var body: some View {
        NavigationStack {
            ZStack{
                ScrollView(.vertical, showsIndicators: false) {
                    TextField("Search City", text: $cityName)
                        .textFieldStyle(.roundedBorder)
                        .onSubmit {
                            viewModel.getCoordinateFrom(address: cityName)
                            print()
                        }
                    
                    NavigationLink(destination: MapView(selectedMark: $selectedMark)) {
                        Label("Pick from Favouires", systemImage: "location.circle")
                    }
                    VStack {
                        Text("My Location")
                        Text(currentLocation)
                            .font(.largeTitle)
                        Text(currentTemp)
                            .shadow(color: .black, radius: 20, x: 3, y: 3)
                            .font(.system(size: 90))
                            .fontWeight(.thin)
                        Text(currentForcastSum)
                            .fontWeight(.semibold)
                            .font(.system(size: 20))
                            .opacity(0.9)
                            .shadow(color: .black, radius: 10, x: 3, y: 3)
                        HStack{
                            Text("H:\(String(format:"%.f", tempHigh))°")
                            Text("L:\(String(format:"%.f", tempLow))°")
                        }
                        .shadow(color: .black, radius: 8, x: 3, y: 3)
                        .font(.title2)
                    }
                    .padding()
                    .foregroundColor(.white)
                    .onChange(of: viewModel.weatherData) { _, newWeatherData in
                        if let temp = newWeatherData?.current.temp {
                            currentTemp = String(format: "%.1f°", temp)
                        }
                        if let location = newWeatherData?.timezone {
                            if let city = location.split(separator: "/").last {
                                currentLocation = String(city).replacingOccurrences(of: "_", with: " ")
                            }
                        }
                        if let forcastSum = newWeatherData?.current.weather.first?.description {
                            currentForcastSum = String(forcastSum)
                        }
                        if let dailyHigh = newWeatherData?.daily.first?.temp.max{
                            tempHigh = dailyHigh
                        }
                        if let dailyLow = newWeatherData?.daily.first?.temp.min{
                            tempLow = dailyLow
                        }
                    }
                    VStack{
                        Text(dayForecastSum)
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                        Divider()
                        ScrollView(.horizontal ,showsIndicators: false){
                            //Hstack filled with hard coded dummy data
                            HStack(spacing: 20) {
                                VStack {
                                    Text("Now")
                                    Image(systemName: "cloud.fill")
                                    Text("84°").fontWeight(.bold)
                                }
                                VStack {
                                    Text("17")
                                    Image(systemName: "cloud.fill")
                                    Text("83°").fontWeight(.bold)
                                }
                                VStack {
                                    Text("Sunset")
                                    Image(systemName: "sun.max.fill")
                                    Text("17:53").fontWeight(.bold)
                                }
                                VStack {
                                    Text("18")
                                    Image(systemName: "cloud.fill")
                                    Text("82°").fontWeight(.bold)
                                }
                                VStack {
                                    Text("19")
                                    Image(systemName: "cloud.fill")
                                    Text("81°").fontWeight(.bold)
                                }
                                VStack {
                                    Text("20")
                                    Image(systemName: "cloud.fill")
                                    Text("79°").fontWeight(.bold)
                                }
                                VStack {
                                    Text("21")
                                    Image(systemName: "cloud.fill")
                                    Text("75°").fontWeight(.bold)
                                }
                                VStack {
                                    Text("22")
                                    Image(systemName: "cloud.fill")
                                    Text("72°").fontWeight(.bold)
                                }
                                VStack {
                                    Text("23")
                                    Image(systemName: "cloud.fill")
                                    Text("70°").fontWeight(.bold)
                                }
                                
                            }
                        }
                    }
                    .foregroundStyle(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.blue.opacity(0.5)) // Card Background
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5) // Shadow
                    )
                    .onChange(of: viewModel.weatherData) { _, newWeatherData in
                        if let dayForcast = newWeatherData?.daily.first?.summary {
                            dayForecastSum = dayForcast
                        }
                    }
                    VStack(alignment: .leading){
                        HStack{
                            Image(systemName: "calendar")
                            Text("10-DAY FORECAST")
                                .font(.subheadline)
                                .multilineTextAlignment(.leading)
                        }
                        Divider()
                        HStack{
                            Text("Today")
                                .font(.title2)
                            Spacer()
                            Image(systemName: "cloud.fill")
                            Spacer()
                            Image(systemName: "sun.max")
                            Text("\(String(format:"%.f", tempHigh))°")
                                .opacity(0.9)
                                .font(.title3)
                            Spacer()
                            Image(systemName: "moon.fill")
                            Text("\(String(format:"%.f", tempLow))°")
                                .font(.title3)
                        }
                        .font(.system(size: 25))
                        Divider()
                        HStack{
                            Text("Today")
                                .font(.title2)
                            Spacer()
                            Image(systemName: "cloud.fill")
                            Spacer()
                            Image(systemName: "sun.max")
                            Text("\(String(format:"%.f", tempHigh))°")
                                .opacity(0.9)
                                .font(.title3)
                            Spacer()
                            Image(systemName: "moon.fill")
                            Text("\(String(format:"%.f", tempLow))°")
                                .font(.title3)
                        }
                        .font(.system(size: 25))
                        Divider()
                        HStack{
                            Text("Today")
                                .font(.title2)
                            Spacer()
                            Image(systemName: "cloud.fill")
                            Spacer()
                            Image(systemName: "sun.max")
                            Text("\(String(format:"%.f", tempHigh))°")
                                .opacity(0.9)
                                .font(.title3)
                            Spacer()
                            Image(systemName: "moon.fill")
                            Text("\(String(format:"%.f", tempLow))°")
                                .font(.title3)
                        }
                        .font(.system(size: 25))
                        Divider()
                        HStack{
                            Text("Today")
                                .font(.title2)
                            Spacer()
                            Image(systemName: "cloud.fill")
                            Spacer()
                            Image(systemName: "sun.max")
                            Text("\(String(format:"%.f", tempHigh))°")
                                .opacity(0.9)
                                .font(.title3)
                            Spacer()
                            Image(systemName: "moon.fill")
                            Text("\(String(format:"%.f", tempLow))°")
                                .font(.title3)
                        }
                        .font(.system(size: 25))
                        Divider()
                        HStack{
                            Text("Today")
                                .font(.title2)
                            Spacer()
                            Image(systemName: "cloud.fill")
                            Spacer()
                            Image(systemName: "sun.max")
                            Text("\(String(format:"%.f", tempHigh))°")
                                .opacity(0.9)
                                .font(.title3)
                            Spacer()
                            Image(systemName: "moon.fill")
                            Text("\(String(format:"%.f", tempLow))°")
                                .font(.title3)
                        }
                        .font(.system(size: 25))
                        Divider()
                        HStack{
                            Text("Today")
                                .font(.title2)
                            Spacer()
                            Image(systemName: "cloud.fill")
                            Spacer()
                            Image(systemName: "sun.max")
                            Text("\(String(format:"%.f", tempHigh))°")
                                .opacity(0.9)
                                .font(.title3)
                            Spacer()
                            Image(systemName: "moon.fill")
                            Text("\(String(format:"%.f", tempLow))°")
                                .font(.title3)
                        }
                        .font(.system(size: 25))
                        Divider()
                        HStack{
                            Text("Today")
                                .font(.title2)
                            Spacer()
                            Image(systemName: "cloud.fill")
                            Spacer()
                            Image(systemName: "sun.max")
                            Text("\(String(format:"%.f", tempHigh))°")
                                .opacity(0.9)
                                .font(.title3)
                            Spacer()
                            Image(systemName: "moon.fill")
                            Text("\(String(format:"%.f", tempLow))°")
                                .font(.title3)
                        }
                        .font(.system(size: 25))
                        Divider()
                        HStack{
                            Text("Today")
                                .font(.title2)
                            Spacer()
                            Image(systemName: "cloud.fill")
                            Spacer()
                            Image(systemName: "sun.max")
                            Text("\(String(format:"%.f", tempHigh))°")
                                .opacity(0.9)
                                .font(.title3)
                            Spacer()
                            Image(systemName: "moon.fill")
                            Text("\(String(format:"%.f", tempLow))°")
                                .font(.title3)
                        }
                        .font(.system(size: 25))
                        Divider()
                        HStack{
                            Text("Today")
                                .font(.title2)
                            Spacer()
                            Image(systemName: "cloud.fill")
                            Spacer()
                            Image(systemName: "sun.max")
                            Text("\(String(format:"%.f", tempHigh))°")
                                .opacity(0.9)
                                .font(.title3)
                            Spacer()
                            Image(systemName: "moon.fill")
                            Text("\(String(format:"%.f", tempLow))°")
                                .font(.title3)
                        }
                        .font(.system(size: 25))
                        Divider()
                        HStack{
                            Text("Today")
                                .font(.title2)
                            Spacer()
                            Image(systemName: "cloud.fill")
                            Spacer()
                            Image(systemName: "sun.max")
                            Text("\(String(format:"%.f", tempHigh))°")
                                .opacity(0.9)
                                .font(.title3)
                            Spacer()
                            Image(systemName: "moon.fill")
                            Text("\(String(format:"%.f", tempLow))°")
                                .font(.title3)
                        }
                        .font(.system(size: 25))
                        Divider()
                        
                    }
                    .foregroundStyle(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.blue.opacity(0.5)) // Card Background
                            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 5) // Shadow
                    )
                    Spacer()
                }
            }
            .background(Image("sunnyBackground"))
            .padding()
            .toolbar {
                NavigationLink(destination: FavouritesView()) {
                    Image(systemName: "heart")
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ViewModel())
}
