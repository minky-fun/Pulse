import SwiftUI

struct HealthDataView: View {
    @Environment(HealthKitManager.self) private var healthKitManager

    var body: some View {
        List {
            Section {
                Label("健康数据仅在这台设备上读取和处理", systemImage: "lock.shield.fill")
                    .font(.subheadline)

                switch healthKitManager.state {
                case .idle:
                    Text("连接 Apple 健康后可查看本机读数。")
                        .foregroundStyle(.secondary)
                case .loading:
                    ProgressView("正在读取健康数据")
                case .loaded:
                    if healthKitManager.readings?.isEmpty == true {
                        Text("暂无可读取的数据。可能尚无记录，或尚未允许 Pulse 读取。")
                            .foregroundStyle(.secondary)
                    } else if let lastUpdated = healthKitManager.lastUpdated {
                        Text("更新于 \(lastUpdated.formatted(date: .abbreviated, time: .shortened))")
                            .foregroundStyle(.secondary)
                    }
                case .unavailable:
                    Text("这台设备不支持 Apple 健康数据。")
                        .foregroundStyle(.secondary)
                case let .failed(message):
                    Text(message)
                        .foregroundStyle(.red)
                }

                Button {
                    Task {
                        if healthKitManager.hasRequestedAccess {
                            await healthKitManager.refresh()
                        } else {
                            await healthKitManager.requestAccessAndLoad()
                        }
                    }
                } label: {
                    Label(
                        healthKitManager.hasRequestedAccess ? "刷新健康数据" : "连接 Apple 健康",
                        systemImage: "heart.text.square"
                    )
                }
                .disabled(healthKitManager.state == .loading)
            }

            Section("最近 30 天的最新读数") {
                measurementRow("HRV", measurement: healthKitManager.readings?.hrv, unit: "ms")
                measurementRow("静息心率", measurement: healthKitManager.readings?.restingHeartRate, unit: "次/分钟")
                measurementRow("呼吸频率", measurement: healthKitManager.readings?.respiratoryRate, unit: "次/分钟")
            }

            Section("近 36 小时累计睡眠") {
                if let sleep = healthKitManager.readings?.sleep {
                    LabeledContent("已记录睡眠", value: "\(sleep.minutes / 60) 小时 \(sleep.minutes % 60) 分钟")
                    LabeledContent("记录范围", value: "\(sleep.startDate.formatted(date: .abbreviated, time: .shortened)) - \(sleep.endDate.formatted(date: .abbreviated, time: .shortened))")
                } else {
                    LabeledContent("已记录睡眠", value: "暂无数据")
                }
            }

            Section {
                Text("若读数为空，请在系统设置中检查 Pulse 的健康数据读取权限。")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("健康数据")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            if healthKitManager.hasRequestedAccess && healthKitManager.state == .idle {
                await healthKitManager.refresh()
            }
        }
    }

    /// 展示一个真实 HealthKit 定量样本及其采样时间。
    private func measurementRow(
        _ title: String,
        measurement: HealthMeasurement?,
        unit: String
    ) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                if let measurement {
                    Text(measurement.date.formatted(date: .abbreviated, time: .shortened))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()

            if let measurement {
                Text("\(measurement.value, specifier: "%.1f") \(unit)")
                    .font(.subheadline.monospacedDigit())
            } else {
                Text("暂无数据")
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    NavigationStack {
        HealthDataView()
    }
    .environment(HealthKitManager())
}
