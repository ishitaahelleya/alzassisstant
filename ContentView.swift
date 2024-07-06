import SwiftUI
import LocalAuthentication

struct LoginView: View {
    @State private var isAuthenticated: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @EnvironmentObject var locationManager: LocationManager

    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
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

                NavigationLink(destination: HomeView().navigationBarBackButtonHidden(true)) {
                    Text("Login With Face ID ")
                        .foregroundColor(.blue)
                }
                
                .padding(.top, 20)

                NavigationLink(destination: SignUpView()) {
                    Text("Don't have an account? Sign up")
                        .foregroundColor(.blue)
                }
                .padding(.top, 20)
                
                Spacer()
            }
            .padding(.horizontal, 40)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Authentication Failed"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            
            NavigationLink(destination: HomeView(), isActive: $isAuthenticated) {
                EmptyView()
            }
        }
        .navigationBarHidden(true)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(LocationManager())
    }
}
