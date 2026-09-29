import SwiftUI

struct SettingsView: View {
    @Environment(ThemeManager.self) private var themeManager
    @State private var backgroundRefreshEnabled = true
    @State private var healthRemindersEnabled = false

    var body: some View {
        Form {
            Section("数据") {
                Toggle("后台刷新", isOn: $backgroundRefreshEnabled)
                Toggle("健康提醒", isOn: $healthRemindersEnabled)
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
    .preferredColorScheme(.dark)
}
