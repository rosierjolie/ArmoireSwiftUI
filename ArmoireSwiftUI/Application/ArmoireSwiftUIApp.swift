//
// ArmoireSwiftUIApp.swift
// ArmoireSwiftUI
//
// Created by Geraldine Turcios on 6/12/21
// Copyright © 2021 Geraldine Turcios. All rights reserved.
//

import Firebase
import SwiftUI

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        return true
    }
}

@main
struct ArmoireSwiftUIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    @State private var userIsLoggedIn = false

    private func handleScenePhaseChange(_ newValue: ScenePhase) {
        switch newValue {
        case .active: checkAuthenticatedUser()
        default: break
        }
    }

    private func checkAuthenticatedUser() {
        Auth.auth().addStateDidChangeListener { auth, user in
            if user == nil { userIsLoggedIn = true }
        }
    }

    var body: some Scene {
        WindowGroup {
            if userIsLoggedIn {
                AppTabView()
            } else {
                LoginScreen()
            }
        }
        .onChange(of: scenePhase, perform: handleScenePhaseChange)
    }
}
