import Foundation

enum AuthUIError: Identifiable {
    case userNotFound
    case wrongPassword
    case invalidEmail
    case emailAlreadyInUse
    case network
    case unknown(String)

    var id: String { message }

    var message: String {
        switch self {
        case .userNotFound:
            return "No account found with this email."
        case .wrongPassword:
            return "Incorrect password."
        case .invalidEmail:
            return "Invalid email address."
        case .emailAlreadyInUse:
            return "Email is already in use."
        case .network:
            return "Network error. Please try again."
        case .unknown(let msg):
            return msg
        }
    }
}
