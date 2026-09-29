import SwiftUI

struct HealthTimelineView: View {
    @Environment(ThemeManager.self) private var themeManager
    let events: [HealthTimelineEvent]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("身体时间线")
                    .font(.title3.bold())

                Spacer()

                Image(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90")
                    .foregroundStyle(themeManager.currentTheme.secondaryTextColor)
            }

            VStack(spacing: 0) {
                ForEach(Array(events.enumerated()), id: \.element.id) { index, event in
                    timelineRow(event: event, showsConnector: index < events.count - 1)
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 6)
            .themedCard()
        }
    }

    /// 创建时间线中的单条事件，并根据位置显示连接线。
    private func timelineRow(event: HealthTimelineEvent, showsConnector: Bool) -> some View {
        HStack(alignment: .top, spacing: 13) {
            Text(event.time)
                .font(.caption.monospacedDigit().weight(.semibold))
                .foregroundStyle(themeManager.currentTheme.secondaryTextColor)
                .frame(width: 42, alignment: .leading)
                .padding(.top, 15)

            VStack(spacing: 0) {
                Image(systemName: event.symbol)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(themeManager.currentTheme.accentColor)
                    .frame(width: 30, height: 30)
                    .background(themeManager.currentTheme.accentColor.opacity(0.12), in: Circle())

                if showsConnector {
                    Rectangle()
                        .fill(.white.opacity(0.09))
                        .frame(width: 1, height: 35)
                }
            }
            .padding(.top, 8)

            VStack(alignment: .leading, spacing: 4) {
                Text(event.title)
                    .font(.subheadline.weight(.semibold))

                Text(event.detail)
                    .font(.caption)
                    .foregroundStyle(themeManager.currentTheme.secondaryTextColor)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity, minHeight: 65, alignment: .leading)
            .padding(.top, 12)
        }
    }
}

#Preview {
    HealthTimelineView(events: MockHealthData.today.timeline)
        .padding()
        .environment(ThemeManager())
        .preferredColorScheme(.dark)
        .themedPage()
}
