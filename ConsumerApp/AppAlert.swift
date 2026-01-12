//
//  AppAlert.swift
//  ConsumerApp
//
//  Created by Roshan Bade on 12/01/2026.
//

import Foundation
import SwiftUI

struct AppAlert: ViewModifier {
    @Binding var message: String?

    func body(content: Content) -> some View {
        content.alert(
            "Authentication Error",
            isPresented: Binding(
                get: { message != nil },
                set: { if !$0 { message = nil } }
            ),
            actions: {
                Button("OK", role: .cancel) { }
            },
            message: {
                if let message {
                    Text(message)
                }
            }
        )
    }
}

extension View {
    func appAlert(message: Binding<String?>) -> some View {
        modifier(AppAlert(message: message))
    }
}
