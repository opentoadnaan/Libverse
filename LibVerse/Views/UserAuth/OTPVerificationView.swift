import SwiftUI
import Supabase

struct OTPVerificationView: View {
    let email: String
    let password: String
    @State private var otp: String = ""
    @State private var isLoading: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isLoggedIn: Bool = false
    
    let client = SupabaseClient(
        supabaseURL: URL(string: "https://cdhawptmjahlirkdjqkt.supabase.co")!,
        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNkaGF3cHRtamFobGlya2RqcWt0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDIyOTM4OTAsImV4cCI6MjA1Nzg2OTg5MH0.gtp_OZQAuevaUSc-zs6QpFxU9oXt-YrX1DDCSOX4FEE"
    )
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            Image("Logo")
                .resizable()
                .frame(width: 120, height: 120)
                .foregroundColor(Color(red: 255/255, green: 111/255, blue: 45/255))
            
            VStack(spacing: 15) {
                Text("Verify Your Email")
                    .font(.custom("Courier New", size: 25))
                    .bold()
                    .multilineTextAlignment(.center)
                
                Text("Please enter the verification code sent to your email")
                    .font(.custom("Courier", size: 16))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            
            // OTP Input Field
            customTextField(placeholder: "Enter OTP", text: $otp, keyboardType: .numberPad)
                .onChange(of: otp) { newValue in
                    // Limit to 6 digits
                    if newValue.count > 6 {
                        otp = String(newValue.prefix(6))
                    }
                    // Remove non-numeric characters
                    otp = newValue.filter { $0.isNumber }
                }
            
            // Verify Button
            Button(action: verifyOTP) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Verify OTP")
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color(red: 255/255, green: 111/255, blue: 45/255))
            .foregroundColor(.white)
            .cornerRadius(10)
            .disabled(isLoading || otp.count != 6)
            
            // Resend OTP Button
            Button(action: resendOTP) {
                Text("Resend OTP")
                    .font(.custom("Courier", size: 16))
                    .foregroundColor(.black)
            }
            .disabled(isLoading)
        }
        .padding()
        .background(Color(red: 255/255, green: 239/255, blue: 210/255).edgesIgnoringSafeArea(.all))
        .navigationDestination(isPresented: $isLoggedIn) {
            HomeView()
        }
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
    
    private func verifyOTP() {
        isLoading = true
        
        Task {
            do {
                // First verify the OTP
                let response = try await client.auth.verifyOTP(
                    email: email,
                    token: otp,
                    type: .email
                )
                
                // If OTP is verified, sign in with password
                let authResponse = try await client.auth.signIn(
                    email: email,
                    password: password
                )
                
                await MainActor.run {
                    isLoading = false
                    isLoggedIn = true
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    alertMessage = "Invalid OTP or verification failed: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
    }
    
    private func resendOTP() {
        isLoading = true
        
        Task {
            do {
                try await client.auth.signInWithOTP(
                    email: email
                )
                await MainActor.run {
                    isLoading = false
                    alertMessage = "New OTP has been sent to your email"
                    showAlert = true
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    alertMessage = "Error sending OTP: \(error.localizedDescription)"
                    showAlert = true
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        OTPVerificationView(email: "test@example.com", password: "password")
    }
}
