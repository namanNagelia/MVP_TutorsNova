//
//  MVP_TutorsApp.swift
//  MVP_Tutors
//
//  Created by Naman Nagelia on 9/26/23.
//

import SwiftUI
import FirebaseCore
@main

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}
struct MVP_TutorsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark) // Set the preferred color scheme to Dark Mode
        }
    }
}





