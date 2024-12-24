//
//  WeatherAppApp.swift
//  WeatherApp
//
//  Created by Devmal Wijesinghe on 2024-12-24.
//

import SwiftUI

@main
struct WeatherAppApp: App {
    @StateObject var viewModel = ViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
