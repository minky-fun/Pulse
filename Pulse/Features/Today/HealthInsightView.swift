import SwiftUI

struct HealthInsightView: View {
    @Environment(ThemeManager.self) private var themeManager
    let status: String
    let insights: [HealthInsight]

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 10) {
                Image(systemName: "sparkles")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(themeManager.currentTheme.accentGradient)

                Text("为什么今天状态不错？")
                    .font(.headline)
            }

            VStack(alignment: .leading, spacing: 13) {
                ForEach(insights) { insight in
                    HStack(alignment: .top, spacing: 11) {
                        Image(systemName: insight.tone == .positive ? "checkmark.circle.fill" : "circle.dotted")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(
                                insight.tone == .positive
                                    ? themeManager.currentTheme.accentColor
                                    : themeManager.currentTheme.secondaryTextColor
                            )

                        Text(insight.text)
                            .font(.subheadline)
                    }
                }
            }

            Divider()
                .overlay(.white.opacity(0.08))

            VStack(alignment: .leading, spacing: 5) {
                Text("综合来看，你的身体恢复情况较好。")
                    .font(.subheadline.weight(.semibold))

                Text("今天可以保持正常活动节奏。")
                    .font(.subheadline)
                    .foregroundStyle(themeManager.currentTheme.secondaryTextColor)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .themedCard()
    }
}

#Preview {
    HealthInsightView(status: "恢复良好", insights: MockHealthData.today.insights)
        .padding()
        .environment(ThemeManager())
        .preferredColorScheme(.dark)
        .themedPage()
}
