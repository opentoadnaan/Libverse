//
//  SupabaseManager.swift
//  LMS
//
//  Created by ARYAN SINGHAL on 19/03/25.
//

import Foundation
import SwiftUI
import Supabase

struct UserData: Codable {
    let id: UUID
    let fullName: String
    let email: String
    let contactNumber: String
}

// Login credentials model
struct LoginCredentials {
    let email: String
    let password: String
}


import SwiftUI
import Supabase

class SupabaseManager: ObservableObject {
    static let shared = SupabaseManager()
    
    @Published var client: SupabaseClient
    @Published var currentUser: User?
    @Published var currentSession: Session?
    
    private let supabaseURL = URL(string: "https://ghpqzceylrmteqwqbopv.supabase.co")!
    private let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdocHF6Y2V5bHJtdGVxd3Fib3B2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzkxNjYzNzYsImV4cCI6MjA1NDc0MjM3Nn0.duY-f0-9pprTdouAqwPojMbw05PuOW3B5tok3w9zxOA"
    
    private init() {
        self.client = SupabaseClient(
            supabaseURL: supabaseURL,
            supabaseKey: supabaseKey
        )
    }
    
    func signUp(email: String, password: String) async throws -> AuthResponse {
        // Only handle authentication, no extra data storage
        let authResponse = try await client.auth.signUp(email: email, password: password)
        currentUser = authResponse.user
        return authResponse
    }
    
    func signIn(email: String, password: String) async throws -> Session {
            let session = try await client.auth.signIn(email: email, password: password)
            DispatchQueue.main.async {
                self.currentUser = session.user
                self.currentSession = session
            }
            print("User ID: \(session.user.id)")
            return session
    }
    
    func signOut() async throws {
        try await client.auth.signOut()
        currentUser = nil
    }
    
    func verifyOTP(email: String, otp: String, completion: @escaping (Result<Session, Error>) -> Void) {
            Task {
                do {
                    let response = try await client.auth.verifyOTP(email: email, token: otp, type: .email)
                    DispatchQueue.main.async {
                        completion(.success(response.session!))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    
    
//    func saveUser(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
//            Task {
//                do {
//                    let userData: [String: AnyEncodable] = [
//                        "email": AnyEncodable(email),
//                        "password": AnyEncodable(password)
//                    ]
//
//                    try await supabase.database.from("users").insert(userData).execute()
//                    DispatchQueue.main.async {
//                        completion(.success(()))
//                    }
//                } catch {
//                    DispatchQueue.main.async {
//                        completion(.failure(error))
//                    }
//                }
//            }
//        }
    
    func resetPassword(email: String) async throws {
        try await client.auth.resetPasswordForEmail(email)
        print("Password reset email sent to \(email)")
    }
}
