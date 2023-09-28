//
//  MVP_TutorsApp.swift
//  MVP_Tutors
//
//  Created by Naman Nagelia on 9/26/23.
//

import SwiftUI

@main
struct MVP_TutorsApp: App {
    init(){
        UserDefaults.standard.set(false, forKey: "darkModeEnabled")

    }
    var body: some Scene {
        WindowGroup {
            ContentView().accentColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
        }
    }
}
