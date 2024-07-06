import SwiftUI
import LocalAuthentication

struct SignUpView: View {
    @State private var email: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isFaceIDSetup: Bool = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Sign Up")
                .font(.largeTitle)
                .fontWeight(.bold)

            TextField("Email", text: $email)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)

            NavigationLink(destination: ContactView()) {
                Button(action: {
                    if isValidEmail(email) {
                        //setupFaceID()
                    } else {
                        alertMessage = "Please enter a valid email."
                        showAlert = true
                    }
                }) {
                    Text("Sign Up and Set Up Face ID")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }

            Spacer()
        }
        .padding(.horizontal, 40)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Sign Up Failed"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
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
                        isFaceIDSetup = true
                        // Save the email and face ID setup status
                        // Navigate to the main app view or show success message
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
