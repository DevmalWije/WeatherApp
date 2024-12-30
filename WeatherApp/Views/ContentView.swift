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
    @State private var selectedTab: Tab = .home

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(Tab.home)

            MapView()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
                .tag(Tab.map)

            FavouritesView(selectedTab: $selectedTab) // Pass the binding
                .tabItem {
                    Label("Favourites", systemImage: "heart")
                }
                .tag(Tab.favourites)
        }
    }
}


enum Tab {
    case home
    case map
    case favourites
}

#Preview {
    ContentView()
        .environmentObject(ViewModel())
}
