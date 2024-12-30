//
//  FavouritesView.swift
//  WeatherApp
//
//  Created by Devmal Wijesinghe on 2024-12-24.
//
import SwiftUI

struct FavouritesView: View {
    @EnvironmentObject var viewModel: ViewModel
    @Binding var selectedTab: Tab

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) { // Lazy loading for better performance
                    ForEach(viewModel.favouriteCities) { city in
                        HStack {
                            Text(city.cityName)
                                .frame(maxWidth: .infinity, alignment: .leading) // Ensure city name takes full space
                                .padding(.vertical, 8)
                            
                            Button {
                                Task {
                                    await viewModel.getCityWeatherFromAPI(coordinate: city.cityCoordinates)
                                    await MainActor.run {
                                        selectedTab = .home // Navigate to Home tab
                                    }
                                }
                            } label: {
                                Image(systemName: "cloud.sun")
                                    .foregroundColor(.blue)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.blue, lineWidth: 2)
                                    )
                            }
                            .contentShape(Rectangle()) // Avoid overlapping tap gestures
                            
                            Button {
                                viewModel.favouriteCities.removeAll(where: { $0.cityName == city.cityName })
                            } label: {
                                Image(systemName: "xmark.circle")
                                    .foregroundColor(.red)
                                    .padding()
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.red, lineWidth: 2)
                                    )
                            }
                            .contentShape(Rectangle()) // Ensure button-only interaction
                        }
                        .padding(.horizontal)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.1)) // Light background for separation
                        )
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Favourites View")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
#Preview {
    FavouritesView(selectedTab: .constant(Tab.favourites))
        .environmentObject(ViewModel())
}
