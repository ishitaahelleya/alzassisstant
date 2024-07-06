import SwiftUI
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var location: CLLocation?
    @Published var latitude: Double?
    @Published var longitude: Double?
    private let locationManager = CLLocationManager()
    
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
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error getting location: \(error.localizedDescription)")
    }
}

struct MapView: View {
    @StateObject private var locationManager = LocationManager()
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.7794, longitude: -121.5432), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
    
    var body: some View {
        VStack {
            Text("Minimap")
                .fontWeight(.bold)
                .font(.title)
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
            Text("Latitude: \(locationManager.latitude ?? 0), Longitude: \(locationManager.longitude ?? 0)")
                .padding(.top, 10)
                .font(.title3)
            
            NavigationLink(destination: HomeView()) {
                Text("Send Location To")
                    .padding()
           
            }
            Spacer()
        }
      .navigationBarHidden(true)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
