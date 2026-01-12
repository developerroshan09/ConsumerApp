//
//  SignpScreen.swift
//  ConsumerApp
//
//  Created by Roshan Bade on 12/01/2026.
//

import SwiftUI

struct SignupScreen: View {
    @State private var email = ""
    @State private var password = ""
    
    @ObservedObject var viewModel: AuthViewModel
    
    let switchToLogin: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            
            Spacer()
            VStack(spacing: 16) {
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
            }
            
            
            LoadingButton(
                title: "Sign Up",
                isLoading: viewModel.isLoading
            ) {
                viewModel.signUp(email: email, password: password)
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
            
            Button("Already have an account?") {
                switchToLogin()
            }
            .font(.footnote)
        }
        .padding()
    }
}
    


