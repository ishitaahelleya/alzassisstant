import SwiftUI
import LocalAuthentication

struct SignUpView: View {
    @State private var email: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var shouldNavigate: Bool = false
    static var name: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Sign Up")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            TextField("Name", text: Binding(
                        get: { SignUpView.name },
                        set: { SignUpView.name = $0 }
                    ))
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)


            TextField("Email", text: $email)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)

            Button(action: {
                if isValidEmail(email) {
                    shouldNavigate = true
                } else {
                    alertMessage = "Please enter a valid email."
                    showAlert = true
                }
            }) {
                Text("Sign Up")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(8)
            }

            Spacer()

            NavigationLink(destination: ContactView().navigationBarBackButtonHidden(true), isActive: $shouldNavigate) {
                EmptyView()
            }
        }
        .padding(.horizontal, 40)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Sign Up Failed"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .navigationBarBackButtonHidden(true)
    }

    private func isValidEmail(_ email: String) -> Bool {
        // Simple email validation
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }

    private func setupFaceID() {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Set up Face ID for your account"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        shouldNavigate = true
                    } else {
                        alertMessage = authenticationError?.localizedDescription ?? "Failed to set up Face ID"
                        showAlert = true
                    }
                }
            }
        } else {
            alertMessage = "Face ID not available"
            showAlert = true
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
