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
            List {
                ForEach(viewModel.favouriteCities) { city in
                    HStack {
                        Text(city.cityName)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Button {
                            Task {
                                await viewModel.getCityWeatherFromAPI(coordinate: city.cityCoordinates)
                                await MainActor.run {
                                    selectedTab = .home
                                }
                            }
                        } label: {
                            Image(systemName: "cloud.sun")
                                .foregroundStyle(Color.white)
                        }
                        .padding()
                        .buttonStyle(.borderedProminent)
                        Button {
                            viewModel.favouriteCities.removeAll(where: { $0.cityName == city.cityName })
                        } label: {
                            Image(systemName: "xmark")
                            .foregroundStyle(Color.red)
                            .font(.system(size: 12))
                        }
                    }
                }
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
