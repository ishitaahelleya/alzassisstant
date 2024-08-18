import SwiftUI
import MapKit
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var location: CLLocation?
    @Published var latitude: Double?
    @Published var longitude: Double?
    @Published var address: String?
    private let locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func requestLocation() {
        locationManager.requestLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.location = location
            self.latitude = location.coordinate.latitude
            self.longitude = location.coordinate.longitude

            geocoder.reverseGeocodeLocation(location) { placemarks, error in
                if let error = error {
                    print("Error reverse geocoding location: \(error.localizedDescription)")
                    return
                }

                if let placemark = placemarks?.first {
                    self.address = self.formatAddress(from: placemark)
                }
            }
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location: \(error.localizedDescription)")
    }

    private func formatAddress(from placemark: CLPlacemark) -> String {
        var address = ""

        if let street = placemark.thoroughfare {
            address += street
        }

        if let city = placemark.locality {
            address += ", \(city)"
        }

        if let state = placemark.administrativeArea {
            address += ", \(state)"
        }

        if let zip = placemark.postalCode {
            address += " \(zip)"
        }

        return address
    }
}

struct MapView: View {
    @StateObject private var locationManager = LocationManager()
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7794, longitude: -121.5432), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    let firstContactName = ContactView.savedContacts.first?.name ?? "No contacts available"
    let firstContactNumber = ContactView.savedContacts.first?.number ?? "No number available"
    
    var message: String {
        if let address = locationManager.address {
            return "Location: \(address)"
        } else {
            guard let latitude = locationManager.latitude, let longitude = locationManager.longitude else {
                return "Location not available"
            }
            return "Latitude: \(latitude), Longitude: \(longitude)"
        }
    }
    
    @State private var isPressed = false
    
    var body: some View {
        VStack {
            Map(coordinateRegion: $region, showsUserLocation: true)
                .frame(width: 350, height: 400)
                .onAppear {
                    locationManager.requestLocation()
                }
                .onChange(of: locationManager.location) { newLocation in
                    if let newLocation = newLocation {
                        region = MKCoordinateRegion(center: newLocation.coordinate,
                                                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                    }
                }
                .padding(.top, 10)
                .padding(.top, 10)
                .font(.title3)
            
            Text("Send To")
                .font(.title2)
                .padding(.top, 20)
            
            ForEach(Array(ContactView.savedContacts.prefix(3).enumerated()), id: \.offset) { _, contact in
                            Button(action: {
                                sendMessage(to: contact.number)
                                isPressed = false
                            }, label: { Text("\(contact.name)")
                            })
                            .padding()
                            .background(Color.blue.opacity(0.7))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .scaleEffect(isPressed ? 1.2 : 1)
                            .animation(.easeOut(duration: 0.2), value: isPressed)
                            .simultaneousGesture(DragGesture(minimumDistance: 0).onChanged({ _ in
                                isPressed = true
                            }).onEnded({ _ in
                                isPressed = false
                            }))
                        }
            
            Spacer()
        }
    }
    func sendMessage(to phoneNumber: String) {
        guard let url = URL(string: "sms:\(phoneNumber)") else { return }
        guard let message = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let smsURL = URL(string: "\(url.absoluteString)&body=\(message)")
        
        if let url = smsURL {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
