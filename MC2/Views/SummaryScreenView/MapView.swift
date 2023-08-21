import SwiftUI
import MapKit
import CoreLocation
import UserNotifications
import WatchConnectivity

struct ContentView: View {
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @State private var isMonitoringLocation = false
    
    var body: some View {
        VStack {
            MapView(selectedCoordinate: $selectedCoordinate)
                .frame(height: 300)
                .onAppear {
                    isMonitoringLocation = true
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
