# Pulse

Pulse 是一款面向 iOS 18+ 的个人健康状态分析 App。当前完成 Phase 1 的 SwiftUI 界面和 Phase 2 的 HealthKit 读取基础。

## Phase 1 数据流

`MockHealthData` 提供 `DailyHealthSnapshot`，视图通过 `TodayView` 展示恢复指数、核心指标、状态解释和身体时间线。`ThemeStore` 从应用资源读取 JSON，`ThemeManager` 管理当前主题，`ThemeRenderer` 为页面和卡片统一渲染主题。

## Phase 2 数据流

用户在“设置 > Apple 健康数据”中发起只读授权。`HealthKitManager` 管理请求与刷新状态，`HealthQueryService` 使用异步 HealthKit 查询读取最近 30 天的最新 HRV、静息心率、呼吸频率样本，以及最近 36 小时的睡眠阶段。结果仅保存在进程内并展示在健康数据页。HealthKit 不提供读取权限的明确授予状态，因此空读数不能被解释为已授权或已拒绝。

今天、趋势和睡眠页仍使用带“演示数据”标识的 Mock 内容。真实读数接入恢复分析和首页属于 Phase 3。

## 目录

- `Pulse/App`：App 入口和主 Tab。
- `Pulse/Core/Mock`：Phase 1 Mock 数据。
- `Pulse/Core/HealthKit`：授权管理和异步健康数据查询。
- `Pulse/Models`：健康快照与展示模型。
- `Pulse/Theme`：主题模型、JSON 仓库、状态管理和渲染器。
- `Pulse/Features`：今天、趋势、睡眠、主题和个人功能页。
- `Pulse/Resources/Themes`：内置主题 JSON。

## 运行

使用完整 Xcode 打开 `Pulse.xcodeproj`，选择 iOS 18 或更高版本的模拟器后运行 `Pulse` scheme。模拟器可检查界面和无数据状态；读取 Apple Watch 的真实样本需要在有健康记录的 iPhone 上运行，并在“设置 > Apple 健康数据”中授权。当前只读取本机数据，不上传健康数据。
