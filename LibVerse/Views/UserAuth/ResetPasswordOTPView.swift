import SwiftUI
import Supabase

struct ResetPasswordOTPView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var otp: String = ""
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isPasswordReset: Bool = false
    @State private var isLoading: Bool = false
    
    let email: String
    let supabaseManager = SupabaseManager.shared
    
    var body: some View {
        VStack {
            Spacer()
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    Text("Reset Password")
                        .font(.custom("Courier New", size: 25))
                        .bold()
                        .multilineTextAlignment(.center)
                    
                    Text("Enter the verification code sent to your email and set your new password.")
                        .font(.custom("Courier", size: 16))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // OTP Field
                    customTextField(placeholder: "Enter OTP", text: $otp, keyboardType: .numberPad)
                    
                    // New Password Field
                    customSecureField(placeholder: "New Password", text: $newPassword)
                    
                    // Confirm Password Field
                    customSecureField(placeholder: "Confirm Password", text: $confirmPassword)
                    
                    // Reset Password Button
                    Button(action: verifyOTPAndResetPassword) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Reset Password")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 255/255, green: 111/255, blue: 45/255))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(isLoading)
                    
                    // Back Button
                    Button(action: { dismiss() }) {
                        Text("Back")
                            .font(.custom("Courier", size: 16))
                            .foregroundColor(.black)
                    }
                }
                .padding()
            }
            Spacer()
        }
        .background(Color(red: 255/255, green: 239/255, blue: 210/255).edgesIgnoringSafeArea(.all))
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Message"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // Custom text field with placeholder font and color
    private func customTextField(placeholder: String, text: Binding<String>, keyboardType: UIKeyboardType = .default) -> some View {
        ZStack(alignment: .leading) {
            if text.wrappedValue.isEmpty {
                Text(placeholder)
                    .font(.custom("Courier", size: 16))
                    .foregroundColor(.black)
                    .padding(.leading, 10)
            }
            TextField("", text: text)
                .padding()
                .frame(height: 43)
                .keyboardType(keyboardType)
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(Color.black, lineWidth: 1.25)
                )
        }
    }
    
    // Custom secure field with placeholder font and color
    private func customSecureField(placeholder: String, text: Binding<String>) -> some View {
        ZStack(alignment: .leading) {
            if text.wrappedValue.isEmpty {
                Text(placeholder)
                    .font(.custom("Courier", size: 16))
                    .foregroundColor(.black)
                    .padding(.leading, 10)
            }
            SecureField("", text: text)
                .padding()
                .frame(height: 43)
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(Color.black, lineWidth: 1.25)
                )
        }
    }
    
    private func verifyOTPAndResetPassword() {
        // Validate passwords
        guard newPassword == confirmPassword else {
            alertMessage = "Passwords do not match"
            showAlert = true
            return
        }
        
        guard newPassword.count >= 6 else {
            alertMessage = "Password must be at least 6 characters long"
            showAlert = true
            return
        }
        
        // Show loading state
        isLoading = true
        
        // Verify OTP and reset password
        Task {
            do {
                print("Attempting to verify OTP for email: \(email)")
                // First verify the OTP
                let response = try await supabaseManager.client.auth.verifyOTP(email: email, token: otp, type: .recovery)
                print("OTP verified successfully")
                
                // If OTP is verified, update the password
                print("Attempting to update password")
                try await supabaseManager.client.auth.update(user: UserAttributes(password: newPassword))
                print("Password updated successfully")
                
                alertMessage = "Password has been reset successfully"
                showAlert = true
                isPasswordReset = true
                dismiss()
            } catch {
                print("Error during password reset: \(error)")
                alertMessage = "Error resetting password: \(error.localizedDescription)"
                showAlert = true
            }
            isLoading = false
        }
    }
}

#Preview {
    ResetPasswordOTPView(email: "test@example.com")
} 