import Foundation
import SwiftUI
import FirebaseCore
import KmmFirebaseAuth
internal import Combine

@MainActor
final class AuthViewModel: ObservableObject {

    @Published private(set) var authState: AuthState = AuthState.LoggedOut()

    private let authComponent = AuthComponent()
    private var observer: AuthStateObserver?
    
    init() {        
        observer = AuthStateObserver(
            scope: KmmScope().main, flow: authComponent.authState
        ) { [weak self] state in
            self?.authState = state
        }
    }

    func login(email: String, password: String) {
        Task {
            do {
                let user = try await authComponent.loginUseCase.invoke(email: email, password: password)
                print("Login success: \(user.id)")
            } catch {
                print("Login failed: \(error)")
            }
        }
    }

    func signUp(email: String, password: String) {
        Task {
            do {
                let user = try await authComponent.signUpUseCase.invoke(email: email, password: password)
                print("Signup success: \(user.id)")
            } catch {
                print("Signup failed: \(error)")
            }
        }
    }

    func loginWithGoogle(idToken: String) async {
        do {
            let user = try await authComponent.loginWithGoogleUseCase.invoke(idToken: idToken)

            print("✅ Google login success: \(user.id), email: \(user.email ?? "N/A")")
            // authState will automatically update if your KMM _authState Flow is updated

        } catch {
            print("❌ Google login failed: \(error)")
        }
    }

    func logout() async {
        do {
            try await authComponent.logoutUseCase.invoke()
            print("Logout success: ")
        } catch {
            print("Logout failed: \(error)")
        }
    }

    deinit {
        observer?.cancel()
    }
}
