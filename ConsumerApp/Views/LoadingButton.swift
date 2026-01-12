//
//  LoadingButton.swift
//  ConsumerApp
//
//  Created by Roshan Bade on 12/01/2026.
//

import SwiftUI

struct LoadingButton: View {
    let title: String
    let isLoading: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .tint(.white)
                } else {
                    Text(title)
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .background(Color.black)
        .foregroundColor(.white)
        .cornerRadius(12)
        .disabled(isLoading)
        .opacity(isLoading ? 0.7 : 1)
    }
}

