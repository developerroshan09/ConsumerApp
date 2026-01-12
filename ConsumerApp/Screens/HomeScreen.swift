//
//  HomeView.swift
//  iosApp
//
//  Created by Roshan Bade on 10/01/2026.
//

import SwiftUI

struct HomeScreen: View {
    let email: String
    let onLogout: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Welcome")
                .font(.largeTitle)
            
            Text(email)
                .foregroundColor(.gray)
            
            Button("Logout", action: onLogout)
        }
    }
}
