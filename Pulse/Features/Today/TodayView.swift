import SwiftUI

struct TodayView: View {
    @Environment(ThemeManager.self) private var themeManager
    let snapshot: DailyHealthSnapshot

    private let metricColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 24) {
                    header

                    RecoveryRingView(
                        score: snapshot.recoveryScore,
                        status: snapshot.recoveryStatus,
                        percentile: snapshot.percentile
                    )
                    .padding(.vertical, 8)

                    metricSection

                    HealthInsightView(
                        status: snapshot.recoveryStatus,
                        insights: snapshot.insights
                    )

                    HealthTimelineView(events: snapshot.timeline)
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
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 5) {
                Text(greeting)
                    .font(.system(size: 30, weight: .bold, design: .rounded))

                Text(snapshot.date.pulseDateText)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(themeManager.currentTheme.secondaryTextColor)

                Text("演示数据")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(themeManager.currentTheme.accentColor)
            }

            Spacer()

            NavigationLink {
                SettingsView()
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 17, weight: .semibold))
                    .frame(width: 42, height: 42)
                    .background(.white.opacity(0.07), in: Circle())
                    .overlay {
                        Circle().stroke(.white.opacity(0.08), lineWidth: 1)
                    }
            }
            .buttonStyle(.plain)
            .accessibilityLabel("设置")
        }
    }

    private var metricSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionHeader(title: "今日核心指标", detail: "与个人基线比较")

            LazyVGrid(columns: metricColumns, spacing: 12) {
                ForEach(snapshot.metrics) { metric in
                    MetricCardView(metric: metric)
                }
            }
        }
    }

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: snapshot.date)

        switch hour {
        case 5..<12:
            return "早上好"
        case 12..<18:
            return "下午好"
        default:
            return "晚上好"
        }
    }

    /// 创建页面区块标题。
    private func sectionHeader(title: String, detail: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.title3.bold())

            Spacer()

            Text(detail)
                .font(.caption.weight(.medium))
                .foregroundStyle(themeManager.currentTheme.secondaryTextColor)
        }
    }
}

private extension Date {
    var pulseDateText: String {
        formatted(.dateTime.locale(Locale(identifier: "zh_CN")).month().day().weekday(.wide))
    }
}

#Preview {
    TodayView(snapshot: MockHealthData.today)
        .environment(ThemeManager())
        .environment(HealthKitManager())
        .preferredColorScheme(.dark)
}
