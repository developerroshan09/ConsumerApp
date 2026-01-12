//
//  AuthError+UI.swift
//  ConsumerApp
//
//  Created by Roshan Bade on 12/01/2026.
//

import Foundation
import KmmFirebaseAuth

extension AuthError {
    func toUIError() -> AuthUIError {
        switch code {
        case .userNotFound:
            return .userNotFound

        case .wrongPassword:
            return .wrongPassword

        case .invalidEmail:
            return .invalidEmail

        case .emailAlreadyInUse:
            return .emailAlreadyInUse

        case .networkError:
            return .network

        default:
            return .unknown(message ?? "Unknown error")
        }
    }
}
