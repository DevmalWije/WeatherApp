//
//  WeatherDataModel.swift
//  Template
//
//  Created by Devmal Wijesinghe on 2024-12-24.
//

import Foundation
// Define structs to decode the JSON. Make sure the property names match the JSON keys.
struct WeatherResponse: Decodable, Equatable {
    let lat: Double
    let lon: Double
    let timezone: String
    let timezone_offset: Int
    let current: CurrentWeather
    let hourly: [HourlyWeather]
    let daily: [DailyWeather]
}

struct CurrentWeather: Decodable, Equatable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: Double
    let feels_like: Double
    let pressure: Int
    let humidity: Int
    let dew_point: Double
    let uvi: Double
    let clouds: Int
    let visibility: Int?
    let wind_speed: Double
    let wind_deg: Int
    let wind_gust: Double?
    let weather: [WeatherCondition]
}

struct HourlyWeather: Decodable, Equatable {
    let dt: Int
    let temp: Double
    let feels_like: Double
    let weather: [WeatherCondition]
    let pop: Double // Probability of precipitation
    let rain: Rain?
}

struct Rain: Decodable, Equatable {
    let oneH: Double?
    
        enum CodingKeys: String, CodingKey {
            case oneH = "1h"
        }
}

struct DailyWeather: Decodable, Equatable {
    let dt: Int
    let sunrise: Int
    let sunset: Int
    let temp: DailyTemp
    let feels_like: DailyFeelsLike
    let weather: [WeatherCondition]
    let pop: Double
    let rain: Double?
    let summary: String
}

struct DailyTemp: Decodable, Equatable {
    let day: Double
    let min: Double
    let max: Double
}

struct DailyFeelsLike: Decodable, Equatable {
    let day: Double
    let night: Double
    let eve: Double
    let morn: Double
}

struct WeatherCondition: Decodable, Equatable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

import Foundation


struct AirQualityResponse: Codable {
    let coord: Coord
    let list: [AirQualityData]
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}

// Structure for the air quality data
struct AirQualityData: Codable {
    let main: Main
    let components: Components
    let dt: TimeInterval
}

struct Main: Codable {
    let aqi: Int
}

// Structure for the components section
struct Components: Codable {
    let co: Double
    let no: Double
    let no2: Double
    let o3: Double
    let so2: Double
    let pm2_5: Double
    let pm10: Double
    let nh3: Double
}

