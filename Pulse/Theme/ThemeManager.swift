import Observation
import SwiftUI

@MainActor
@Observable
final class ThemeManager {
    private(set) var currentTheme: PulseTheme
    let availableThemes: [PulseTheme]

    /// 创建主题管理器并载入内置主题。
    init(themeStore: ThemeStore = ThemeStore()) {
        do {
            let themes = try themeStore.loadBuiltInThemes()
            guard let defaultTheme = themes.first(where: { $0.name == "Pulse Dark" }) else {
                throw ThemeStore.StoreError.missingDefaultTheme
            }

            self.currentTheme = defaultTheme
            self.availableThemes = themes
        } catch {
            preconditionFailure("无法载入内置主题：\(error.localizedDescription)")
        }
    }

    /// 应用指定主题，并以交叉淡入淡出更新界面。
    func apply(_ theme: PulseTheme) {
        withAnimation(.easeInOut(duration: 0.28)) {
            currentTheme = theme
        }
    }
}
