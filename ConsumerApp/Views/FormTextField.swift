//
//  FormTextField.swift
//  ConsumerApp
//
//  Created by Roshan Bade on 12/01/2026.
//

import SwiftUI

import SwiftUI

struct FormTextField: View {
    let title: String
    @Binding var text: String
    let keyboardType: UIKeyboardType
    let showError: Bool
    let errorMessage: String
    let isSecure: Bool // for password fields
    let minimumLength: Int?

    @State private var isSecureField: Bool = true

    var body: some View {
        VStack(spacing: 2) {
            ZStack(alignment: .trailing) {
                if isSecure && isSecureField {
                    SecureField(title, text: $text)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(keyboardType)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                } else {
                    TextField(title, text: $text)
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(keyboardType)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }

                if isSecure {
                    Button {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            isSecureField.toggle()
                        }
                    } label: {
                        Image(systemName: isSecureField ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 12)
                    .accessibilityLabel(isSecureField ? "Show password" : "Hide password")
                }
            }
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(showError ? Color.red : Color.clear)
            )

            if showError {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .transition(.opacity)
            }
        }
    }
}
