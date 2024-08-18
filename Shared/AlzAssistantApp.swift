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
    @State var usreisPresent = false
    var body: some Scene {
        WindowGroup {
// if uer is preesnt in keychain then don't show login and signup screen
            if (usreisPresent) {
                //show home page
                HomeView()
                    .environmentObject(locationManager)
            }
            else {
                LoginView()
                    .environmentObject(locationManager)
            }
           
        }
    }
}
