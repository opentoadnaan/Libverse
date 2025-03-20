import SwiftUI
import Supabase

struct SignUpView: View {
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var enrollmentNumber: String = ""
    @State private var collegeName: String = ""
    @State private var collegeEmail: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    @State private var isOTPViewPresented: Bool = false // To navigate to OTP validation view
    
    let client = SupabaseClient(
        supabaseURL: URL(string: "https://cdhawptmjahlirkdjqkt.supabase.co")!,
        supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNkaGF3cHRtamFobGlya2RqcWt0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDIyOTM4OTAsImV4cCI6MjA1Nzg2OTg5MH0.gtp_OZQAuevaUSc-zs6QpFxU9oXt-YrX1DDCSOX4FEE"
    )
    
    var body: some View {
        VStack {
            Spacer()
            ScrollView {
                Spacer()
                VStack(spacing: 20) {
                    VStack(spacing: 15) {
                        Text("Create an account")
                            .font(.custom("Courier New", size: 25))
                            .bold()
                            .frame(width: 287, alignment: .center)
                        
                        Text("Join first to access the feature of Libverse")
                            .font(.custom("Courier", size: 16))
                            .frame(width: 350)
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer()
                    
                    // Form Fields
                    Group {
                        HStack(spacing: 15) {
                            customTextField(placeholder: "First Name", text: $firstName)
                            customTextField(placeholder: "Last Name", text: $lastName)
                        }
                        
                        customTextField(placeholder: "Enrollment Number", text: $enrollmentNumber, keyboardType: .numberPad)
                        
                        customTextField(placeholder: "College Name", text: $collegeName)
                        
                        customTextField(placeholder: "College Email", text: $collegeEmail, keyboardType: .emailAddress, autocapitalization: .none)
                        
                        customSecureField(placeholder: "Password", text: $password)
                        
                        customSecureField(placeholder: "Confirm Password", text: $confirmPassword)
                    }
                    
                    // Forgot Password Link
                    HStack {
                        Spacer()
                        Button(action: {}) {
                            Text("Forgot Password")
                                .font(.custom("Courier", size: 16))
                                .foregroundColor(.black)
                                .font(.subheadline)
                        }
                    }
                    
                    Spacer()
                    Button(action: signUp) {
                        Text("Sign Up")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 255/255, green: 111/255, blue: 45/255).edgesIgnoringSafeArea(.all))
                            .foregroundColor(.white)
                    }
                    .alert(isPresented: $showAlert) {
                        Alert(title: Text("Sign Up"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                    
                    // Navigation to LogInView
                    NavigationLink(destination: LogInView().navigationBarBackButtonHidden(true)) {
                        Text("Already a user? Sign In")
                            .font(.custom("Courier", size: 16))
                            .foregroundColor(.black)
                            .font(.subheadline)
                    }
                }
                .padding()
            }
            Spacer()
        }
        .background(Color(red: 255/255, green: 239/255, blue: 210/255).edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $isOTPViewPresented) {
            OTPValidationView(collegeEmail: collegeEmail) {
                // Handle successful OTP verification
                alertMessage = "Email verified successfully!"
                showAlert = true
            }
        }
    }
    
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
    
    private func signUp() {
        // Validate email domain
        let collegeDomain = ".edu.in"
        guard collegeEmail.hasSuffix(collegeDomain) else {
            alertMessage = "Please use your college email address (\(collegeDomain))."
            showAlert = true
            return
        }
        
        // Validate password length
        let minPasswordLength = 8
        guard password.count >= minPasswordLength else {
            alertMessage = "Password must be at least \(minPasswordLength) characters long."
            showAlert = true
            return
        }
        
        // Validate password match
        guard password == confirmPassword else {
            alertMessage = "Passwords do not match."
            showAlert = true
            return
        }
        
        // Validate all fields are filled
        guard !firstName.isEmpty, !lastName.isEmpty, !enrollmentNumber.isEmpty, !collegeName.isEmpty, !collegeEmail.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            alertMessage = "Please fill in all fields."
            showAlert = true
            return
        }
        
        // Send magic link
        Task {
            do {
                try await client.auth.signUp(email: collegeEmail, password: password)
                isOTPViewPresented = true // Navigate to OTPValidationView
            } catch {
                alertMessage = "Error signing up: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }
}
