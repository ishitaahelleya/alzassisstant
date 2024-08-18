import Foundation
import SwiftUI
import UIKit
struct HomeView: View {
    @StateObject private var locationManager = LocationManager()
    @State private var name = SignUpView.name

    var body: some View {
        NavigationView {
            VStack {
                Text("What's up \(name)")
                    .font(.title)
                    .padding(.top, 20)
                
                Spacer(minLength: 20)
                
                Section {
                    VStack {
                        Text("Are you lost?")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                        
                        Button("Help") {
                            sendLocation()
                        }
                        .padding(10)
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.red, lineWidth: 2)
                        )
                        
                        Spacer()
                            .frame(height: 17)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.orange)
                    .cornerRadius(10)
                    .padding(.bottom, 20)
                }
                .padding(30)
                
                Spacer()
                    .frame(height: 360)
            }
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button(action: {
                        // Action for Home button
                    }) {
                        VStack {
                            Image(systemName: "house")
                            Text("Home")
                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        // Action for Medicines button
                    }) {
                        VStack {
                            Image(systemName: "plus")
                            Text("Medicines")
                        }
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: MapView().environmentObject(locationManager)) {  // Pass locationManager to MapView
                        VStack {
                            Image(systemName: "map")
                            Text("Map")
                        }
                    }
                }
            }
            .navigationTitle("Home")
        }
    }
    
    func sendLocation() {
        locationManager.requestLocation()  // Ensure the location is updated

        guard let address = locationManager.address else {
            print("Location not available")
            return
        }
        
        let message = "Help! I am at: \(address)"
        sendMessage(to: ContactView.savedContacts.first?.number ?? "", message: message)
    }
    
    func sendMessage(to phoneNumber: String, message: String) {
        guard let url = URL(string: "sms:\(phoneNumber)&body=\(message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")") else { return }
        UIApplication.shared.open(url)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
