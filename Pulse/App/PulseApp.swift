import SwiftUI

@main
struct PulseApp: App {
    @State private var themeManager = ThemeManager()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environment(themeManager)
                .preferredColorScheme(.dark)
        }
    }
}
