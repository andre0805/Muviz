//
//  DRUMRE_LAB1App.swift
//  DRUMRE LAB1
//
//  Andre Flego
//

import SwiftUI
import FacebookCore
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        Logger.setup()
        FirebaseApp.configure()

        return ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
    }
}

@main
struct DRUMRE_LAB1App: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject var sessionManager = SessionManager.shared
    @StateObject var database = Database.shared

    var body: some Scene {
        WindowGroup {
            RootView {
                RootViewModel(sessionManager: sessionManager, database: database)
            }
            .preferredColorScheme(.light)
            .environmentObject(sessionManager)
            .environmentObject(database)
            .onOpenURL { url in
                ApplicationDelegate.shared.application(
                    UIApplication.shared,
                    open: url
                )
            }
        }
    }
}
