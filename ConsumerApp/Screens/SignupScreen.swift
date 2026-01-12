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
    @State private var showEmailError = false
    @State private var showPasswordError = false
    
    @FocusState private var focusField: Field?
    
    @ObservedObject var viewModel: AuthViewModel
    
    let switchToLogin: () -> Void
    private let minimumPasswordLength = 6

    
    private var isFormValid: Bool {
       email.isValidEmail && password.count >= minimumPasswordLength
   }
    
    var body: some View {
        VStack(spacing: 24) {
            
            Spacer()
            VStack(spacing: 16) {
                Text("Create Account")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                
                FormTextField(
                    title: "Email",
                    text: $email,
                    keyboardType: .emailAddress,
                    showError: showEmailError,
                    errorMessage: "Invalid email address",
                    isSecure: false,
                    minimumLength: nil
                )
                .focused($focusField, equals: .email)
                .submitLabel(.next)
                .onSubmit {
                    focusField = .password
                }
                .onChange(of: email) { value, _ in
                    showEmailError = !value.isValidEmail && !value.isEmpty
                }

                FormTextField(
                    title: "Password",
                    text: $password,
                    keyboardType: .default,
                    showError: showPasswordError,
                    errorMessage: "Password must be at least \(minimumPasswordLength) characters",
                    isSecure: true,
                    minimumLength: minimumPasswordLength
                )
                .focused($focusField, equals: .password)
                .submitLabel(.go)
                .onSubmit {
                    if isFormValid {
                        viewModel.signUp(email: email, password: password)
                        focusField = nil
                    }
                }
                .onChange(of: password) { value, _ in
                    showPasswordError = !value.isEmpty && value.count < minimumPasswordLength
                }
            }
            
            
            LoadingButton(
                title: "Sign Up",
                isLoading: viewModel.isLoading
            ) {
                viewModel.signUp(email: email, password: password)
            }
            .disabled(!isFormValid || viewModel.isLoading)
            .opacity(isFormValid ? 1 : 0.6)

            
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
        .appAlert(message: $viewModel.errorMessage)
        .onTapGesture {
            focusField = nil
        }
    }
}
    


