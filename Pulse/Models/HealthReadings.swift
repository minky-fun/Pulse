import Foundation

struct HealthMeasurement: Sendable {
    let value: Double
    let date: Date
}

struct SleepReading: Sendable {
    let minutes: Int
    let startDate: Date
    let endDate: Date
}

struct HealthReadings: Sendable {
    let hrv: HealthMeasurement?
    let restingHeartRate: HealthMeasurement?
    let respiratoryRate: HealthMeasurement?
    let sleep: SleepReading?

    var isEmpty: Bool {
        hrv == nil && restingHeartRate == nil && respiratoryRate == nil && sleep == nil
    }
}
