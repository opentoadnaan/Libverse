import SwiftUI

struct OTPValidationView: View {
    var collegeEmail: String
    var onOTPVerified: () -> Void
    
    @State private var otpCode: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    var body: some View {
        VStack {
            Text("Enter the OTP sent to \(collegeEmail)")
                .font(.custom("Courier New", size: 20))
                .padding()
            
            TextField("OTP", text: $otpCode)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: validateOTP) {
                Text("Verify OTP")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("OTP Verification"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func validateOTP() {
        // Here you would typically validate the OTP code
        // For simplicity, we assume the OTP is valid
        onOTPVerified()
    }
}
