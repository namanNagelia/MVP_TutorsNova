import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()

        return true
    }
}

class AppViewModel: ObservableObject {
    @Published var isAuthenticated = false
    var appUserInstance: appUser // Declare appUserInstance as a property

    init(appUserInstance: appUser) {
        self.appUserInstance = appUserInstance // Initialize appUserInstance
        // Check if the user is already authenticated
        if let user = Auth.auth().currentUser {
            print("User is already authenticated: \(user.uid)")
            self.isAuthenticated = true
        }
        
        // Fetch user data when the app loads
        appUserInstance.fetchUserData()
    }
}

@main
struct MVP_TutorsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var appUserInstance = appUser() // Initialize appUserInstance

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AppViewModel(appUserInstance: appUserInstance))
            
        }
    }
}
