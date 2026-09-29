import SwiftUI

struct PulseTheme: Identifiable, Codable, Hashable, Sendable {
    struct Background: Codable, Hashable, Sendable {
        enum Style: String, Codable, Sendable {
            case solid
            case gradient
        }

        let type: Style
        let start: String
        let end: String
    }

    struct Card: Codable, Hashable, Sendable {
        let radius: Double
        let opacity: Double
        let borderOpacity: Double
    }

    let id: UUID
    let version: Int
    let name: String
    let author: String
    let background: Background
    let primaryText: String
    let secondaryText: String
    let accentStart: String
    let accentEnd: String
    let card: Card
    let recoveryStyle: String
    let hrvStyle: String
    let watchLayout: String

    var primaryTextColor: Color { Color(hex: primaryText) }
    var secondaryTextColor: Color { Color(hex: secondaryText) }
    var accentColor: Color { Color(hex: accentStart) }
    var accentGradient: LinearGradient {
        LinearGradient(
            colors: [Color(hex: accentStart), Color(hex: accentEnd)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [Color(hex: background.start), Color(hex: background.end)],
            startPoint: .top,
            endPoint: .bottomTrailing
        )
    }

}

extension Color {
    /// 将六位十六进制颜色文本转换为 SwiftUI 颜色。
    init(hex: String) {
        let cleanedHex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        guard cleanedHex.count == 6, let value = UInt64(cleanedHex, radix: 16) else {
            preconditionFailure("主题颜色必须是六位十六进制文本：\(hex)")
        }
        let red = Double((value >> 16) & 0xFF) / 255
        let green = Double((value >> 8) & 0xFF) / 255
        let blue = Double(value & 0xFF) / 255
        self.init(red: red, green: green, blue: blue)
    }
}
