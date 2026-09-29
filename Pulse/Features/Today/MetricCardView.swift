import SwiftUI

struct MetricCardView: View {
    @Environment(ThemeManager.self) private var themeManager
    let metric: HealthMetric

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Image(systemName: metric.symbol)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(themeManager.currentTheme.accentGradient)
                    .frame(width: 32, height: 32)
                    .background(themeManager.currentTheme.accentColor.opacity(0.12), in: Circle())

                Spacer()

                HStack(spacing: 3) {
                    if metric.direction != .stable {
                        Image(systemName: metric.direction == .up ? "arrow.up" : "arrow.down")
                            .font(.caption2.bold())
                    }

                    Text(metric.comparison)
                        .font(.caption.bold())
                }
                .foregroundStyle(comparisonColor)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(metric.title)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(themeManager.currentTheme.secondaryTextColor)

                HStack(alignment: .firstTextBaseline, spacing: 5) {
                    Text(metric.value)
                        .font(.system(size: metric.value.count > 5 ? 23 : 30, weight: .bold, design: .rounded))
                        .lineLimit(1)
                        .minimumScaleFactor(0.78)

                    if !metric.unit.isEmpty {
                        Text(metric.unit)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(themeManager.currentTheme.secondaryTextColor)
                            .lineLimit(1)
                    }
                }

                Text(metric.summary)
                    .font(.caption)
                    .foregroundStyle(themeManager.currentTheme.secondaryTextColor)
                    .lineLimit(2)
                    .frame(minHeight: 30, alignment: .topLeading)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 166, alignment: .topLeading)
        .themedCard()
    }

    private var comparisonColor: Color {
        switch metric.direction {
        case .up, .down:
            return themeManager.currentTheme.accentColor
        case .stable:
            return themeManager.currentTheme.secondaryTextColor
        }
    }
}

#Preview {
    MetricCardView(metric: MockHealthData.today.metrics[0])
        .frame(width: 180)
        .padding()
        .environment(ThemeManager())
        .preferredColorScheme(.dark)
        .themedPage()
}
