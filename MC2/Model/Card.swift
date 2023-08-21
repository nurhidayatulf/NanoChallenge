//
//  Card.swift
//  Traddy
//
//  Created by Nur Hidayatul Fatihah on 21/08/23.
//

import SwiftUI
import MapKit

struct Card: Identifiable {
    let id = UUID()
    var text: String
    var location: CLLocationCoordinate2D?
    var imageName: String?
}
