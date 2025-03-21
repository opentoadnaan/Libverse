import SwiftUI
import Supabase

struct ForgotPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var email: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isResetEmailSent: Bool = false
    @State private var showOTPView: Bool = false
    @State private var isLoading: Bool = false
    
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
                    
                    Text("Enter your email address and we'll send you a verification code to reset your password.")
                        .font(.custom("Courier", size: 16))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Email Field
                    customTextField(placeholder: "College Email", text: $email, keyboardType: .emailAddress, autocapitalization: .none)
                    
                    // Reset Password Button
                    Button(action: resetPassword) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Send Verification Code")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(red: 255/255, green: 111/255, blue: 45/255))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(isLoading)
                    
                    // Back to Login Button
                    Button(action: { dismiss() }) {
                        Text("Back to Login")
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
        .sheet(isPresented: $showOTPView) {
            ResetPasswordOTPView(email: email)
        }
    }
    
    // Custom text field with placeholder font and color
    private func customTextField(placeholder: String, text: Binding<String>, keyboardType: UIKeyboardType = .default, autocapitalization: UITextAutocapitalizationType = .words) -> some View {
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
                .autocapitalization(autocapitalization)
                .overlay(
                    RoundedRectangle(cornerRadius: 0)
                        .stroke(Color.black, lineWidth: 1.25)
                )
        }
    }
    
    private func resetPassword() {
        // Validate email domain
        let collegeDomain = "@gmail.com"
        guard email.hasSuffix(collegeDomain) else {
            alertMessage = "Please use your college email address (\(collegeDomain))."
            showAlert = true
            return
        }
        
        // Show loading state
        isLoading = true
        
        // Send OTP email
        Task {
            do {
                print("Attempting to send reset email to: \(email)")
                try await supabaseManager.client.auth.resetPasswordForEmail(email)
                print("Reset email sent successfully")
                alertMessage = "Verification code has been sent to your email."
                showAlert = true
                isResetEmailSent = true
                showOTPView = true
            } catch {
                print("Error sending reset email: \(error)")
                alertMessage = "Error sending verification code: \(error.localizedDescription)"
                showAlert = true
            }
            isLoading = false
        }
    }
}

#Preview {
    ForgotPasswordView()
} 
