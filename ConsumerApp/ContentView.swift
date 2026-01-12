//
//  ContentView.swift
//  PackageImpl
//
//  Created by Roshan Bade on 06/01/2026.
//

import SwiftUI
import KmmFirebaseAuth

struct ContentView: View {
    @StateObject private var viewModel = AuthViewModel()
    
    var body: some View {
        switch viewModel.authState {
        case is AuthState.LoggedOut:
            AuthContainerView(viewModel: viewModel)
            
        case let loggedIn as AuthState.LoggedIn:
            HomeScreen(
                email: loggedIn.user.email ?? "Anonymous",
                onLogout: {
                    Task {
                        await viewModel.logout()
                    }
                }, viewModel: viewModel
            )
            
        default:
            EmptyView()
        }
    }
}

#Preview {
    ContentView()
}
