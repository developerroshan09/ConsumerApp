//
//  AuthContainerView.swift
//  ConsumerApp
//
//  Created by Roshan Bade on 12/01/2026.
//

import SwiftUI


enum AuthMode {
    case login
    case signup
}

struct AuthContainerView: View {
    @State private var mode: AuthMode = .login
    @ObservedObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            if mode == .login {
                LoginScreen(
                    viewModel: viewModel,
                    switchToSignup: { mode = .signup}
                )
            } else {
                SignupScreen(
                    viewModel: viewModel,
                    switchToLogin: { mode = .login }
                )
            }
        }
    }
}

#Preview {
    AuthContainerView(viewModel: AuthViewModel())
}
