import Foundation
import SwiftUI
import FirebaseCore
import KmmFirebaseAuth
internal import Combine

@MainActor
final class AuthViewModel: ObservableObject {

    @Published private(set) var authState: AuthState = AuthState.LoggedOut()
    @Published var isLoading = false

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
        withAnimation(.easeInOut) {
            isLoading = true
        }

        Task {
            defer {
                withAnimation(.easeInOut) {
                    isLoading = false
                }
            }
            
            let result = try await authComponent.loginUseCase.invokeWrapper(email: email, password: password)
            switch result {
            case let success as UserResult.Success:
                let user = success.user
                print("Login success: \(user.id)")
            case let failure as UserResult.Failure:
                print("Login failed: \(failure.error.message ?? "UNKNOWN")")
            default:
                break
            }
        }
    }
    

    func signUp(email: String, password: String) {
        withAnimation(.easeInOut) {
            isLoading = true
        }

        Task {
            defer {
                withAnimation(.easeInOut) {
                    isLoading = false
                }
            }
            
            let result = try await authComponent.signUpUseCase.invokeWrapper(email: email, password: password)
            switch result {
            case let result as UserResult.Success:
                let user = result.user
                print("Signup success: \(user.id)")
            case let failure as UserResult.Failure:
                print("Signup failed: \(failure.error.message ?? "UNKNOWN")")
            default:
                break;
            }
        }
    }

    func loginWithGoogle(idToken: String) async {
        withAnimation(.easeInOut) {
            isLoading = true
        }

        Task {
            defer {
                withAnimation(.easeInOut) {
                    isLoading = false
                }
            }
            
            let result = try await authComponent.loginWithGoogleUseCase.invokeWrapper(idToken: idToken)
            switch result {
            case let success as UserResult.Success:
                let user = success.user
                print("✅ Google login success: \(user), email: \(user.email ?? "UNKNOWN")")
            case let failure as UserResult.Failure:
                print("❌Google login failed: \(failure.error.message ?? "UNKNOWN")")
            default:
                break
            }
        }
    }

    func logout() async {
        withAnimation(.easeInOut) {
            isLoading = true
        }

        Task {
            defer {
                withAnimation(.easeInOut) {
                    isLoading = false
                }
            }
            
            let result =  try await authComponent.logoutUseCase.invokeWrapper()
            switch result {
            case let _ as LogoutResult.Success:
                print("Logout success: ")
            case let failure as LogoutResult.Failure:
                print("Logout failed: \(failure.error.message ?? "UNKNOWN")")
            default:
                break
            }
        }
    }

    deinit {
        observer?.cancel()
    }
}
