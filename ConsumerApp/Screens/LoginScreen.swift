//
//  LoginView.swift
//  iosApp
//
//  Created by Roshan Bade on 10/01/2026.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn

enum Field: Hashable {
    case email
    case password
}

struct LoginScreen: View {
    
    @ObservedObject var viewModel: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    @State private var showEmailError = false
    @State private var showPasswordError = false
    
    @FocusState private var focusField: Field?
    
    let switchToSignup: () -> Void
    
    private let minimumPasswordLength = 6
    private var isFormValid: Bool {
        email.isValidEmail && password.count >= minimumPasswordLength
    }
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Text("Welcome Back")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(spacing: 16) {
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
                        viewModel.login(email: email, password: password)
                        focusField = nil
                    }
                }
                .onChange(of: password) { value, _ in
                    showPasswordError = !value.isEmpty && value.count < minimumPasswordLength
                }
            }

            LoadingButton(
                title: "Login",
                isLoading: viewModel.isLoading
            ) {
                viewModel.login(email: email, password: password)
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
            
            Button("Don't have an account? Sign up") {
                switchToSignup()
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

