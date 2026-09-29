import SwiftUI

struct RootTabView: View {
    @Environment(ThemeManager.self) private var themeManager

    var body: some View {
        TabView {
            TodayView(snapshot: MockHealthData.today)
                .tabItem {
                    Label("今天", systemImage: "heart.text.clipboard")
                }

            TrendsView()
                .tabItem {
                    Label("趋势", systemImage: "chart.xyaxis.line")
                }

            SleepView()
                .tabItem {
                    Label("睡眠", systemImage: "moon.stars.fill")
                }

            ThemeStoreView()
                .tabItem {
                    Label("主题", systemImage: "paintpalette.fill")
                }

            ProfileView()
                .tabItem {
                    Label("我的", systemImage: "person.crop.circle.fill")
                }
        }
        .tint(themeManager.currentTheme.accentColor)
    }
}

#Preview {
    RootTabView()
        .environment(ThemeManager())
        .environment(HealthKitManager())
        .preferredColorScheme(.dark)
}
