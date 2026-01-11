//
//  LoginView.swift
//  iosApp
//
//  Created by Roshan Bade on 10/01/2026.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

struct LoginView: View {
    
    let viewModel: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(.roundedBorder)

            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)

            Button("Login") {
                viewModel.login(email: email, password: password)
            }

            Button("Sign Up") {
                viewModel.signUp(email: email, password: password)
            }
            
            Button("Login with Google") {
                    Task {
                        do {
                            let idToken = try await startGoogleSignIn()
                            await viewModel.loginWithGoogle(idToken: idToken)
                        } catch {
                            print("Google login failed: \(error)")
                        }
                    }
                }
        }
    }
}


func startGoogleSignIn() async throws -> String {

    guard let presentingVC =
            await UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .first?.rootViewController else {

        throw NSError(
            domain: "GoogleSignIn",
            code: -1,
            userInfo: [NSLocalizedDescriptionKey: "No presenting view controller"]
        )
    }

    // ✅ Correct call for GoogleSignIn 7.x
    let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC)

    guard let idToken = result.user.idToken?.tokenString else {
        throw NSError(
            domain: "GoogleSignIn",
            code: -1,
            userInfo: [NSLocalizedDescriptionKey: "No ID token returned"]
        )
    }

    return idToken
}

