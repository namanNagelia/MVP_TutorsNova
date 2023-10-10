//
//  MVP_TutorsApp.swift
//  MVP_Tutors
//
//  Created by Naman Nagelia on 9/26/23.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}



@main
struct MVP_TutorsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("isAuthenticated") private var isAuthenticated = false // Store authentication state

    var body: some Scene {
        WindowGroup {
            if isAuthenticated {
                ContentView()
            } else {
                AuthView(isAuthenticated: $isAuthenticated)
            }
        }
    }

    init() {
        // Initialize isAuthenticated to false if it's not set
        if UserDefaults.standard.value(forKey: "isAuthenticated") == nil {
            isAuthenticated = false
        }
    }
}





