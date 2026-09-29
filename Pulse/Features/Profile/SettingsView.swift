import SwiftUI

struct SettingsView: View {
    @Environment(ThemeManager.self) private var themeManager

    var body: some View {
        Form {
            Section("数据") {
                NavigationLink {
                    HealthDataView()
                } label: {
                    Label("Apple 健康数据", systemImage: "heart.text.square")
                }
            }

            Section("隐私") {
                Label("健康数据仅在本地处理", systemImage: "lock.shield.fill")
                Label("未连接任何云端健康服务", systemImage: "icloud.slash.fill")
            }

            Section("主题") {
                HStack {
                    Text("当前主题")
                    Spacer()
                    Text(themeManager.currentTheme.name)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .scrollContentBackground(.hidden)
        .navigationTitle("设置")
        .navigationBarTitleDisplayMode(.inline)
        .tint(themeManager.currentTheme.accentColor)
        .themedPage()
    }
}

#Preview {
    NavigationStack {
        SettingsView()
    }
    .environment(ThemeManager())
    .environment(HealthKitManager())
    .preferredColorScheme(.dark)
}
