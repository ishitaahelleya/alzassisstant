import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Welcome to Home") // Example content
                    .navigationTitle("Home") // Set navigation title
            }
            .ignoresSafeArea(.container, edges: .top) // Ignore safe area at top
            .offset(y: -60) // Move content up by 44 points (default nav bar height)
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

                    NavigationLink(destination: MapView()) {
                        VStack {
                            Image(systemName: "map")
                            Text("Map")
                        }
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
