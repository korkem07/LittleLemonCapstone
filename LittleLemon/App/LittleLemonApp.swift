import SwiftUI

@main
struct LittleLemonApp: App {
    @AppStorage("littlelemon.isOnboarded") private var isOnboarded = false

    var body: some Scene {
        WindowGroup {
            Group {
                if isOnboarded {
                    HomeView()
                } else {
                    OnboardingView()
                }
            }
            .tint(LemonTheme.green)
        }
    }
}
