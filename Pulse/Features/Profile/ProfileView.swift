import SwiftUI

struct ProfileView: View {
    @Environment(ThemeManager.self) private var themeManager

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    Text("我的")
                        .font(.system(size: 32, weight: .bold, design: .rounded))

                    profileHeader
                    dataPrivacyCard
                    menuSection
                }
                .padding(.horizontal, 18)
                .padding(.top, 12)
                .padding(.bottom, 32)
            }
            .scrollIndicators(.hidden)
            .toolbar(.hidden, for: .navigationBar)
            .themedPage()
        }
    }

    private var profileHeader: some View {
        HStack(spacing: 15) {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 54))
                .foregroundStyle(themeManager.currentTheme.accentGradient)

            VStack(alignment: .leading, spacing: 4) {
                Text("Pulse 用户")
                    .font(.title3.bold())

                Text("本地健康档案")
                    .font(.subheadline)
                    .foregroundStyle(themeManager.currentTheme.secondaryTextColor)
            }

            Spacer()

            Text("免费版")
                .font(.caption.bold())
                .foregroundStyle(themeManager.currentTheme.accentColor)
                .padding(.horizontal, 10)
                .frame(height: 28)
                .background(themeManager.currentTheme.accentColor.opacity(0.14), in: Capsule())
        }
        .padding(18)
        .themedCard()
    }

    private var dataPrivacyCard: some View {
        HStack(alignment: .top, spacing: 13) {
            Image(systemName: "lock.shield.fill")
                .font(.title2)
                .foregroundStyle(themeManager.currentTheme.accentColor)

            VStack(alignment: .leading, spacing: 6) {
                Text("健康数据保留在设备上")
                    .font(.headline)

                Text("Pulse 默认仅在本地处理健康数据，不会上传 HRV、心率、睡眠或其他 HealthKit 原始数据。")
                    .font(.caption)
                    .foregroundStyle(themeManager.currentTheme.secondaryTextColor)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(18)
        .themedCard()
    }

    private var menuSection: some View {
        VStack(spacing: 0) {
            NavigationLink {
                SettingsView()
            } label: {
                menuRow(title: "设置", symbol: "gearshape.fill")
            }

            Divider().overlay(.white.opacity(0.07)).padding(.leading, 52)
            menuRow(title: "隐私说明", symbol: "hand.raised.fill")
            Divider().overlay(.white.opacity(0.07)).padding(.leading, 52)
            menuRow(title: "关于 Pulse", symbol: "info.circle.fill")
        }
        .buttonStyle(.plain)
        .themedCard()
    }

    /// 创建个人页中的菜单行。
    private func menuRow(title: String, symbol: String) -> some View {
        HStack(spacing: 13) {
            Image(systemName: symbol)
                .foregroundStyle(themeManager.currentTheme.accentColor)
                .frame(width: 24)

            Text(title)
                .font(.subheadline.weight(.medium))

            Spacer()

            Image(systemName: "chevron.right")
                .font(.caption.bold())
                .foregroundStyle(themeManager.currentTheme.secondaryTextColor)
        }
        .padding(.horizontal, 18)
        .frame(height: 54)
        .contentShape(Rectangle())
    }
}

#Preview {
    ProfileView()
        .environment(ThemeManager())
        .preferredColorScheme(.dark)
}
