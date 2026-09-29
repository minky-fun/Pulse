import SwiftUI

struct ThemePreviewView: View {
    let theme: PulseTheme
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                ZStack {
                    theme.backgroundGradient

                    Circle()
                        .trim(from: 0, to: 0.82)
                        .stroke(theme.accentGradient, style: StrokeStyle(lineWidth: 7, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 72, height: 72)

                    Text("82")
                        .font(.system(size: 23, weight: .bold, design: .rounded))
                        .foregroundStyle(theme.primaryTextColor)
                }
                .frame(height: 154)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(alignment: .topTrailing) {
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title3)
                            .foregroundStyle(theme.accentColor)
                            .padding(10)
                    }
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(theme.name)
                        .font(.subheadline.bold())
                        .foregroundStyle(.primary)

                    Text(theme.author)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel("应用 \(theme.name) 主题")
    }
}

#Preview {
    let previewTheme = ThemeManager().availableThemes[1]

    ThemePreviewView(theme: previewTheme, isSelected: true) {}
        .frame(width: 180)
        .padding()
        .preferredColorScheme(.dark)
}
