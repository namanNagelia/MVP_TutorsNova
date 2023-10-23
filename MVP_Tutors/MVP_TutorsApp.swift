import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        return true
    }
}

class AppViewModel: ObservableObject {
    @Published var isAuthenticated = false

    init() {
        // Check UserDefaults for the initial value of isAuthenticated
        if let storedIsAuthenticated = UserDefaults.standard.value(forKey: "isAuthenticated") as? Bool {
            self.isAuthenticated = storedIsAuthenticated
        }
    }
}

@main
struct MVP_TutorsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var appViewModel = AppViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appViewModel) 
        }
    }
}
