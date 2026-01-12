//
//  GoogleSignInButton.swift
//  ConsumerApp
//
//  Created by Roshan Bade on 12/01/2026.
//

import Foundation
import SwiftUI

struct GoogleSignInButton: View {
    let isLoading: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                if isLoading {
                    ProgressView()
                } else {
                    Image("google_icon")
                        .resizable()
                        .frame(width: 20, height: 20)

                    Text("Continue with Google")
                        .fontWeight(.medium)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3))
            )
        }
        .disabled(isLoading)
        .opacity(isLoading ? 0.7 : 1)
    }
}


