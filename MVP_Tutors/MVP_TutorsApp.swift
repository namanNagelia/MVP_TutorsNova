//
//  MVP_TutorsApp.swift
//  MVP_Tutors
//
//  Created by Naman Nagelia on 9/26/23.
//

import SwiftUI
import FirebaseCore
import Combine

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

class AppViewModel: ObservableObject {
    @Published var isAuthenticated = false
}



@main
struct MVP_TutorsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appViewModel = AppViewModel()

    var body: some Scene {
        WindowGroup {
            if appViewModel.isAuthenticated {
                ContentView()
            } else {
                AuthView(isAuthenticated: $appViewModel.isAuthenticated)
            }
        }
    }
}


//init() {
// Initialize isAuthenticated to false if it's not set
//if UserDefaults.standard.value(forKey: "isAuthenticated") == nil
    //isAuthenticated = false




