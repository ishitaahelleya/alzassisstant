//
//  AlzAssistantApp.swift
//  Shared
//
//  Created by Ishita App on 6/20/24.
//

import SwiftUI

@main
struct AlzAssistantApp: App {
    @StateObject var locationManager = LocationManager()
    var body: some Scene {
        WindowGroup {
            LoginView()
                .environmentObject(locationManager)
        }
    }
}
