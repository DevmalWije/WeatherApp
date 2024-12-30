//
//  MapView.swift
//  WeatherApp
//
//  Created by Devmal Wijesinghe on 2024-12-24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var showAlert = false
    @State private var selectedCity: String?

    var body: some View {
        NavigationStack {
            Map(selection: $selectedCity) {
                ForEach(viewModel.favouriteCities, id: \.id) { city in
                    Marker(city.cityName, coordinate: city.cityCoordinates)
                        .tag(city.cityName) 
                }
            }
            .onChange(of: selectedCity, { oldValue, newValue in
                if let newCityName = newValue, let selectedCity = viewModel.favouriteCities.first(where: { $0.cityName == newCityName }) {
                    print("Selected city: \(selectedCity.cityName)")
                    Task{
                        await viewModel.getCityWeatherFromAPI(coordinate: selectedCity.cityCoordinates)
                    }
                }
            })
            .navigationTitle("Map View")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
#Preview {
    MapView()
        .environmentObject(ViewModel())
}

