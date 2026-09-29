import SwiftUI

struct RecoveryRingView: View {
    @Environment(ThemeManager.self) private var themeManager
    @State private var animatedProgress = 0.0
    @State private var displayedScore = 0

    let score: Int
    let status: String
    let percentile: Int

    var body: some View {
        VStack(spacing: 22) {
            ZStack {
                Circle()
                    .stroke(.white.opacity(0.07), lineWidth: 18)

                Circle()
                    .trim(from: 0, to: animatedProgress)
                    .stroke(
                        themeManager.currentTheme.accentGradient,
                        style: StrokeStyle(lineWidth: 18, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .shadow(color: themeManager.currentTheme.accentColor.opacity(0.34), radius: 16)

                Circle()
                    .fill(.white.opacity(0.025))
                    .padding(28)

                VStack(spacing: 4) {
                    Text("\(displayedScore)")
                        .font(.system(size: 70, weight: .bold, design: .rounded))
                        .contentTransition(.numericText())

                    Text(status)
                        .font(.headline)
                        .foregroundStyle(themeManager.currentTheme.accentGradient)
                }
            }
            .frame(width: 236, height: 236)

            VStack(spacing: 6) {
                Text("今日恢复指数")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(themeManager.currentTheme.secondaryTextColor)
                    .textCase(.uppercase)

                Text("你的身体状态高于最近 30 天的 \(percentile)% 天数")
                    .font(.subheadline.weight(.medium))
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear(perform: animateScore)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("今日恢复指数 \(score)，\(status)")
    }

    /// 启动恢复圆环和分数的进入动画。
    private func animateScore() {
        withAnimation(.easeOut(duration: 0.8)) {
            animatedProgress = min(max(Double(score) / 100, 0), 1)
            displayedScore = score
        }
    }
}

#Preview {
    RecoveryRingView(score: 82, status: "恢复良好", percentile: 63)
        .padding()
        .environment(ThemeManager())
        .preferredColorScheme(.dark)
        .themedPage()
}
