import Foundation
import HealthKit

struct HealthQueryService {
    private let healthStore: HKHealthStore

    /// 创建使用同一 HealthKit 存储的查询服务。
    init(healthStore: HKHealthStore) {
        self.healthStore = healthStore
    }

    /// 读取最近 30 天的最新定量样本及最近 36 小时的睡眠阶段。
    func readLatest(now: Date = .now) async throws -> HealthReadings {
        async let hrv = latestQuantity(
            .heartRateVariabilitySDNN,
            unit: .secondUnit(with: .milli),
            since: now.addingTimeInterval(-30 * 24 * 60 * 60),
            until: now
        )
        async let restingHeartRate = latestQuantity(
            .restingHeartRate,
            unit: .count().unitDivided(by: .minute()),
            since: now.addingTimeInterval(-30 * 24 * 60 * 60),
            until: now
        )
        async let respiratoryRate = latestQuantity(
            .respiratoryRate,
            unit: .count().unitDivided(by: .minute()),
            since: now.addingTimeInterval(-30 * 24 * 60 * 60),
            until: now
        )
        async let sleep = recentSleep(since: now.addingTimeInterval(-36 * 60 * 60), until: now)

        return try await HealthReadings(
            hrv: hrv,
            restingHeartRate: restingHeartRate,
            respiratoryRate: respiratoryRate,
            sleep: sleep
        )
    }

    /// 查询指定类型最近的一条定量样本。
    private func latestQuantity(
        _ identifier: HKQuantityTypeIdentifier,
        unit: HKUnit,
        since startDate: Date,
        until endDate: Date
    ) async throws -> HealthMeasurement? {
        let type = HKQuantityType(identifier)
        let datePredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let descriptor = HKSampleQueryDescriptor<HKQuantitySample>(
            predicates: [.quantitySample(type: type, predicate: datePredicate)],
            sortDescriptors: [SortDescriptor(\.endDate, order: .reverse)],
            limit: 1
        )

        guard let sample = try await descriptor.result(for: healthStore).first else {
            return nil
        }

        return HealthMeasurement(value: sample.quantity.doubleValue(for: unit), date: sample.endDate)
    }

    /// 合并重叠的睡眠阶段，避免不同来源的样本重复累计时长。
    private func recentSleep(since startDate: Date, until endDate: Date) async throws -> SleepReading? {
        let type = HKCategoryType(.sleepAnalysis)
        let datePredicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate)
        let descriptor = HKSampleQueryDescriptor<HKCategorySample>(
            predicates: [.categorySample(type: type, predicate: datePredicate)],
            sortDescriptors: [SortDescriptor(\.startDate)]
        )
        let samples = try await descriptor.result(for: healthStore)
        let intervals = samples.compactMap { sample -> DateInterval? in
            guard let stage = HKCategoryValueSleepAnalysis(rawValue: sample.value),
                  [.asleepUnspecified, .asleepCore, .asleepDeep, .asleepREM].contains(stage) else {
                return nil
            }

            let start = max(sample.startDate, startDate)
            let end = min(sample.endDate, endDate)
            return end > start ? DateInterval(start: start, end: end) : nil
        }
        .sorted { $0.start < $1.start }

        guard let first = intervals.first else {
            return nil
        }

        var merged: [DateInterval] = [first]
        for interval in intervals.dropFirst() {
            let previous = merged[merged.count - 1]
            if interval.start <= previous.end {
                merged[merged.count - 1] = DateInterval(
                    start: previous.start,
                    end: max(previous.end, interval.end)
                )
            } else {
                merged.append(interval)
            }
        }

        let duration = merged.reduce(0.0) { $0 + $1.duration }
        return SleepReading(
            minutes: Int(duration / 60),
            startDate: first.start,
            endDate: merged[merged.count - 1].end
        )
    }
}
