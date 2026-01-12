//
//  PasswordField.swift
//  ConsumerApp
//
//  Created by Roshan Bade on 12/01/2026.
//

import SwiftUI

struct PasswordField: View {
    let title: String
    @Binding var text: String
    let showError: Bool
    let minimumLength: Int

    @State private var isSecure = true

    var body: some View {
        ZStack(alignment: .trailing) {
            // Base field
            Group {
                if isSecure {
                    SecureField(title, text: $text)
                } else {
                    TextField(title, text: $text)
                }
            }
            .textFieldStyle(.roundedBorder)
            .autocapitalization(.none)
            .disableAutocorrection(true)
            
            // Eye toggle inside field
            Button(action: {
                withAnimation(.easeInOut(duration: 0.15)) {
                    isSecure.toggle()
                }
            }) {
                Image(systemName: isSecure ? "eye.slash" : "eye")
                    .foregroundColor(.gray)
            }
            .padding(.trailing, 12) // keeps it inside the field
            .accessibilityLabel(isSecure ? "Show password" : "Hide password")
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(showError ? Color.red : Color.clear)
        )
    }
}
