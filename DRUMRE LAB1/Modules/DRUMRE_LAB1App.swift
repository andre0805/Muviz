//
//  DRUMRE_LAB1App.swift
//  DRUMRE LAB1
//
//  Andre Flego
//

import SwiftUI
import FacebookCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        Logger.setup()

        return ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
    }
}

@main
struct DRUMRE_LAB1App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject var moviesApi = MoviesAPI.shared
    @StateObject var sessionManager = SessionManager.shared
    @StateObject var fbLoginManager = FBLoginManager.shared

    var body: some Scene {
        WindowGroup {
            RootView {
                RootViewModel(
                    moviesApi: moviesApi,
                    sessionManager: sessionManager,
                    fbLoginManager: fbLoginManager
                )
            }
            .preferredColorScheme(.light)
            .environmentObject(moviesApi)
            .environmentObject(sessionManager)
            .environmentObject(fbLoginManager)
            .onOpenURL { url in
                ApplicationDelegate.shared.application(
                    UIApplication.shared,
                    open: url
                )
            }
        }
    }
}
