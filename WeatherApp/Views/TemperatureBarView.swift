//
//  TemperatureBarView.swift
//  WeatherApp
//
//  Created by Devmal Wijesinghe on 2024-12-27.
//

import Foundation
import SwiftUI

struct TemperatureBarView: View {
    let minTemp: CGFloat // Minimum temperature
    let maxTemp: CGFloat // Maximum temperature
    let currentTemp: CGFloat // Current temperature (optional marker)
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack{
                    Image(systemName: "thermometer.snowflake")
                    Text("\(Int(minTemp))°")
                }
                .font(.caption)
                .foregroundColor(.white)
                // Temperature Range Bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        // Full Range Bar
                        Capsule()
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 6)
                        // Filled Range Bar
                        Capsule()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.blue, Color.red]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .frame(
                                width: geometry.size.width,
                                height: 6
                            )

                        // Current Temperature Marker
                        if currentTemp >= minTemp && currentTemp <= maxTemp {
                            Circle()
                                .fill(Color.white)
                                .frame(width: 10, height: 10)
                                .offset(
                                    x: (geometry.size.width * CGFloat((currentTemp - minTemp) / (maxTemp - minTemp)))
                                )
                        }
                    }
                }
                .frame(height: 20)
                .padding()
                VStack{
                    Image(systemName: "thermometer.sun")
                    Text("\(Int(maxTemp))°")
                }
                .font(.caption)
                .foregroundColor(.white)
            }
            .frame(height: 30)
        }
    }
}

