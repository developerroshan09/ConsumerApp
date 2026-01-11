import SwiftUI
import KmmFirebaseAuth

struct RootView: View {

    @StateObject private var viewModel = AuthViewModel()

    var body: some View {
        switch viewModel.authState {
        case is AuthState.LoggedOut:
            LoginView(viewModel: viewModel)

        case let loggedIn as AuthState.LoggedIn:
            HomeView(
                email: loggedIn.user.email ?? "Anonymous",
                onLogout: {
                    Task {
                        await viewModel.logout()
                    }
                }
            )

        default:
            EmptyView()
        }
    }
}
