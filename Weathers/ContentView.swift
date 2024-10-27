//
//  ContentView.swift
//  Weathers
//
//  Created by Nic on 10/27/24.
//

import SwiftUI

struct ContentView: View {
    
    // This property wrapper tells SwiftUI that this view owns this instance and to manage and update with observed changes.
    @StateObject private var locationManager: LocationManager = .init()
    // This property wrapper tells SwiftUI that this is a mutable property that belongs to the view itself, and will be used for managing simple pieces of state. It's ideal when you have information that isn't part of a model or data source, but is specific to the view.
    @State private var showSettingsAlert = false
    
    var body: some View {
        VStack {
            if let location = locationManager.userLocation {
                Text("\(location.coordinate.latitude), \(location.coordinate.longitude)")
                    .padding()
            } else {
                Text("Location not available")
                    .padding()
            }
            
            Button(action: {
                if locationManager.authStatus == .denied {
                    showSettingsAlert = true
                } else {
                    locationManager.requestLocation()
                }
            }) {
                Text("Request Location")
            }
            .alert(isPresented: $showSettingsAlert) {
                Alert(title: Text("Location Services Disabled"),
                      message: Text("Please enable location services in Settings"),
                      primaryButton: .default(Text("Settings"),
                                              action: {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }),
                      secondaryButton: .cancel())
            }
        }
    }
}

#Preview {
    ContentView()
}
