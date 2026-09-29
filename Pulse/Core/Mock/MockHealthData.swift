import Foundation

enum MockHealthData {
    static let today = DailyHealthSnapshot(
        date: .now,
        recoveryScore: 82,
        recoveryStatus: "恢复良好",
        percentile: 63,
        metrics: [
            HealthMetric(
                title: "HRV",
                value: "56",
                unit: "ms",
                comparison: "+12%",
                summary: "高于个人基线",
                symbol: "waveform.path.ecg",
                direction: .up
            ),
            HealthMetric(
                title: "静息心率",
                value: "58",
                unit: "bpm",
                comparison: "-4",
                summary: "低于近期平均值",
                symbol: "heart.fill",
                direction: .down
            ),
            HealthMetric(
                title: "睡眠",
                value: "7h 36m",
                unit: "",
                comparison: "良好",
                summary: "规律性保持稳定",
                symbol: "moon.fill",
                direction: .stable
            ),
            HealthMetric(
                title: "呼吸频率",
                value: "15.2",
                unit: "次/分钟",
                comparison: "稳定",
                summary: "接近个人基线",
                symbol: "lungs.fill",
                direction: .stable
            )
        ],
        insights: [
            HealthInsight(text: "HRV 高于个人基线", tone: .positive),
            HealthInsight(text: "静息心率低于近期平均", tone: .positive),
            HealthInsight(text: "睡眠比平时少 21 分钟", tone: .neutral)
        ],
        timeline: [
            HealthTimelineEvent(time: "06:52", title: "起床", detail: "睡眠 7 小时 36 分", symbol: "sunrise.fill", kind: .wake),
            HealthTimelineEvent(time: "07:04", title: "HRV 63 ms", detail: "恢复状态较好", symbol: "waveform.path.ecg", kind: .hrv),
            HealthTimelineEvent(time: "09:28", title: "HRV 51 ms", detail: "状态正常", symbol: "waveform.path.ecg", kind: .hrv),
            HealthTimelineEvent(time: "11:36", title: "HRV 31 ms", detail: "身体负荷升高", symbol: "waveform.path.ecg", kind: .hrv),
            HealthTimelineEvent(time: "12:48", title: "HRV 46 ms", detail: "逐渐恢复", symbol: "waveform.path.ecg", kind: .hrv),
            HealthTimelineEvent(time: "18:32", title: "运动", detail: "43 分钟 · 活动能量 326 千卡", symbol: "figure.run", kind: .workout),
            HealthTimelineEvent(time: "23:16", title: "开始睡眠", detail: "入睡准备完成", symbol: "moon.zzz.fill", kind: .sleep)
        ]
    )

    static let trendPoints: [TrendPoint] = [
        TrendPoint(dayOffset: -6, score: 68),
        TrendPoint(dayOffset: -5, score: 74),
        TrendPoint(dayOffset: -4, score: 71),
        TrendPoint(dayOffset: -3, score: 79),
        TrendPoint(dayOffset: -2, score: 76),
        TrendPoint(dayOffset: -1, score: 85),
        TrendPoint(dayOffset: 0, score: 82)
    ]
}

struct TrendPoint: Identifiable, Sendable {
    let id: UUID
    let date: Date
    let score: Int

    /// 使用相对今天的天数创建趋势点。
    init(id: UUID = UUID(), dayOffset: Int, score: Int) {
        guard let date = Calendar.current.date(byAdding: .day, value: dayOffset, to: .now) else {
            preconditionFailure("无法计算趋势日期：\(dayOffset)")
        }

        self.id = id
        self.date = date
        self.score = score
    }
}
