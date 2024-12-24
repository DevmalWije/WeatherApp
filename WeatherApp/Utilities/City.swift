//
//  City.swift
//  WeatherApp
//
//  Created by Devmal Wijesinghe on 2024-12-24.
//


import Foundation
import MapKit

enum City: Identifiable, CaseIterable {
    case newYork
    case london
    case tokyo
    case paris
    case sydney
    case dubai
    case singapore
    case rome
    
    var id: Self { self }
    
    var coordinates: CLLocationCoordinate2D {
        switch self {
        case .newYork:
            return CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060)
        case .london:
            return CLLocationCoordinate2D(latitude: 51.5074, longitude: -0.1278)
        case .tokyo:
            return CLLocationCoordinate2D(latitude: 35.6762, longitude: 139.6503)
        case .paris:
            return CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522)
        case .sydney:
            return CLLocationCoordinate2D(latitude: -33.8688, longitude: 151.2093)
        case .dubai:
            return CLLocationCoordinate2D(latitude: 25.2048, longitude: 55.2708)
        case .singapore:
            return CLLocationCoordinate2D(latitude: 1.3521, longitude: 103.8198)
        case .rome:
            return CLLocationCoordinate2D(latitude: 41.9028, longitude: 12.4964)
        }
    }
    
    var name: String {
        switch self {
        case .newYork:
            return "New York"
        case .london:
            return "London"
        case .tokyo:
            return "Tokyo"
        case .paris:
            return "Paris"
        case .sydney:
            return "Sydney"
        case .dubai:
            return "Dubai"
        case .singapore:
            return "Singapore"
        case .rome:
            return "Rome"
        }
    }
}

