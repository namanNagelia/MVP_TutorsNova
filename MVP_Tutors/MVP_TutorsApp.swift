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
    @State private var isAuthenticated = false

    var body: some Scene {
        WindowGroup {
           ContentView()
        }
    }
}







