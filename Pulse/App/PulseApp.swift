import SwiftUI

@main
struct PulseApp: App {
    @State private var themeManager = ThemeManager()
    @State private var healthKitManager = HealthKitManager()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environment(themeManager)
                .environment(healthKitManager)
                .preferredColorScheme(.dark)
        }
    }
}
