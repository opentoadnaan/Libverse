import SwiftUI

struct OTPVerificationView: View {
    @State private var otp: String = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var navigateToWelcome = false  // Triggers navigation to HomeView

    let email: String
    let password: String  // For saving in Supabase if needed

    var body: some View {
        VStack {
            Text("Enter OTP sent to \(email)")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding()

            TextField("Enter OTP", text: $otp)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()

            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button(action: verifyOTP) {
                Text(isLoading ? "Verifying..." : "Verify OTP")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(isLoading || otp.isEmpty)
            .padding()

            // NavigationLink to HomeView triggered by state change.
            NavigationLink(destination: HomeView(), isActive: $navigateToWelcome) {
                EmptyView()
            }
        }
        .padding()
    }
    
    func verifyOTP() {
        isLoading = true
        errorMessage = nil

        SupabaseManager.shared.verifyOTP(email: email, otp: otp) { result in
            DispatchQueue.main.async {
                isLoading = false
                switch result {
                case .success:
                    print("✅ OTP Verified! Navigating to HomeView...")
                    navigateToWelcome = true  // Triggers the NavigationLink to HomeView
                case .failure(let error):
                    errorMessage = error.localizedDescription
                    print("❌ Error verifying OTP: \(error.localizedDescription)")
                }
            }
        }
    }
}
