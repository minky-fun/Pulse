import SwiftUI

struct ThemeBackgroundModifier: ViewModifier {
    @Environment(ThemeManager.self) private var themeManager

    /// 使用当前主题渲染页面背景和前景色。
    func body(content: Content) -> some View {
        content
            .foregroundStyle(themeManager.currentTheme.primaryTextColor)
            .background(themeManager.currentTheme.backgroundGradient.ignoresSafeArea())
    }
}

struct ThemeCardModifier: ViewModifier {
    @Environment(ThemeManager.self) private var themeManager

    /// 使用当前主题渲染统一卡片外观。
    func body(content: Content) -> some View {
        let theme = themeManager.currentTheme

        content
            .background(
                RoundedRectangle(cornerRadius: theme.card.radius, style: .continuous)
                    .fill(Color(hex: "#11161E").opacity(theme.card.opacity))
                    .overlay {
                        RoundedRectangle(cornerRadius: theme.card.radius, style: .continuous)
                            .stroke(.white.opacity(theme.card.borderOpacity), lineWidth: 1)
                    }
            )
    }
}

extension View {
    /// 将当前主题背景应用到页面。
    func themedPage() -> some View {
        modifier(ThemeBackgroundModifier())
    }

    /// 将当前主题卡片样式应用到内容。
    func themedCard() -> some View {
        modifier(ThemeCardModifier())
    }
}
