//
//  CreateCardView.swift
//  Traddy
//
//  Created by Hafidz Ismail Hidayat on 11/06/23.
//

import SwiftUI
import MapKit
import CoreLocation

struct CreateCardView: View {
    @StateObject private var viewModelCreateCard = CreateCardViewModel()
    @Binding var isCreatingCard: Bool
    @Binding var cards: [Card]
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Your Trip's Name")
                        .foregroundColor(Color("Text"))
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    TextField("Ex: Trip Malang", text: $viewModelCreateCard.text)
                        .foregroundColor(.black)
                        .background(Color("Field"))
                        .padding(.horizontal)
                        .frame(height: 32)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 0))
                        .background(Color("Field"))
                        .cornerRadius(15)
                        .padding(.top, -10)
                    
                    if viewModelCreateCard.useCurrentLocation {
                        Map(coordinateRegion: .constant(viewModelCreateCard.getCoordinateRegion()), showsUserLocation: true)
                            .frame(height: 200)
                            .cornerRadius(10)
                    } else {
                        Text("Your Start Location")
                            .foregroundColor(Color("Text"))
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        TextField("Location", text: $viewModelCreateCard.searchQuery) { isEditing in
                            if isEditing {
                                viewModelCreateCard.searchResults = []
                            }
                        } onCommit: {
                            viewModelCreateCard.searchLocations()
                        }
                        .foregroundColor(.black)
                        .background(Color("Field"))
                        .padding(.horizontal)
                        .frame(height: 32)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 0))
                        .background(Color("Field"))
                        .cornerRadius(15)
                        .padding(.top, -10)
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: {
                            viewModelCreateCard.useCurrentLocation.toggle()
                        }) {
                            Text(viewModelCreateCard.useCurrentLocation ? "Enter a location" : "Use my current location")
                                .font(.caption)
                                .foregroundColor(Color("Text"))
                        }
                    }
                    .padding(.top, -10)
                    
                    ScrollView(.vertical) {
                        ForEach(viewModelCreateCard.searchResults, id: \.self) { item in
                            Button(action: {
                                viewModelCreateCard.selectLocation(item.placemark)
                            }) {
                                ZStack(alignment: .leading) {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundColor(Color("Field"))
                                    VStack(alignment: .leading) {
                                        Text(item.name ?? "")
                                            .font(.headline)
                                        Text(viewModelCreateCard.formatAddress(item.placemark))
                                            .font(.subheadline)
                                    }
                                    .padding()
                                    .foregroundColor(.black)
                                }
                            }
                        }
                    }
                    
                    RoundedButton(title: "Add Trip", action: {
                        createCard()
                    })
                }
                .padding([.top, .horizontal], 20)
            }
            .padding(.horizontal, 20)
            .background(Color.white)
            .navigationTitle("Create New Trip")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isCreatingCard = false
                    }) {
                        Image(systemName: "x.circle.fill")
                            .foregroundColor(Color(.red))
                    }
                }
            }
        }
        .onAppear {
            viewModelCreateCard.locationManagerDelegate.startUpdatingLocation()
        }
        .onDisappear {
            viewModelCreateCard.locationManagerDelegate.stopUpdatingLocation()
        }
    }
    
    func createCard() {
        let newCard = Card(text: viewModelCreateCard.text, location: viewModelCreateCard.selectedLocation, imageName: getImageName())
        cards.append(newCard)
        isCreatingCard = false
    }
    
    func getImageName() -> String? {
        let imageNames = ["pic3", "pic4", "pic2"]
        
        let index = cards.count % imageNames.count
        return imageNames[index]
    }
}

class LocationManagerDelegate: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        self.location = location
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager error: \(error.localizedDescription)")
    }
}
