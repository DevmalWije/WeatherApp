//
//  ViewModel.swift
//  WeatherApp
//
//  Created by Devmal Wijesinghe on 2024-12-24.
//

import Foundation
import CoreLocation



class ViewModel: NSObject,ObservableObject, CLLocationManagerDelegate {
    
    //published variables to be utilized in subsequent views
    @Published var selectedCities: Set<City> = []
    @Published var coordinate: CLLocationCoordinate2D? = nil
    @Published var geocodingError: Error? = nil
    @Published var weatherData: WeatherResponse?
    private var locationManager = CLLocationManager()
    
    //API call constants
    let APIKey = "841d2244be17c810ea7de37ff784415b"
    let baseURL = "https://api.openweathermap.org/data/3.0/onecall?"
    
    //loac
    private let geocoder = CLGeocoder()
    
    func getCoordinateFrom(address: String) {
        geocoder.geocodeAddressString(address) { [weak self] placemarks, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.geocodingError = error
                    self?.coordinate = nil
                } else if let coordinate = placemarks?.first?.location?.coordinate {
                    self?.coordinate = coordinate
                    Task {
                        await self!.getCityWeatherFromAPI(coordinate: coordinate)
                    }
                    self?.geocodingError = nil
                }
            }
        }
    }
    
    func getCityWeatherFromAPI(coordinate: CLLocationCoordinate2D) async {
        guard let apiUrl = URL(string: "\(baseURL)lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&units=metric&exclude=minutely&appid=\(APIKey)") else {
            print("URL is not valid!")
            return
        }

        do {
            // Fetch data from the API
            let (data, _) = try await URLSession.shared.data(from: apiUrl)
            
            // Decode JSON response into WeatherResponse
            let decodedResponse = try JSONDecoder().decode(WeatherResponse.self, from: data)
            
            // Update the published property on the main thread
            DispatchQueue.main.async { [weak self] in
                self?.weatherData = decodedResponse
            }
            
            // Debugging: Print some key values
            print("Weather Data Decoded Successfully!")
            print("Latitude: \(decodedResponse.lat), Longitude: \(decodedResponse.lon)")
            print("TimeZone: \(decodedResponse.timezone)")
            print("Current Temp: \(decodedResponse.current.temp)°C")
            print("Weather Description: \(decodedResponse.current.weather.first?.description ?? "N/A")")
            print("Daily Forecast Count: \(decodedResponse.daily.count)")
            print(decodedResponse.daily.first?.temp.max)
            print(decodedResponse.daily.first?.temp.min)
            print(decodedResponse.daily.first?.summary)

        } catch let decodingError as DecodingError {
            // Print detailed decoding error for debugging
            print("Decoding error: \(decodingError)")
        } catch {
            // Handle other errors (networking, etc.)
            print("Error fetching or decoding weather data: \(error.localizedDescription)")
        }
    }
}
