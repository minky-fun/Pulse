# Pulse

Pulse 是一款面向 iOS 18+ 的个人健康状态分析 App。当前仓库完成 Phase 1：SwiftUI 工程骨架、五个主 Tab、Mock 健康数据、完整今天页和 JSON 驱动的基础主题系统。

## Phase 1 数据流

`MockHealthData` 提供 `DailyHealthSnapshot`，视图通过 `TodayView` 展示恢复指数、核心指标、状态解释和身体时间线。`ThemeStore` 从应用资源读取 JSON，`ThemeManager` 管理当前主题，`ThemeRenderer` 为页面和卡片统一渲染主题。

## 目录

- `Pulse/App`：App 入口和主 Tab。
- `Pulse/Core/Mock`：Phase 1 Mock 数据。
- `Pulse/Models`：健康快照与展示模型。
- `Pulse/Theme`：主题模型、JSON 仓库、状态管理和渲染器。
- `Pulse/Features`：今天、趋势、睡眠、主题和个人功能页。
- `Pulse/Resources/Themes`：内置主题 JSON。

## 运行

使用完整 Xcode 打开 `Pulse.xcodeproj`，选择 iOS 18 或更高版本的模拟器后运行 `Pulse` scheme。Phase 1 不请求 HealthKit 权限，也不读取或上传真实健康数据。
