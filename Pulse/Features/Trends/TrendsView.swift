import Charts
import SwiftUI

struct TrendsView: View {
    @Environment(ThemeManager.self) private var themeManager
    @State private var selectedRange = "7天"

    private let ranges = ["7天", "30天", "3个月", "6个月", "1年"]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    Text("趋势")
                        .font(.system(size: 32, weight: .bold, design: .rounded))

                    rangePicker
                    recoveryChart
                    summaryGrid
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

    private var rangePicker: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                ForEach(ranges, id: \.self) { range in
                    Button {
                        selectedRange = range
                    } label: {
                        Text(range)
                            .font(.caption.weight(.semibold))
                            .padding(.horizontal, 14)
                            .frame(height: 34)
                            .background(
                                selectedRange == range
                                    ? themeManager.currentTheme.accentColor.opacity(0.2)
                                    : .white.opacity(0.05),
                                in: Capsule()
                            )
                            .foregroundStyle(
                                selectedRange == range
                                    ? themeManager.currentTheme.accentColor
                                    : themeManager.currentTheme.secondaryTextColor
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .scrollIndicators(.hidden)
    }

    private var recoveryChart: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("恢复指数")
                        .font(.headline)

                    Text("近 7 天平均 76")
                        .font(.caption)
                        .foregroundStyle(themeManager.currentTheme.secondaryTextColor)
                }

                Spacer()

                Text("+8%")
                    .font(.subheadline.bold())
                    .foregroundStyle(themeManager.currentTheme.accentColor)
            }

            Chart(MockHealthData.trendPoints) { point in
                AreaMark(
                    x: .value("日期", point.date),
                    y: .value("恢复指数", point.score)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [themeManager.currentTheme.accentColor.opacity(0.32), .clear],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

                LineMark(
                    x: .value("日期", point.date),
                    y: .value("恢复指数", point.score)
                )
                .foregroundStyle(themeManager.currentTheme.accentGradient)
                .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))

                PointMark(
                    x: .value("日期", point.date),
                    y: .value("恢复指数", point.score)
                )
                .foregroundStyle(themeManager.currentTheme.accentColor)
                .symbolSize(point.date.formatted(.dateTime.day()) == Date.now.formatted(.dateTime.day()) ? 54 : 24)
            }
            .chartYScale(domain: 40...100)
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { _ in
                    AxisValueLabel(format: .dateTime.weekday(.narrow))
                        .foregroundStyle(themeManager.currentTheme.secondaryTextColor)
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading, values: [40, 60, 80, 100]) { value in
                    AxisGridLine().foregroundStyle(.white.opacity(0.06))
                    AxisValueLabel {
                        if let score = value.as(Int.self) {
                            Text("\(score)")
                        }
                    }
                    .foregroundStyle(themeManager.currentTheme.secondaryTextColor)
                }
            }
            .frame(height: 220)
        }
        .padding(18)
        .themedCard()
    }

    private var summaryGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            trendSummary(title: "HRV", value: "56 ms", change: "+12%", symbol: "waveform.path.ecg")
            trendSummary(title: "静息心率", value: "58 bpm", change: "-4", symbol: "heart.fill")
            trendSummary(title: "睡眠", value: "7h 36m", change: "+18m", symbol: "moon.fill")
            trendSummary(title: "活动量", value: "8,426", change: "+9%", symbol: "figure.walk")
        }
    }

    /// 创建趋势页的指标摘要卡片。
    private func trendSummary(title: String, value: String, change: String, symbol: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: symbol)
                .foregroundStyle(themeManager.currentTheme.accentColor)

            Text(title)
                .font(.caption)
                .foregroundStyle(themeManager.currentTheme.secondaryTextColor)

            Text(value)
                .font(.title3.bold())
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            Text(change)
                .font(.caption.bold())
                .foregroundStyle(themeManager.currentTheme.accentColor)
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 142, alignment: .topLeading)
        .themedCard()
    }
}

#Preview {
    TrendsView()
        .environment(ThemeManager())
        .preferredColorScheme(.dark)
}
