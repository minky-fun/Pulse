import Foundation

struct DailyHealthSnapshot: Identifiable, Sendable {
    let id: UUID
    let date: Date
    let recoveryScore: Int
    let recoveryStatus: String
    let percentile: Int
    let metrics: [HealthMetric]
    let insights: [HealthInsight]
    let timeline: [HealthTimelineEvent]

    /// 创建一天的健康快照。
    init(
        id: UUID = UUID(),
        date: Date,
        recoveryScore: Int,
        recoveryStatus: String,
        percentile: Int,
        metrics: [HealthMetric],
        insights: [HealthInsight],
        timeline: [HealthTimelineEvent]
    ) {
        self.id = id
        self.date = date
        self.recoveryScore = recoveryScore
        self.recoveryStatus = recoveryStatus
        self.percentile = percentile
        self.metrics = metrics
        self.insights = insights
        self.timeline = timeline
    }
}
