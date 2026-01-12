//
//  LoginView.swift
//  iosApp
//
//  Created by Roshan Bade on 10/01/2026.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

struct LoginScreen: View {
    
    @ObservedObject var viewModel: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    
    let switchToSignup: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Text("Welcome Back")
                            .font(.largeTitle)
                            .fontWeight(.bold)
            
            VStack(spacing: 16) {
                           TextField("Email", text: $email)
                               .textFieldStyle(.roundedBorder)
                               .keyboardType(.emailAddress)
                               .textInputAutocapitalization(.never)

                           SecureField("Password", text: $password)
                               .textFieldStyle(.roundedBorder)
                       }

            LoadingButton(
                title: "Login",
                isLoading: viewModel.isLoading
            ) {
                viewModel.login(email: email, password: password)
            }
            
            Text("or")
                .foregroundColor(.gray)
            
            GoogleSignInButton(
                isLoading: viewModel.isLoading
            ) {
                Task {
                    do {
                        let idToken = try await startGoogleSignIn()
                        await viewModel.loginWithGoogle(idToken: idToken)
                    } catch {
                        print("Google login failed: \(error)")
                    }
                }
            }
            
            Spacer()
            
            Button("Don't have an account? Sign up") {
                switchToSignup()
            }
            .font(.footnote)
        }
        .padding()
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

