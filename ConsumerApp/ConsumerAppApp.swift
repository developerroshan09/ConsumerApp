//
//  ConsumerAppApp.swift
//  ConsumerApp
//
//  Created by Roshan Bade on 11/01/2026.
//

import SwiftUI
import KmmFirebaseAuth
import FirebaseCore
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // Ensure this is called once and ONLY here
        AuthComponent().configure()
        if let clientID = FirebaseApp.app()?.options.clientID {
                  GIDSignIn.sharedInstance.configuration =
                      GIDConfiguration(clientID: clientID)
            print("gid shared")
              }
        return true
    }
    

    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

        print(" url scheme: \(Bundle.main.object(forInfoDictionaryKey: "CFBundleURLTypes") ?? "NO URL TYPES")")

        return GIDSignIn.sharedInstance.handle(url)
    }

}

@main
struct ConsumerAppApp: App {
    // This adaptor is the modern standard for 2026 KMP projects
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
