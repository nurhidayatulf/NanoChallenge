//
//  SummaryViewModel.swift
//  Traddy
//
//  Created by Nur Hidayatul Fatihah on 21/08/23.
//

import SwiftUI
import CoreLocation

final class SummaryViewModel: ObservableObject {
    @Published var point: [String] = ["Loc1","Loc2","Loc3"]
    @Published var onMyBodyItemCount = 0
    @Published var myLuggageItemCount = 0
    @Published var MyLuggage = 0
    @Published var selectedCoordinate: CLLocationCoordinate2D? = nil
    @Published var isShowingMapView = false
}
