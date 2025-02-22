//
//  ViewModel.swift
//  WeatherApp
//
//  Created by Devmal Wijesinghe on 2024-12-24.
//
//
//
import Foundation
import CoreLocation



class ViewModel: NSObject,ObservableObject, CLLocationManagerDelegate {
    
    //published variables to be utilized in subsequent views
    @Published var selectedCities: Set<City> = []
    @Published var favouriteCities: [FavouriteCity] = [] {
        didSet {
            saveFavoriteCities()
        }
    }
    @Published var coordinate: CLLocationCoordinate2D? = nil
    @Published var geocodingError: Error? = nil
    @Published var weatherData: WeatherResponse?
    @Published var airQualityData: AirQualityResponse?
    @Published var locationName: String?
    @Published var hourlyWeatherData: [HourlyWeather] = []
    @Published var dailyWeatherData: [DailyWeather] = []
    @Published var timeZoneOffset: Int?
    @Published var isLocationAccessGranted: Bool = false
    @Published var locationSearchSuccess: Bool = false
    //for fetching current user location
    @Published var currentUserLocation: CLLocationCoordinate2D?
    private var funcLocationManager = CLLocationManager()
    
    //API call constants
    let APIKey = "API_KEY"
    let baseURL = "https://api.openweathermap.org/data/3.0/onecall?"
    let airQualitybaseURL = "https://api.openweathermap.org/data/2.5/air_pollution?"
    
    private let geocoder = CLGeocoder()
    
    override init(){
        super.init()
        loadFavoriteCities()
        checkLocationAuthorization()
    }
    
    func saveFavoriteCities() {
        do{
            let encoded = try JSONEncoder().encode(favouriteCities)
            UserDefaults.standard.set(encoded, forKey: "FavoriteCities")
        }catch{
            print("Error encodeing favorite cities data: \(error)")
        }
    }
    
    func loadFavoriteCities() {
        guard let savedCities = UserDefaults.standard.data(forKey: "FavoriteCities") else {return favouriteCities = []}
        
        do{
            let decoded = try JSONDecoder().decode([FavouriteCity].self, from: savedCities)
            favouriteCities = decoded
        }catch{
            print("Error decoding and loading favorite citites: \(error)")
        }
    }
    
    func checkLocationAuthorization() {
        print("checkLocationAuthorization called")
        funcLocationManager.delegate = self
        funcLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        funcLocationManager.startUpdatingLocation()
        
        switch funcLocationManager.authorizationStatus {
        case .notDetermined:
            funcLocationManager.requestWhenInUseAuthorization()
        case .restricted:
            print("User location access restricted")
        case .denied:
            print("Location access denied")
        case .authorizedAlways, .authorizedWhenInUse:
            if let location = funcLocationManager.location {
                currentUserLocation = location.coordinate
                isLocationAccessGranted = true
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return } // Safely unwrap self
                    self.currentUserLocation = location.coordinate
                    self.isLocationAccessGranted = true
                }
                Task {
                    await getCityWeatherFromAPI(coordinate: currentUserLocation!)
                }
                print("Location authorized: \(location.coordinate)")
            } else {
                print("Location not available yet")
            }
        @unknown default:
            print("Unknown authorization status")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentUserLocation = location.coordinate
        isLocationAccessGranted = true
        print("Location updated: \(location.coordinate)")
        currentUserLocation = location.coordinate
        isLocationAccessGranted = true
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return } // Safely unwrap self
            self.currentUserLocation = location.coordinate
            self.isLocationAccessGranted = true
        }
        Task {
            await getCityWeatherFromAPI(coordinate: currentUserLocation!)
        }
        print("Location authorized: \(location.coordinate)")
        funcLocationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to update location: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            funcLocationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("Location access denied or restricted")
        case .notDetermined:
            print("Waiting for user to grant location access")
        @unknown default:
            print("Unknown authorization status")
        }
    }
    
    func getCoordinateFrom(address: String, completion: @escaping (Bool) -> Void) {
        geocoder.geocodeAddressString(address) { [weak self] placemarks, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.geocodingError = error
                    self?.coordinate = nil
                    self?.locationSearchSuccess = false
                    completion(false)
                } else if let coordinate = placemarks?.first?.location?.coordinate, let name = placemarks?.first?.name{
                    self?.coordinate = coordinate
                    self?.locationName = name
                    Task {
                        await self!.getCityWeatherFromAPI(coordinate: coordinate)
                    }
                    self?.geocodingError = nil
                    self?.locationSearchSuccess = true
                    completion(true)
                }
            }
        }
    }
    
    func getLocationNameFrom(coordinate: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error during reverse geocoding: \(error.localizedDescription)")
                    self?.geocodingError = error
                    self?.locationName = nil
                } else if let placemark = placemarks?.first {
                    if let city = placemark.locality, let state = placemark.administrativeArea {
                        self?.locationName = "\(city), \(state)"
                        print("Location Name: \(self?.locationName ?? "Unknown")")
                    } else if let city = placemark.locality {
                        self?.locationName = city // Fallback to just the city
                        print("Location Name: \(city)")
                    } else {
                        print("No locality or administrative area found")
                        self?.locationName = self?.locationName
                    }
                    self?.geocodingError = nil
                } else {
                    print("No placemarks found")
                    self?.locationName = self?.locationName
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
                self?.dailyWeatherData = decodedResponse.daily
                self?.hourlyWeatherData = decodedResponse.hourly
                self?.timeZoneOffset = decodedResponse.timezone_offset
                self?.locationSearchSuccess = true
            }
            getLocationNameFrom(coordinate: coordinate)
            
            Task {
                await self.getCityAirQuality(coordinate: coordinate)
            }
        } catch let decodingError as DecodingError {
            // Print detailed decoding error for debugging
            print("Decoding error: \(decodingError)")
        } catch {
            // Handle other errors (networking, etc.)
            print("Error fetching or decoding weather data: \(error.localizedDescription)")
        }
    }
    
    func getCityAirQuality(coordinate: CLLocationCoordinate2D) async{
        guard let apiUrl = URL(string: "\(airQualitybaseURL)lat=\(coordinate.latitude)&lon=\(coordinate.longitude)&appid=\(APIKey)") else {
            print("URL is not valid!")
            return
        }
        do {
            // Fetch data from the API
            let (data, _) = try await URLSession.shared.data(from: apiUrl)
            let decodedResponse = try JSONDecoder().decode(AirQualityResponse.self, from: data)
            // Update the published property on the main thread
            DispatchQueue.main.async { [weak self] in
                self?.airQualityData = decodedResponse
            }
        } catch let decodingError as DecodingError {
            print("Decoding error: \(decodingError)")
        } catch {
            print("Error fetching or decoding weather data: \(error.localizedDescription)")
        }
    }
}
