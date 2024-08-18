import SwiftUI

struct LoginView: View {
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isAuthenticated: Bool = false
    @EnvironmentObject var locationManager: LocationManager
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                Spacer()
                HStack {
                    Text("AlzAssistant, your personal assistant")
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(Color(hue: 0.48, saturation: 0.323, brightness: 0.848))
                        .multilineTextAlignment(.center)
                }

                Text("Welcome!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 30)
                Image("AlzLogo2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 150, height: 150)

                NavigationLink(destination: SignUpView()) {
                    Text("Sign up")
                        .foregroundColor(.blue)
                }
                .padding(.top, 20)
                
                NavigationLink(destination: HomeView()) {
                    Text("Log in")
                        .foregroundColor(.blue)
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .padding(.horizontal, 40)
            .onAppear {
                checkIfUserIsSignedUp()
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Authentication Failed"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
        .navigationBarHidden(true)
        .background(
            NavigationLink(
                destination: HomeView(),
                isActive: $isAuthenticated,
                label: { EmptyView() }
            )
        )
    }

    func checkIfUserIsSignedUp() {
        let userSignedUp = UserDefaults.standard.bool(forKey: "isSignedUp")
        if userSignedUp {
            isAuthenticated = true
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(LocationManager())
    }
}
