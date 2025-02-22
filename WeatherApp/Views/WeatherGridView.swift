//
//  WeatherGridView.swift
//  WeatherApp
//
//  Created by Devmal Wijesinghe on 2024-12-27.
//

import SwiftUI

struct WeatherGridView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        Grid(alignment: .leading, horizontalSpacing: 10, verticalSpacing: 10){
            GridRow{
                HStack{
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "wind.snow.circle")
                                .foregroundStyle(Color.white)
                                .aspectRatio(contentMode: .fit)
                            Text("Air Quality (μg/m3)")
                                .padding(.horizontal)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                            Divider()
                                .frame(width: 1)
                                .background(Color.white)
                                .rotationEffect(.degrees(90))
                            Text("\(viewModel.airQualityData?.list.first?.main.aqi ?? 0) : ")
                                .padding(.leading)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            Text("\(airQuality(qualityIndex:viewModel.airQualityData?.list.first?.main.aqi ?? 0))")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        Divider()
                        HStack(spacing: 16) {
                            VStack(spacing: 10) {
                                HStack {
                                    Text("CO : ")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("\(String(format:"%.2f", viewModel.airQualityData?.list.first?.components.co ?? 0))")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                HStack {
                                    Text("NO : ")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("\(String(format:"%.2f", viewModel.airQualityData?.list.first?.components.no ?? 0))")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                HStack {
                                    Text("NO2 : ")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("\(String(format:"%.2f", viewModel.airQualityData?.list.first?.components.no2 ?? 0))")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                            }
                            
                            VStack(spacing: 10) {
                                HStack {
                                    Text("O3 : ")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("\(String(format:"%.2f", viewModel.airQualityData?.list.first?.components.o3 ?? 0))")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                HStack {
                                    Text("SO2 : ")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("\(String(format:"%.2f", viewModel.airQualityData?.list.first?.components.so2 ?? 0))")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                HStack {
                                    Text("NH3 : ")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("\(String(format:"%.2f", viewModel.airQualityData?.list.first?.components.nh3 ?? 0))")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                            }

                            VStack(spacing: 10) {
                                HStack {
                                    Text("PM2.5 : ")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("\(String(format:"%.2f", viewModel.airQualityData?.list.first?.components.pm2_5 ?? 0))")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                                HStack {
                                    Text("PM10 : ")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(.white)
                                    Spacer()
                                    Text("\(String(format:"%.2f", viewModel.airQualityData?.list.first?.components.pm10 ?? 0))")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    .padding()
                }
                .gridCellColumns(2)
                .background(.ultraThinMaterial).cornerRadius(16)
            }
            GridRow{
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "sunrise")
                            .foregroundColor(.yellow)
                            .aspectRatio(contentMode: .fit)
                        Text("Sunrise")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                    }
                    Text(convertUnixTimestampToTime(from: TimeInterval(Double(viewModel.weatherData?.current.sunrise ?? 0)), timezoneOffset: viewModel.timeZoneOffset ?? 0))
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Divider()
                    HStack {
                        Image(systemName: "sunset")
                            .foregroundColor(.orange)
                            .aspectRatio(contentMode: .fit)
                        Text("Sunset")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                    }
                    Text(convertUnixTimestampToTime(from: TimeInterval(Double(viewModel.weatherData?.current.sunset ?? 0)), timezoneOffset: viewModel.timeZoneOffset ?? 0))
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Spacer()
                }
                .foregroundStyle(.white)
                .padding()
                .background(.ultraThinMaterial).cornerRadius(16)
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "eye")
                            .foregroundColor(.white.opacity(0.7))
                            .frame(width: 20, height: 20)
                        Text("Visibility")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    Divider()
                        .background(Color.white.opacity(0.7))
                    Spacer()
                    Text("\(String(viewModel.weatherData?.current.visibility ?? 0)) meters")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
                .padding()
                .background(.ultraThinMaterial).cornerRadius(16)
            }
            // GridRow for Wind Speed and Direction
            GridRow {
                HStack{
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Image(systemName: "wind")
                                .foregroundColor(.white.opacity(0.7))
                                .frame(width: 40, height: 40)
                            Text("Wind Speed")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        Divider()
                            .background(Color.white.opacity(0.7))
                        Text("\(String(format: "%.1f", viewModel.weatherData?.current.wind_speed ?? 0)) m/s")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                        Spacer()
                    }
                    .padding()
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            // Use GeometryReader to handle dynamic resizing and direction of arrow according to wind direction
                            GeometryReader { geometry in
                                Image(systemName: "arrow.up.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                    .rotationEffect(.degrees(Double(viewModel.weatherData?.current.wind_deg ?? 0)))
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            .frame(width: 30, height: 30)
                            Text("Wind Direction")
                                .padding(.horizontal)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        Divider()
                            .background(Color.white.opacity(0.7))
                        // Display the wind direction text
                        Text("\(getWindDirection(degrees: viewModel.weatherData?.current.wind_deg ?? 0))")
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                        Spacer()
                    }
                    .padding()
                }
                .gridCellColumns(2)
                .background(.ultraThinMaterial).cornerRadius(16)
            }
            //humidity and dew point
            GridRow{
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "humidity.fill")
                            .foregroundColor(.white.opacity(0.7))
                            .frame(width: 40, height: 40) // Adjust size for better visibility of animation
                        Text("Humidity")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    Divider()
                    Spacer()
                    Text("\(String(viewModel.weatherData?.current.humidity ?? 0)) %")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
                .padding()
                .background(.ultraThinMaterial).cornerRadius(16)
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "drop.degreesign.fill")
                            .foregroundColor(.white.opacity(0.7))
                            .frame(width: 40, height: 40) // Adjust size for better visibility of animation
                        Text("Dew Point")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    Divider()
                        .background(Color.white.opacity(0.7))
                    Spacer()
                    Text("\(String(viewModel.weatherData?.current.dew_point ?? 0)) °")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
                .padding()
                .background(.ultraThinMaterial).cornerRadius(16)
            }
            GridRow{
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "sun.max.fill")
                            .foregroundColor(.white.opacity(0.7))
                            .frame(width: 40, height: 40) // Adjust size for better visibility of animation
                        Text("UV Index")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    Divider()
                        .background(Color.white.opacity(0.7))
                    Spacer()
                    Text(String(viewModel.weatherData?.current.uvi ?? 0))
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
                .padding()
                .background(.ultraThinMaterial).cornerRadius(16)
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image(systemName: "cloud.fill")
                            .foregroundColor(.white.opacity(0.7))
                            .frame(width: 40, height: 40) // Adjust size for better visibility of animation
                        Text("Cloud Cover")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                        Spacer()
                    }
                    Divider()
                        .background(Color.white.opacity(0.7))
                    Spacer()
                    Text(String(viewModel.weatherData?.current.clouds ?? Int(0.0)))
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
                .padding()
                .background(.ultraThinMaterial).cornerRadius(16)
            }
            GridRow {
                HStack{
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Atmospheric Pressure")
                                .padding(.horizontal)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                            Spacer()
                        }
                        Divider()
                            .background(Color.white.opacity(0.7))
                        // Display the wind direction text
                        HStack{
                            Image(systemName: "tachometer")
                                .foregroundColor(.white.opacity(0.7))
                                .font(.system(size: 60))
                                .padding()
                            Text("\(viewModel.weatherData?.current.pressure ?? 0) hPa")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                                
                            Spacer()
                        }
                    }
                    .padding()
                }
                .gridCellColumns(2)
                .background(.ultraThinMaterial).cornerRadius(16)
            }
        }
    }
    
    // Function to get wind direction from degrees
    private func getWindDirection(degrees: Int) -> String {
        switch degrees {
        case 0...22:
            return "North"
        case 23...67:
            return "Northeast"
        case 68...112:
            return "East"
        case 113...157:
            return "Southeast"
        case 158...202:
            return "South"
        case 203...247:
            return "Southwest"
        case 248...292:
            return "West"
        case 293...337:
            return "Northwest"
        default:
            return "Unknown"
        }
    }
    
    private func airQuality(qualityIndex: Int) -> String {
        switch qualityIndex {
        case 1:
            return "Good"
        case 2:
            return "Fair"
        case 3:
            return "Moderate"
        case 4:
            return "Poor"
        case 5:
            return "Very Poor"
        default:
            return "Unknown"
        }
    }
    
     func convertUnixTimestampToTime(from timestamp: TimeInterval, timezoneOffset: Int = 0) -> String {
          let date = Date(timeIntervalSince1970: timestamp)
          let calendar = Calendar.current
          let hour = calendar.component(.hour, from: date) + 1
          let newDate = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: date) ?? date
          let dateFormatter = DateFormatter()
          dateFormatter.timeZone = TimeZone(secondsFromGMT: timezoneOffset)
          dateFormatter.dateFormat = "hh:mm a" // 12-hour format with am pm
          return dateFormatter.string(from: newDate)
      }
      
}

#Preview {
    WeatherGridView()
        .environmentObject(ViewModel())
}

