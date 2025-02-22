//
//  HomeView.swift
//  WeatherApp
//
//  Created by Devmal Wijesinghe on 2024-12-25.
//

import SwiftUI
import Foundation
import CoreLocation

struct HomeView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State var cityName: String = ""
    @State var weatherDataInit: Bool = false
    @State private var isFavorited: Bool = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    // New state to determine day or night
    @State private var isDayTime: Bool = true
    //default condition for backdrop
    @State var weatherConditionName: String = "clear"
    
    var body: some View {
        NavigationStack {
            ZStack {
                WeatherVideoPlayerView(videoName:$weatherConditionName)
                    .ignoresSafeArea(.container)
                
                ScrollView(.vertical, showsIndicators: false) {
                    HStack {
                        TextField("Search City", text: $cityName)
                            .textFieldStyle(.roundedBorder)
                            .onSubmit {
                                if !cityName.isEmpty{
                                    viewModel.getCoordinateFrom(address: cityName) { success in
                                        if success {
                                            viewModel.locationSearchSuccess = true
                                        } else {
                                            alertMessage = "Error getting coordinates, no such city found."
                                            showingAlert = true
                                        }
                                    }
                                }else{
                                    alertMessage = "Please enter a city name."
                                    showingAlert = true
                                    return
                                }
                            }
                        if !viewModel.favouriteCities.contains(where: { $0.cityName == viewModel.locationName }){
                            Button(action: {
                                if ((((viewModel.locationName?.isEmpty) != nil) || viewModel.currentUserLocation != nil)){
                                    addToFavouriteCities()
                                }else{
                                    alertMessage = "No Location Searched!"
                                    showingAlert = true
                                    return
                                }
                            }){
                                Image(systemName: "heart")
                            }
                        }else{
                            Button(action: {
                                removeFromFavouriteCities()
                            }){
                                Image(systemName: "heart.fill")
                            }
                        }
                    }
                    .padding(.horizontal)
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                    VStack {
                        HStack {
                            Image(systemName: "mappin.and.ellipse")
                            Text("Location")
                        }
                        Text(viewModel.locationName ?? "Fetching...")
                            .font(.largeTitle)
                            .multilineTextAlignment(.center)
                        Text(String(format: "%.1f°", viewModel.weatherData?.current.temp ?? 0.0))
                            .shadow(color: .black, radius: 20, x: 3, y: 3)
                            .font(.system(size: 90))
                            .fontWeight(.thin)
                        Text(String(viewModel.weatherData?.current.weather.first?.description.capitalized ?? "__"))
                            .fontWeight(.semibold)
                            .font(.system(size: 20))
                            .opacity(0.9)
                            .shadow(color: .black, radius: 10, x: 3, y: 3)
                        HStack {
                            Text("H:\(String(format:"%.f", viewModel.weatherData?.daily.first?.temp.max ?? 0))°")
                            Text("L:\(String(format:"%.f", viewModel.weatherData?.daily.first?.temp.min ?? 0))°")
                        }
                        .shadow(color: .black, radius: 8, x: 3, y: 3)
                        .font(.title2)
                    }
                    .padding()
                    .foregroundColor(.white)
                    VStack {
                        Text(viewModel.weatherData?.daily.first?.summary ?? "Fetching Data...")
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                        Divider()
                        ScrollView(.horizontal ,showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(viewModel.hourlyWeatherData.prefix(25), id: \.dt) { forecast in
                                    VStack {
                                        if(forecast.dt == viewModel.hourlyWeatherData.first?.dt) {
                                            Text("Now")
                                        } else {
                                            Text(HomeView.formattedHourAndIncrement(from: TimeInterval(forecast.dt), timezoneOffset: viewModel.timeZoneOffset ?? 0))
                                        }
                                        //fetched manually due to issues with AsyncImage image fetching speed and consistancy
                                        Image(forecast.weather.first?.icon ?? "progress.indicator")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 50, height: 50)
                                        Text("\(Int(forecast.temp))°").fontWeight(.bold)
                                    }
                                }
                            }
                        }
                    }
                    .foregroundStyle(.white)
                    .padding()
                    .background(.ultraThinMaterial).cornerRadius(16)
                    VStack(alignment: .leading, spacing: 2) {
                        HStack {
                            Image(systemName: "calendar")
                            Text("DAILY FORECAST")
                                .font(.subheadline)
                                .multilineTextAlignment(.leading)
                                .opacity(0.8)
                        }
                        Divider()
                        ForEach(viewModel.dailyWeatherData, id: \.dt) { dailyForecast in
                            HStack {
                                // Date
                                if dailyForecast.dt == viewModel.dailyWeatherData.first?.dt {
                                    Text("Today") // Show "Today" for the first element
                                        .font(.system(size: 16, weight: .bold))
                                        .frame(width: 90, alignment: .leading)
                                        .padding(.trailing)
                                } else {
                                    Text(HomeView.formattedDate(from: TimeInterval(dailyForecast.dt), timezoneOffset: viewModel.timeZoneOffset ?? 0))
                                        .font(.system(size: 16, weight: .bold))
                                        .frame(width: 90, alignment: .leading)
                                        .padding(.trailing)
                                }
                                // Weather Icon
                                Image(dailyForecast.weather.first?.icon ?? "progress.indicator")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                Spacer()
                                TemperatureBarView(minTemp: dailyForecast.temp.min, maxTemp: dailyForecast.temp.max, currentTemp: dailyForecast.temp.day)
                                Spacer() // Push remaining content to the left
                            }
                        }
                    }
                    .foregroundStyle(.white)
                    .padding()
                    .background(.ultraThinMaterial).cornerRadius(16)
                    WeatherGridView()
                    Spacer()
                }
                .padding()
            }
            .onChange(of: viewModel.weatherData?.current.dt) {
                checkDayNight()
                updateWeatherCondition()
            }
        }
    }
    
    // Function to check whether it's day or night
    func checkDayNight() {
        guard let sunrise = viewModel.weatherData?.current.sunrise,
              let sunset = viewModel.weatherData?.current.sunset else { return }
        
        let currentTime = Date().timeIntervalSince1970
        if Int(currentTime) >= sunrise && Int(currentTime) < sunset {
            isDayTime = true
        } else {
            isDayTime = false
        }
    }
    
    static func formattedHourAndIncrement(from timestamp: TimeInterval, timezoneOffset: Int = 0) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date) + 1
        let newDate = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: date) ?? date
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezoneOffset)
        dateFormatter.dateFormat = "ha" // 12-hour format with am pm
        return dateFormatter.string(from: newDate)
    }
    
    static func formattedDate(from timestamp: TimeInterval, timezoneOffset: Int = 0) -> String {
        let date = Date(timeIntervalSince1970: timestamp + TimeInterval(timezoneOffset))
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezoneOffset) // Use the provided timezone offset
        dateFormatter.dateFormat = "EEEE, MMMM d" // Format for full day name, full month name, and day
        return dateFormatter.string(from: date)
    }
    
    func addToFavouriteCities() {
        let name = String(viewModel.locationName ?? "__")
        let coordinates = viewModel.coordinate ?? viewModel.currentUserLocation!
        let newCity = FavouriteCity(cityName: name, latitude: coordinates.latitude, longitude: coordinates.longitude)
        if !viewModel.favouriteCities.contains(where: { $0.cityName == name }) && ( !viewModel.favouriteCities.contains(where: { $0.cityCoordinates.latitude == coordinates.latitude }) && !viewModel.favouriteCities.contains(where: { $0.cityCoordinates.longitude == coordinates.longitude })) {
            viewModel.favouriteCities.append(newCity)
        } else {
            alertMessage = "\(name) is already in your favorites."
            showingAlert = true
            isFavorited = true
        }
    }
    
    func removeFromFavouriteCities() {
        let name = String(viewModel.locationName ?? "__")
        let coordinates = viewModel.coordinate ?? viewModel.currentUserLocation!
        let City = FavouriteCity(cityName: name, latitude: coordinates.latitude, longitude: coordinates.longitude)
        if viewModel.favouriteCities.contains(where: { $0.cityName == name }) && ( viewModel.favouriteCities.contains(where: { $0.cityCoordinates.latitude == coordinates.latitude }) && viewModel.favouriteCities.contains(where: { $0.cityCoordinates.longitude == coordinates.longitude })) {
            viewModel.favouriteCities.removeAll( where: { $0.cityName == City.cityName })
        } else {
            isFavorited = false
        }
    }

    func updateWeatherCondition() {
        guard let conditionId = viewModel.weatherData?.current.weather.first?.id else { return }
        weatherConditionName = weatherCondition(conditionId: conditionId)
        print("video changes \(weatherConditionName)")
    }
    func weatherCondition(conditionId: Int) -> String{
        switch conditionId{
        case 200...232:
            return "thunderstorm"
        case 300...321:
            return "drizzle"
        case 500...531:
            return "rain"
        case 600...622:
            return "snow"
        case 701...781:
            return "mist"
        case 800:
            return "clear"
        case 801...804:
            return "clouds"
        default:
            return "clouds"
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(ViewModel())
}
