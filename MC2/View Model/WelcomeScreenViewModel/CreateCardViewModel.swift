//
//  CreateCardViewModel.swift
//  Traddy
//
//  Created by Nur Hidayatul Fatihah on 21/08/23.
//

import SwiftUI
import MapKit
import CoreLocation

final class CreateCardViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var searchQuery: String = ""
    @Published var searchResults: [MKMapItem] = []
    @Published var selectedLocation: CLLocationCoordinate2D?
    @Published var date = Date()
    @Published var useCurrentLocation = false
    @Published var isCreatingCard: Bool = false
    @ObservedObject var locationManagerDelegate = LocationManagerDelegate()
    
    func searchLocations() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchQuery
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            if let response = response {
                self.searchResults = response.mapItems
            }
        }
    }
    
    func selectLocation(_ placemark: MKPlacemark) {
        selectedLocation = placemark.coordinate
        searchQuery = formatAddress(placemark)
    }
    
    func formatAddress(_ placemark: MKPlacemark) -> String {
        let addressComponents = [placemark.subThoroughfare, placemark.thoroughfare, placemark.locality, placemark.administrativeArea, placemark.postalCode, placemark.country]
            .compactMap { $0 }
        return addressComponents.joined(separator: ", ")
    }
    
    
    
    func getCoordinateRegion() -> MKCoordinateRegion {
        if let location = locationManagerDelegate.location {
            return MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        }
        return MKCoordinateRegion()
    }
}
