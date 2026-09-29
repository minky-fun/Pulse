import Foundation
import HealthKit
import Observation

@MainActor
@Observable
final class HealthKitManager {
    enum State: Equatable {
        case idle
        case loading
        case loaded
        case unavailable
        case failed(String)
    }

    private let healthStore = HKHealthStore()
    private let accessRequestedKey = "healthAccessRequested"

    private(set) var state: State = .idle
    private(set) var readings: HealthReadings?
    private(set) var lastUpdated: Date?
    private(set) var hasRequestedAccess: Bool

    /// 恢复用户是否发起过授权请求的记录，不将该记录视为实际授权状态。
    init() {
        hasRequestedAccess = UserDefaults.standard.bool(forKey: accessRequestedKey)
    }

    /// 请求四类健康数据的读取权限，并在系统流程结束后查询本地数据。
    func requestAccessAndLoad() async {
        guard HKHealthStore.isHealthDataAvailable() else {
            state = .unavailable
            return
        }

        state = .loading
        let readTypes: Set<HKObjectType> = [
            HKQuantityType(.heartRateVariabilitySDNN),
            HKQuantityType(.restingHeartRate),
            HKQuantityType(.respiratoryRate),
            HKCategoryType(.sleepAnalysis)
        ]

        do {
            try await healthStore.requestAuthorization(toShare: [], read: readTypes)
            hasRequestedAccess = true
            UserDefaults.standard.set(true, forKey: accessRequestedKey)
            await refresh()
        } catch {
            state = .failed(error.localizedDescription)
        }
    }

    /// 在用户已请求过访问后重新读取本机 HealthKit 数据。
    func refresh() async {
        guard hasRequestedAccess else { return }
        guard HKHealthStore.isHealthDataAvailable() else {
            state = .unavailable
            return
        }

        state = .loading
        do {
            readings = try await HealthQueryService(healthStore: healthStore).readLatest()
            lastUpdated = .now
            state = .loaded
        } catch {
            readings = nil
            state = .failed(error.localizedDescription)
        }
    }
}
