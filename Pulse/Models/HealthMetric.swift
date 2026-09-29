import Foundation

struct HealthMetric: Identifiable, Sendable {
    enum Direction: Equatable, Sendable {
        case up
        case down
        case stable
    }

    let id: UUID
    let title: String
    let value: String
    let unit: String
    let comparison: String
    let summary: String
    let symbol: String
    let direction: Direction

    /// 创建首页核心指标。
    init(
        id: UUID = UUID(),
        title: String,
        value: String,
        unit: String,
        comparison: String,
        summary: String,
        symbol: String,
        direction: Direction
    ) {
        self.id = id
        self.title = title
        self.value = value
        self.unit = unit
        self.comparison = comparison
        self.summary = summary
        self.symbol = symbol
        self.direction = direction
    }
}

struct HealthInsight: Identifiable, Sendable {
    enum Tone: Equatable, Sendable {
        case positive
        case neutral
    }

    let id: UUID
    let text: String
    let tone: Tone

    /// 创建一条恢复状态解释。
    init(id: UUID = UUID(), text: String, tone: Tone) {
        self.id = id
        self.text = text
        self.tone = tone
    }
}

struct HealthTimelineEvent: Identifiable, Sendable {
    enum Kind: Sendable {
        case wake
        case hrv
        case workout
        case sleep
    }

    let id: UUID
    let time: String
    let title: String
    let detail: String
    let symbol: String
    let kind: Kind

    /// 创建一条身体时间线事件。
    init(
        id: UUID = UUID(),
        time: String,
        title: String,
        detail: String,
        symbol: String,
        kind: Kind
    ) {
        self.id = id
        self.time = time
        self.title = title
        self.detail = detail
        self.symbol = symbol
        self.kind = kind
    }
}
