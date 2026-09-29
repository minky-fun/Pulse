import SwiftUI

struct SleepView: View {
    @Environment(ThemeManager.self) private var themeManager

    private let stages = [
        SleepStage(name: "清醒", duration: "18 分", fraction: 0.04, color: Color(hex: "#F0A45D")),
        SleepStage(name: "REM", duration: "1 小时 42 分", fraction: 0.22, color: Color(hex: "#44C7F4")),
        SleepStage(name: "核心", duration: "4 小时 16 分", fraction: 0.56, color: Color(hex: "#6B78E6")),
        SleepStage(name: "深睡", duration: "1 小时 38 分", fraction: 0.18, color: Color(hex: "#925FD8"))
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    header
                    sleepScore
                    stageCard
                    sleepMetrics
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

    private var header: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text("睡眠")
                .font(.system(size: 32, weight: .bold, design: .rounded))

            Text("昨晚 · 23:16 至 06:52")
                .font(.subheadline)
                .foregroundStyle(themeManager.currentTheme.secondaryTextColor)
        }
    }

    private var sleepScore: some View {
        HStack(spacing: 22) {
            ZStack {
                Circle()
                    .stroke(.white.opacity(0.07), lineWidth: 11)

                Circle()
                    .trim(from: 0, to: 0.86)
                    .stroke(themeManager.currentTheme.accentGradient, style: StrokeStyle(lineWidth: 11, lineCap: .round))
                    .rotationEffect(.degrees(-90))

                Text("86")
                    .font(.system(size: 38, weight: .bold, design: .rounded))
            }
            .frame(width: 116, height: 116)

            VStack(alignment: .leading, spacing: 7) {
                Text("睡眠恢复良好")
                    .font(.title3.bold())

                Text("7 小时 36 分")
                    .font(.headline)
                    .foregroundStyle(themeManager.currentTheme.accentColor)

                Text("睡眠结构稳定，深睡时长高于近 30 天平均水平。")
                    .font(.caption)
                    .foregroundStyle(themeManager.currentTheme.secondaryTextColor)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(18)
        .themedCard()
    }

    private var stageCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            Text("睡眠阶段")
                .font(.headline)

            GeometryReader { geometry in
                HStack(spacing: 3) {
                    ForEach(stages) { stage in
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .fill(stage.color)
                            .frame(width: max(geometry.size.width * stage.fraction - 3, 5))
                    }
                }
            }
            .frame(height: 18)

            VStack(spacing: 12) {
                ForEach(stages) { stage in
                    HStack {
                        Circle()
                            .fill(stage.color)
                            .frame(width: 8, height: 8)

                        Text(stage.name)
                            .font(.subheadline)

                        Spacer()

                        Text(stage.duration)
                            .font(.subheadline.monospacedDigit())
                            .foregroundStyle(themeManager.currentTheme.secondaryTextColor)
                    }
                }
            }
        }
        .padding(18)
        .themedCard()
    }

    private var sleepMetrics: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("睡眠期间")
                .font(.title3.bold())

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                sleepMetric(title: "平均心率", value: "54 bpm", symbol: "heart.fill")
                sleepMetric(title: "平均 HRV", value: "61 ms", symbol: "waveform.path.ecg")
                sleepMetric(title: "腕温偏差", value: "+0.1°C", symbol: "thermometer.medium")
                sleepMetric(title: "呼吸频率", value: "14.8 次/分", symbol: "lungs.fill")
            }
        }
    }

    /// 创建睡眠期间的单项指标卡片。
    private func sleepMetric(title: String, value: String, symbol: String) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: symbol)
                .foregroundStyle(themeManager.currentTheme.accentColor)

            Text(title)
                .font(.caption)
                .foregroundStyle(themeManager.currentTheme.secondaryTextColor)

            Text(value)
                .font(.headline)
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: 118, alignment: .topLeading)
        .themedCard()
    }
}

private struct SleepStage: Identifiable {
    let id = UUID()
    let name: String
    let duration: String
    let fraction: Double
    let color: Color
}

#Preview {
    SleepView()
        .environment(ThemeManager())
        .preferredColorScheme(.dark)
}
